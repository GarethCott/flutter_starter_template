import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../config/app_config.dart';

/// Custom log formatter for the application
///
/// Provides structured, readable log output with timestamps,
/// log levels, and environment-specific formatting.
class AppLogFormatter extends LogPrinter {
  static final _levelColors = {
    Level.debug: AnsiColor.fg(8), // Gray
    Level.info: AnsiColor.fg(12), // Light blue
    Level.warning: AnsiColor.fg(208), // Orange
    Level.error: AnsiColor.fg(196), // Red
    Level.fatal: AnsiColor.fg(199), // Pink
  };

  static final _levelEmojis = {
    Level.debug: '🐛',
    Level.info: 'ℹ️',
    Level.warning: '⚠️',
    Level.error: '❌',
    Level.fatal: '💀',
  };

  static final _levelNames = {
    Level.debug: 'DEBUG',
    Level.info: 'INFO',
    Level.warning: 'WARN',
    Level.error: 'ERROR',
    Level.fatal: 'FATAL',
  };

  @override
  List<String> log(LogEvent event) {
    final color = _levelColors[event.level] ?? AnsiColor.none();
    final emoji = _levelEmojis[event.level] ?? '';
    final levelName = _levelNames[event.level] ?? 'UNKNOWN';

    final timestamp = _formatTimestamp(event.time);
    final message = _formatMessage(event.message);
    final error = _formatError(event.error);
    final stackTrace = _formatStackTrace(event.stackTrace);

    final lines = <String>[];

    // Main log line
    if (kDebugMode && !kIsWeb) {
      // Colorized output for debug mode
      lines.add(color('$timestamp [$levelName] $emoji $message'));
    } else {
      // Plain text for production/web
      lines.add('$timestamp [$levelName] $message');
    }

    // Add error if present
    if (error.isNotEmpty) {
      lines.add(error);
    }

    // Add stack trace if present
    if (stackTrace.isNotEmpty) {
      lines.addAll(stackTrace);
    }

    return lines;
  }

  String _formatTimestamp(DateTime time) {
    return time.toIso8601String();
  }

  String _formatMessage(dynamic message) {
    if (message is String) {
      return message;
    } else if (message is Map || message is List) {
      return message.toString();
    } else {
      return message?.toString() ?? 'null';
    }
  }

  String _formatError(Object? error) {
    if (error == null) return '';

    return 'Error: ${error.toString()}';
  }

  List<String> _formatStackTrace(StackTrace? stackTrace) {
    if (stackTrace == null) return [];

    final lines = stackTrace.toString().split('\n');
    final formattedLines = <String>[];

    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        formattedLines.add('  $line');
      }
    }

    return formattedLines;
  }
}

/// Simple log formatter for production environments
class ProductionLogFormatter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final timestamp = event.time.toIso8601String();
    final levelName = _getLevelName(event.level);
    final message = event.message?.toString() ?? '';

    final logLine = '$timestamp [$levelName] $message';

    if (event.error != null) {
      return [
        logLine,
        'Error: ${event.error}',
      ];
    }

    return [logLine];
  }

  String _getLevelName(Level level) {
    switch (level) {
      case Level.debug:
        return 'DEBUG';
      case Level.info:
        return 'INFO';
      case Level.warning:
        return 'WARN';
      case Level.error:
        return 'ERROR';
      case Level.fatal:
        return 'FATAL';
      default:
        return 'UNKNOWN';
    }
  }
}

/// JSON log formatter for structured logging
class JsonLogFormatter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final logData = {
      'timestamp': event.time.toIso8601String(),
      'level': _getLevelName(event.level),
      'message': event.message?.toString(),
      'environment': AppConfig.instance.flavorName,
    };

    if (event.error != null) {
      logData['error'] = event.error.toString();
    }

    if (event.stackTrace != null) {
      logData['stackTrace'] = event.stackTrace.toString();
    }

    // Add app metadata
    logData.addAll({
      'app_version': AppConfig.instance.appVersion,
      'app_flavor': AppConfig.instance.flavorName,
    });

    return [_encodeJson(logData)];
  }

  String _getLevelName(Level level) {
    switch (level) {
      case Level.debug:
        return 'debug';
      case Level.info:
        return 'info';
      case Level.warning:
        return 'warning';
      case Level.error:
        return 'error';
      case Level.fatal:
        return 'fatal';
      default:
        return 'unknown';
    }
  }

  String _encodeJson(Map<String, dynamic> data) {
    try {
      return data.toString(); // Simple toString for now
      // TODO: Use proper JSON encoding when dart:convert is available
    } catch (e) {
      return 'Failed to encode log data: $e';
    }
  }
}
