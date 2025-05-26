import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../config/flavor_config.dart';
import 'log_formatter.dart';
import 'log_storage.dart';

/// Centralized logging system for the application
///
/// Provides different log levels, environment-aware configuration,
/// and integration with local storage and crash reporting.
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._internal();

  late final Logger _logger;
  late final LogStorage _logStorage;

  AppLogger._internal() {
    _logStorage = LogStorage();
    _logStorage.initialize();
    _initializeLogger();
  }

  void _initializeLogger() {
    _logger = Logger(
      filter: _getLogFilter(),
      printer: AppLogFormatter(),
      output: _getLogOutput(),
      level: _getLogLevel(),
    );
  }

  /// Get log filter based on environment
  LogFilter _getLogFilter() {
    if (kDebugMode) {
      return DevelopmentFilter();
    } else {
      return ProductionFilter();
    }
  }

  /// Get log output destinations
  LogOutput _getLogOutput() {
    final outputs = <LogOutput>[
      ConsoleOutput(),
    ];

    // Add file output for non-web platforms
    if (!kIsWeb) {
      outputs.add(FileOutput(file: _logStorage.currentLogFile));
    }

    return MultiOutput(outputs);
  }

  /// Get log level based on environment
  Level _getLogLevel() {
    switch (FlavorConfig.instance.flavor) {
      case Flavor.dev:
        return Level.debug;
      case Flavor.staging:
        return Level.info;
      case Flavor.prod:
        return Level.warning;
    }
  }

  /// Log debug message
  void debug(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _logger.d(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );

    if (extra != null) {
      _logExtra('DEBUG', extra);
    }
  }

  /// Log info message
  void info(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _logger.i(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );

    if (extra != null) {
      _logExtra('INFO', extra);
    }
  }

  /// Log warning message
  void warning(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _logger.w(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );

    if (extra != null) {
      _logExtra('WARNING', extra);
    }
  }

  /// Log error message
  void error(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _logger.e(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );

    if (extra != null) {
      _logExtra('ERROR', extra);
    }

    // Send to crash reporting in production
    if (FlavorConfig.instance.flavor == Flavor.prod) {
      _reportToCrashlytics(message, error, stackTrace, extra);
    }
  }

  /// Log fatal error message
  void fatal(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _logger.f(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );

    if (extra != null) {
      _logExtra('FATAL', extra);
    }

    // Always send fatal errors to crash reporting
    _reportToCrashlytics(message, error, stackTrace, extra);
  }

  /// Log network request
  void logNetworkRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic body,
    int? statusCode,
    String? responseBody,
    Duration? duration,
  }) {
    final extra = <String, dynamic>{
      'method': method,
      'url': url,
      'statusCode': statusCode,
      'duration_ms': duration?.inMilliseconds,
    };

    if (headers != null) extra['headers'] = headers;
    if (body != null) extra['requestBody'] = body;
    if (responseBody != null) extra['responseBody'] = responseBody;

    if (statusCode != null && statusCode >= 400) {
      error('Network request failed', extra: extra);
    } else {
      debug('Network request completed', extra: extra);
    }
  }

  /// Log user action
  void logUserAction({
    required String action,
    String? screen,
    Map<String, dynamic>? parameters,
  }) {
    final extra = <String, dynamic>{
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (screen != null) extra['screen'] = screen;
    if (parameters != null) extra['parameters'] = parameters;

    info('User action: $action', extra: extra);
  }

  /// Log performance metric
  void logPerformance({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? metadata,
  }) {
    final extra = <String, dynamic>{
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (metadata != null) extra.addAll(metadata);

    if (duration.inMilliseconds > 1000) {
      warning('Slow operation detected: $operation', extra: extra);
    } else {
      debug('Performance: $operation', extra: extra);
    }
  }

  /// Log app lifecycle event
  void logAppLifecycle(String event, {Map<String, dynamic>? extra}) {
    info('App lifecycle: $event', extra: extra);
  }

  /// Log extra data with structured format
  void _logExtra(String level, Map<String, dynamic> extra) {
    if (kDebugMode) {
      developer.log(
        'Extra data: ${extra.toString()}',
        name: 'AppLogger.$level',
      );
    }
  }

  /// Report to crash reporting service
  void _reportToCrashlytics(
    dynamic message,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  ) {
    // TODO: Integrate with Firebase Crashlytics or Sentry
    // This will be implemented in the crash_reporter.dart
    if (kDebugMode) {
      developer.log(
        'Would report to crashlytics: $message',
        name: 'AppLogger.Crashlytics',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Clear old logs
  Future<void> clearOldLogs() async {
    await _logStorage.clearOldLogs();
  }

  /// Get log files for debugging
  Future<List<File>> getLogFiles() async {
    return _logStorage.getLogFiles();
  }

  /// Export logs for support
  Future<String> exportLogs() async {
    return _logStorage.exportLogs();
  }

  /// Close logger and cleanup resources
  void close() {
    _logger.close();
  }
}

/// Console output for logger
class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      if (kDebugMode) {
        print(line);
      }
    }
  }
}

/// File output for logger
class FileOutput extends LogOutput {
  final File file;

  FileOutput({required this.file});

  @override
  void output(OutputEvent event) {
    if (kIsWeb) return;

    try {
      final sink = file.openWrite(mode: FileMode.append);
      for (final line in event.lines) {
        sink.writeln(line);
      }
      sink.close();
    } catch (e) {
      // Fallback to console if file writing fails
      if (kDebugMode) {
        print('Failed to write to log file: $e');
        for (final line in event.lines) {
          print(line);
        }
      }
    }
  }
}

/// Multiple output destinations
class MultiOutput extends LogOutput {
  final List<LogOutput> outputs;

  MultiOutput(this.outputs);

  @override
  void output(OutputEvent event) {
    for (final output in outputs) {
      output.output(event);
    }
  }
}

/// Global logger instance for easy access
final logger = AppLogger.instance;
