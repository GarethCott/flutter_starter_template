import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../config/flavor_config.dart';
import '../logging/app_logger.dart';

/// Crash reporting service for the application
///
/// Integrates with external crash reporting services like
/// Firebase Crashlytics or Sentry for production error tracking.
class CrashReporter {
  static CrashReporter? _instance;
  static CrashReporter get instance => _instance ??= CrashReporter._internal();

  bool _isInitialized = false;

  CrashReporter._internal();

  /// Initialize crash reporting
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Only initialize in production or staging
      if (FlavorConfig.instance.flavor == Flavor.dev) {
        logger.debug('Crash reporting disabled in development');
        return;
      }

      if (!AppConfig.instance.enableCrashReporting) {
        logger.debug('Crash reporting disabled by configuration');
        return;
      }

      await _initializeCrashlytics();
      await _initializeSentry();

      _isInitialized = true;
      logger.info('Crash reporting initialized successfully');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize crash reporting',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Initialize Firebase Crashlytics
  Future<void> _initializeCrashlytics() async {
    try {
      // TODO: Implement Firebase Crashlytics initialization
      // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      if (kDebugMode) {
        developer.log('Firebase Crashlytics would be initialized here');
      }
    } catch (e) {
      logger.warning('Failed to initialize Firebase Crashlytics: $e');
    }
  }

  /// Initialize Sentry
  Future<void> _initializeSentry() async {
    try {
      final sentryDsn = AppConfig.instance.sentryDsn;
      if (sentryDsn.isEmpty) {
        logger.debug('Sentry DSN not configured');
        return;
      }

      // TODO: Implement Sentry initialization
      // await SentryFlutter.init((options) {
      //   options.dsn = sentryDsn;
      //   options.environment = FlavorConfig.instance.name.toLowerCase();
      //   options.release = AppConfig.instance.appVersion;
      // });

      if (kDebugMode) {
        developer.log('Sentry would be initialized here with DSN: $sentryDsn');
      }
    } catch (e) {
      logger.warning('Failed to initialize Sentry: $e');
    }
  }

  /// Report a non-fatal error
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? context,
    bool fatal = false,
  }) async {
    if (!_shouldReport()) return;

    try {
      // Add app context
      final enrichedContext = <String, dynamic>{
        'app_version': AppConfig.instance.appVersion,
        'flavor': FlavorConfig.instance.name,
        'timestamp': DateTime.now().toIso8601String(),
        ...?context,
      };

      await _reportToCrashlytics(
          error, stackTrace, reason, enrichedContext, fatal);
      await _reportToSentry(error, stackTrace, reason, enrichedContext, fatal);

      // Log locally
      if (fatal) {
        logger.fatal(reason ?? 'Fatal error occurred',
            error: error, stackTrace: stackTrace, extra: enrichedContext);
      } else {
        logger.error(reason ?? 'Error occurred',
            error: error, stackTrace: stackTrace, extra: enrichedContext);
      }
    } catch (e) {
      logger.warning('Failed to report error to crash reporting service: $e');
    }
  }

  /// Report a fatal error
  Future<void> recordFatalError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? context,
  }) async {
    await recordError(
      error,
      stackTrace,
      reason: reason,
      context: context,
      fatal: true,
    );
  }

  /// Report to Firebase Crashlytics
  Future<void> _reportToCrashlytics(
    dynamic error,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic> context,
    bool fatal,
  ) async {
    try {
      // TODO: Implement Firebase Crashlytics reporting
      // if (fatal) {
      //   await FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      // } else {
      //   await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      // }

      if (kDebugMode) {
        developer.log(
          'Would report to Crashlytics: ${fatal ? 'FATAL' : 'ERROR'} - $reason',
          error: error,
          stackTrace: stackTrace,
        );
      }
    } catch (e) {
      logger.warning('Failed to report to Crashlytics: $e');
    }
  }

  /// Report to Sentry
  Future<void> _reportToSentry(
    dynamic error,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic> context,
    bool fatal,
  ) async {
    try {
      // TODO: Implement Sentry reporting
      // await Sentry.captureException(
      //   error,
      //   stackTrace: stackTrace,
      //   withScope: (scope) {
      //     scope.setLevel(fatal ? SentryLevel.fatal : SentryLevel.error);
      //     scope.setTag('reason', reason ?? 'unknown');
      //     for (final entry in context.entries) {
      //       scope.setExtra(entry.key, entry.value);
      //     }
      //   },
      // );

      if (kDebugMode) {
        developer.log(
          'Would report to Sentry: ${fatal ? 'FATAL' : 'ERROR'} - $reason',
          error: error,
          stackTrace: stackTrace,
        );
      }
    } catch (e) {
      logger.warning('Failed to report to Sentry: $e');
    }
  }

  /// Set user information for crash reporting
  Future<void> setUserInfo({
    required String userId,
    String? email,
    String? username,
    Map<String, dynamic>? customData,
  }) async {
    if (!_shouldReport()) return;

    try {
      // TODO: Set user info in crash reporting services
      // await FirebaseCrashlytics.instance.setUserIdentifier(userId);
      // await Sentry.configureScope((scope) {
      //   scope.setUser(SentryUser(
      //     id: userId,
      //     email: email,
      //     username: username,
      //     data: customData,
      //   ));
      // });

      logger.debug('User info set for crash reporting', extra: {
        'userId': userId,
        'email': email,
        'username': username,
      });
    } catch (e) {
      logger.warning('Failed to set user info: $e');
    }
  }

  /// Set custom key-value data
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!_shouldReport()) return;

    try {
      // TODO: Set custom data in crash reporting services
      // await FirebaseCrashlytics.instance.setCustomKey(key, value);
      // await Sentry.configureScope((scope) {
      //   scope.setExtra(key, value);
      // });

      logger.debug('Custom key set for crash reporting', extra: {
        'key': key,
        'value': value,
      });
    } catch (e) {
      logger.warning('Failed to set custom key: $e');
    }
  }

  /// Log a custom message
  Future<void> log(String message, {Map<String, dynamic>? data}) async {
    if (!_shouldReport()) return;

    try {
      // TODO: Log to crash reporting services
      // await FirebaseCrashlytics.instance.log(message);
      // await Sentry.addBreadcrumb(Breadcrumb(
      //   message: message,
      //   data: data,
      //   timestamp: DateTime.now(),
      // ));

      logger.info('Crash reporting log: $message', extra: data);
    } catch (e) {
      logger.warning('Failed to log to crash reporting: $e');
    }
  }

  /// Check if crash reporting should be active
  bool _shouldReport() {
    return _isInitialized &&
        AppConfig.instance.enableCrashReporting &&
        FlavorConfig.instance.flavor != Flavor.dev;
  }

  /// Test crash reporting (for debugging)
  Future<void> testCrash() async {
    if (FlavorConfig.instance.flavor == Flavor.prod) {
      logger.warning('Test crash disabled in production');
      return;
    }

    logger.warning('Testing crash reporting...');
    await recordError(
      Exception('Test crash from CrashReporter'),
      StackTrace.current,
      reason: 'Testing crash reporting functionality',
      context: {'test': true},
    );
  }

  /// Get crash reporting status
  Map<String, dynamic> getStatus() {
    return {
      'initialized': _isInitialized,
      'enabled': AppConfig.instance.enableCrashReporting,
      'flavor': FlavorConfig.instance.name,
      'shouldReport': _shouldReport(),
    };
  }
}
