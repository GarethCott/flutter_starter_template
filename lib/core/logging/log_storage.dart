import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Local storage for application logs
///
/// Handles file-based log storage with rotation, cleanup,
/// and export functionality for debugging and support.
class LogStorage {
  static const String _logDirectory = 'logs';
  static const String _logFilePrefix = 'app_log';
  static const String _logFileExtension = '.log';
  static const int _maxLogFiles = 7; // Keep logs for 7 days
  static const int _maxLogFileSize = 10 * 1024 * 1024; // 10MB per file

  Directory? _logsDir;
  File? _currentLogFile;

  /// Initialize log storage
  Future<void> initialize() async {
    if (kIsWeb) return; // No file storage on web

    try {
      final appDir = await getApplicationDocumentsDirectory();
      _logsDir = Directory('${appDir.path}/$_logDirectory');

      if (!await _logsDir!.exists()) {
        await _logsDir!.create(recursive: true);
      }

      await _initializeCurrentLogFile();
      await _cleanupOldLogs();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize log storage: $e');
      }
    }
  }

  /// Get current log file
  File get currentLogFile {
    _currentLogFile ??= _createLogFile();
    return _currentLogFile!;
  }

  /// Create a new log file with timestamp
  File _createLogFile() {
    final timestamp = DateTime.now().toIso8601String().split('T')[0];
    final filename = '$_logFilePrefix-$timestamp$_logFileExtension';
    return File('${_logsDir!.path}/$filename');
  }

  /// Initialize current log file
  Future<void> _initializeCurrentLogFile() async {
    if (_logsDir == null) return;

    final today = DateTime.now().toIso8601String().split('T')[0];
    final todayLogFile =
        File('${_logsDir!.path}/$_logFilePrefix-$today$_logFileExtension');

    if (await todayLogFile.exists()) {
      final stat = await todayLogFile.stat();
      if (stat.size < _maxLogFileSize) {
        _currentLogFile = todayLogFile;
        return;
      }
    }

    _currentLogFile = _createLogFile();
  }

  /// Write log entry to file
  Future<void> writeLog(String logEntry) async {
    if (kIsWeb || _currentLogFile == null) return;

    try {
      // Check if current file is too large
      if (await _currentLogFile!.exists()) {
        final stat = await _currentLogFile!.stat();
        if (stat.size >= _maxLogFileSize) {
          await _rotateLogFile();
        }
      }

      // Write log entry
      await _currentLogFile!.writeAsString(
        '$logEntry\n',
        mode: FileMode.append,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to write log: $e');
      }
    }
  }

  /// Rotate log file when it gets too large
  Future<void> _rotateLogFile() async {
    if (_currentLogFile == null || _logsDir == null) return;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newName = '${_currentLogFile!.path}.$timestamp';
      await _currentLogFile!.rename(newName);

      _currentLogFile = _createLogFile();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to rotate log file: $e');
      }
    }
  }

  /// Clean up old log files
  Future<void> clearOldLogs() async {
    if (kIsWeb || _logsDir == null) return;

    try {
      final files = await _logsDir!.list().toList();
      final logFiles = files
          .whereType<File>()
          .where((file) => file.path.contains(_logFilePrefix))
          .toList();

      // Sort by modification time (newest first)
      logFiles.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return bStat.modified.compareTo(aStat.modified);
      });

      // Keep only the most recent files
      if (logFiles.length > _maxLogFiles) {
        final filesToDelete = logFiles.skip(_maxLogFiles);
        for (final file in filesToDelete) {
          try {
            await file.delete();
          } catch (e) {
            if (kDebugMode) {
              print('Failed to delete old log file: ${file.path}, error: $e');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to cleanup old logs: $e');
      }
    }
  }

  /// Get all log files
  Future<List<File>> getLogFiles() async {
    if (kIsWeb || _logsDir == null) return [];

    try {
      final files = await _logsDir!.list().toList();
      return files
          .whereType<File>()
          .where((file) => file.path.contains(_logFilePrefix))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get log files: $e');
      }
      return [];
    }
  }

  /// Export all logs as a single string
  Future<String> exportLogs() async {
    if (kIsWeb) return 'Log export not available on web platform';

    try {
      final logFiles = await getLogFiles();
      if (logFiles.isEmpty) {
        return 'No log files found';
      }

      // Sort files by name (which includes date)
      logFiles.sort((a, b) => a.path.compareTo(b.path));

      final buffer = StringBuffer();
      buffer.writeln('=== Application Logs Export ===');
      buffer.writeln('Export Date: ${DateTime.now().toIso8601String()}');
      buffer.writeln('Total Files: ${logFiles.length}');
      buffer.writeln('');

      for (final file in logFiles) {
        try {
          buffer.writeln('=== ${file.path.split('/').last} ===');
          final content = await file.readAsString();
          buffer.writeln(content);
          buffer.writeln('');
        } catch (e) {
          buffer.writeln('Error reading file ${file.path}: $e');
          buffer.writeln('');
        }
      }

      return buffer.toString();
    } catch (e) {
      return 'Failed to export logs: $e';
    }
  }

  /// Get log statistics
  Future<Map<String, dynamic>> getLogStats() async {
    if (kIsWeb) {
      return {
        'platform': 'web',
        'fileCount': 0,
        'totalSize': 0,
        'message': 'File logging not available on web',
      };
    }

    try {
      final logFiles = await getLogFiles();
      int totalSize = 0;

      for (final file in logFiles) {
        final stat = await file.stat();
        totalSize += stat.size;
      }

      return {
        'platform': Platform.operatingSystem,
        'fileCount': logFiles.length,
        'totalSize': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
        'maxFiles': _maxLogFiles,
        'maxFileSizeMB': (_maxLogFileSize / (1024 * 1024)).toStringAsFixed(2),
        'logDirectory': _logsDir?.path ?? 'Not initialized',
      };
    } catch (e) {
      return {
        'error': 'Failed to get log stats: $e',
      };
    }
  }

  /// Clear all log files
  Future<void> clearAllLogs() async {
    if (kIsWeb || _logsDir == null) return;

    try {
      final logFiles = await getLogFiles();
      for (final file in logFiles) {
        try {
          await file.delete();
        } catch (e) {
          if (kDebugMode) {
            print('Failed to delete log file: ${file.path}, error: $e');
          }
        }
      }

      // Recreate current log file
      _currentLogFile = _createLogFile();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear all logs: $e');
      }
    }
  }

  /// Cleanup old logs (called periodically)
  Future<void> _cleanupOldLogs() async {
    await clearOldLogs();
  }
}
