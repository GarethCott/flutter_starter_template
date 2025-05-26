import 'dart:collection';

import '../config/app_config.dart';
import '../config/flavor_config.dart';
import '../logging/app_logger.dart';
import 'crash_reporter.dart';

/// Error tracking and analytics service
///
/// Monitors and analyzes non-fatal errors to provide insights
/// into app stability and user experience issues.
class ErrorTracker {
  static ErrorTracker? _instance;
  static ErrorTracker get instance => _instance ??= ErrorTracker._internal();

  final Queue<ErrorEvent> _errorHistory = Queue<ErrorEvent>();
  final Map<String, int> _errorCounts = <String, int>{};
  final Map<String, DateTime> _lastErrorTimes = <String, DateTime>{};

  static const int _maxHistorySize = 100;
  static const Duration _errorCooldown = Duration(minutes: 5);

  ErrorTracker._internal();

  /// Track a non-fatal error
  Future<void> trackError({
    required dynamic error,
    StackTrace? stackTrace,
    String? context,
    String? userId,
    Map<String, dynamic>? metadata,
    ErrorSeverity severity = ErrorSeverity.medium,
  }) async {
    try {
      final errorEvent = ErrorEvent(
        error: error,
        stackTrace: stackTrace,
        context: context,
        userId: userId,
        metadata: metadata ?? {},
        severity: severity,
        timestamp: DateTime.now(),
        flavor: FlavorConfig.instance.name,
        appVersion: AppConfig.instance.appVersion,
      );

      _addToHistory(errorEvent);
      _updateErrorCounts(errorEvent);

      // Log the error
      _logError(errorEvent);

      // Report to crash reporting if severe enough
      if (severity == ErrorSeverity.high ||
          severity == ErrorSeverity.critical) {
        await CrashReporter.instance.recordError(
          error,
          stackTrace,
          reason: context,
          context: {
            'severity': severity.name,
            'userId': userId,
            ...metadata ?? {},
          },
        );
      }

      // Check for error patterns
      _analyzeErrorPatterns(errorEvent);
    } catch (e, st) {
      logger.warning('Failed to track error', error: e, stackTrace: st);
    }
  }

  /// Track a user action error
  Future<void> trackUserActionError({
    required String action,
    required dynamic error,
    String? screen,
    String? userId,
    Map<String, dynamic>? parameters,
  }) async {
    await trackError(
      error: error,
      context: 'User action: $action',
      userId: userId,
      metadata: {
        'action': action,
        'screen': screen,
        'parameters': parameters,
      },
      severity: ErrorSeverity.medium,
    );
  }

  /// Track a network error
  Future<void> trackNetworkError({
    required String url,
    required int statusCode,
    required dynamic error,
    String? method,
    String? userId,
    Duration? duration,
  }) async {
    await trackError(
      error: error,
      context: 'Network error: $method $url',
      userId: userId,
      metadata: {
        'url': url,
        'method': method,
        'statusCode': statusCode,
        'duration_ms': duration?.inMilliseconds,
      },
      severity: _getNetworkErrorSeverity(statusCode),
    );
  }

  /// Track a UI error
  Future<void> trackUIError({
    required String widget,
    required dynamic error,
    StackTrace? stackTrace,
    String? screen,
    String? userId,
    Map<String, dynamic>? widgetProperties,
  }) async {
    await trackError(
      error: error,
      stackTrace: stackTrace,
      context: 'UI error in $widget',
      userId: userId,
      metadata: {
        'widget': widget,
        'screen': screen,
        'widgetProperties': widgetProperties,
      },
      severity: ErrorSeverity.medium,
    );
  }

  /// Track a business logic error
  Future<void> trackBusinessLogicError({
    required String operation,
    required dynamic error,
    String? userId,
    Map<String, dynamic>? operationData,
  }) async {
    await trackError(
      error: error,
      context: 'Business logic error: $operation',
      userId: userId,
      metadata: {
        'operation': operation,
        'operationData': operationData,
      },
      severity: ErrorSeverity.high,
    );
  }

  /// Add error to history
  void _addToHistory(ErrorEvent errorEvent) {
    _errorHistory.add(errorEvent);

    // Keep history size manageable
    while (_errorHistory.length > _maxHistorySize) {
      _errorHistory.removeFirst();
    }
  }

  /// Update error counts
  void _updateErrorCounts(ErrorEvent errorEvent) {
    final errorKey = _getErrorKey(errorEvent);
    _errorCounts[errorKey] = (_errorCounts[errorKey] ?? 0) + 1;
    _lastErrorTimes[errorKey] = errorEvent.timestamp;
  }

  /// Log the error appropriately
  void _logError(ErrorEvent errorEvent) {
    final extra = {
      'context': errorEvent.context,
      'severity': errorEvent.severity.name,
      'userId': errorEvent.userId,
      'flavor': errorEvent.flavor,
      'appVersion': errorEvent.appVersion,
      ...errorEvent.metadata,
    };

    switch (errorEvent.severity) {
      case ErrorSeverity.low:
        logger.debug('Low severity error tracked', extra: extra);
        break;
      case ErrorSeverity.medium:
        logger.info('Medium severity error tracked', extra: extra);
        break;
      case ErrorSeverity.high:
        logger.warning('High severity error tracked',
            error: errorEvent.error,
            stackTrace: errorEvent.stackTrace,
            extra: extra);
        break;
      case ErrorSeverity.critical:
        logger.error('Critical error tracked',
            error: errorEvent.error,
            stackTrace: errorEvent.stackTrace,
            extra: extra);
        break;
    }
  }

  /// Analyze error patterns
  void _analyzeErrorPatterns(ErrorEvent errorEvent) {
    final errorKey = _getErrorKey(errorEvent);
    final count = _errorCounts[errorKey] ?? 0;

    // Check for frequent errors
    if (count > 5) {
      logger.warning('Frequent error detected', extra: {
        'errorKey': errorKey,
        'count': count,
        'context': errorEvent.context,
      });
    }

    // Check for error spikes
    final recentErrors = _getRecentErrors(Duration(minutes: 10));
    if (recentErrors.length > 10) {
      logger.warning('Error spike detected', extra: {
        'recentErrorCount': recentErrors.length,
        'timeWindow': '10 minutes',
      });
    }
  }

  /// Get error key for grouping
  String _getErrorKey(ErrorEvent errorEvent) {
    final errorType = errorEvent.error.runtimeType.toString();
    final context = errorEvent.context ?? 'unknown';
    return '$errorType:$context';
  }

  /// Get network error severity based on status code
  ErrorSeverity _getNetworkErrorSeverity(int statusCode) {
    if (statusCode >= 500) return ErrorSeverity.high;
    if (statusCode >= 400) return ErrorSeverity.medium;
    return ErrorSeverity.low;
  }

  /// Get recent errors within time window
  List<ErrorEvent> _getRecentErrors(Duration timeWindow) {
    final cutoff = DateTime.now().subtract(timeWindow);
    return _errorHistory
        .where((event) => event.timestamp.isAfter(cutoff))
        .toList();
  }

  /// Get error statistics
  Map<String, dynamic> getErrorStats() {
    final now = DateTime.now();
    final last24Hours = now.subtract(Duration(hours: 24));
    final lastHour = now.subtract(Duration(hours: 1));

    final errors24h = _errorHistory
        .where((event) => event.timestamp.isAfter(last24Hours))
        .toList();

    final errorsLastHour = _errorHistory
        .where((event) => event.timestamp.isAfter(lastHour))
        .toList();

    final severityCounts = <String, int>{};
    for (final event in errors24h) {
      final severity = event.severity.name;
      severityCounts[severity] = (severityCounts[severity] ?? 0) + 1;
    }

    return {
      'totalErrors': _errorHistory.length,
      'errors24h': errors24h.length,
      'errorsLastHour': errorsLastHour.length,
      'severityCounts': severityCounts,
      'topErrors': _getTopErrors(),
      'errorRate24h': errors24h.length / 24.0, // errors per hour
    };
  }

  /// Get top errors by frequency
  List<Map<String, dynamic>> _getTopErrors({int limit = 10}) {
    final sortedErrors = _errorCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedErrors
        .take(limit)
        .map((entry) => {
              'errorKey': entry.key,
              'count': entry.value,
              'lastOccurrence': _lastErrorTimes[entry.key]?.toIso8601String(),
            })
        .toList();
  }

  /// Export error data for analysis
  Map<String, dynamic> exportErrorData() {
    return {
      'exportTimestamp': DateTime.now().toIso8601String(),
      'appVersion': AppConfig.instance.appVersion,
      'flavor': FlavorConfig.instance.name,
      'errorHistory': _errorHistory.map((event) => event.toMap()).toList(),
      'errorCounts': _errorCounts,
      'stats': getErrorStats(),
    };
  }

  /// Clear error history
  void clearHistory() {
    _errorHistory.clear();
    _errorCounts.clear();
    _lastErrorTimes.clear();
    logger.info('Error tracking history cleared');
  }

  /// Check if error should be throttled
  bool _shouldThrottleError(String errorKey) {
    final lastTime = _lastErrorTimes[errorKey];
    if (lastTime == null) return false;

    return DateTime.now().difference(lastTime) < _errorCooldown;
  }
}

/// Error severity levels
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

/// Error event data structure
class ErrorEvent {
  final dynamic error;
  final StackTrace? stackTrace;
  final String? context;
  final String? userId;
  final Map<String, dynamic> metadata;
  final ErrorSeverity severity;
  final DateTime timestamp;
  final String flavor;
  final String appVersion;

  ErrorEvent({
    required this.error,
    this.stackTrace,
    this.context,
    this.userId,
    required this.metadata,
    required this.severity,
    required this.timestamp,
    required this.flavor,
    required this.appVersion,
  });

  Map<String, dynamic> toMap() {
    return {
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'context': context,
      'userId': userId,
      'metadata': metadata,
      'severity': severity.name,
      'timestamp': timestamp.toIso8601String(),
      'flavor': flavor,
      'appVersion': appVersion,
    };
  }
}
