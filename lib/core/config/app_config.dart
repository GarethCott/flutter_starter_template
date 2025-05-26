import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavor_config.dart';

/// Central configuration class for the application
class AppConfig {
  static AppConfig? _instance;

  /// Private constructor
  AppConfig._();

  /// Get the singleton instance
  static AppConfig get instance {
    _instance ??= AppConfig._();
    return _instance!;
  }

  /// Initialize the app configuration
  static Future<void> initialize() async {
    // Load environment variables based on flavor
    final flavor = FlavorConfig.instance.flavor;
    String envFile;

    switch (flavor) {
      case Flavor.dev:
        envFile = 'assets/env/.env.dev';
        break;
      case Flavor.staging:
        envFile = 'assets/env/.env.staging';
        break;
      case Flavor.prod:
        envFile = 'assets/env/.env.prod';
        break;
    }

    try {
      await dotenv.load(fileName: envFile);
    } catch (e) {
      // Fallback to default values if env file is not found
      print('Warning: Could not load $envFile, using default values');
    }
  }

  // App Information
  String get appName => _getEnvValue('APP_NAME', FlavorConfig.instance.appName);
  String get appVersion => _getEnvValue('APP_VERSION', '1.0.0+1');
  String get appSuffix =>
      _getEnvValue('APP_SUFFIX', FlavorConfig.instance.appSuffix);

  // API Configuration
  String get apiBaseUrl =>
      _getEnvValue('API_BASE_URL', FlavorConfig.instance.apiBaseUrl);
  String get graphqlUrl => _getEnvValue('GRAPHQL_URL', '$apiBaseUrl/graphql');
  int get apiTimeout =>
      int.tryParse(_getEnvValue('API_TIMEOUT', '30000')) ?? 30000;
  String get apiVersion => _getEnvValue('API_VERSION', 'v1');

  // Feature Flags
  bool get enableLogging =>
      _getBoolEnvValue('ENABLE_LOGGING', FlavorConfig.instance.enableLogging);
  bool get enableDebugBanner => _getBoolEnvValue(
      'ENABLE_DEBUG_BANNER', FlavorConfig.instance.enableDebugBanner);
  bool get enablePerformanceOverlay =>
      _getBoolEnvValue('ENABLE_PERFORMANCE_OVERLAY', false);
  bool get enableAnalytics => _getBoolEnvValue(
      'ENABLE_ANALYTICS', FlavorConfig.instance.enableAnalytics);
  bool get enableCrashReporting => _getBoolEnvValue(
      'ENABLE_CRASH_REPORTING', FlavorConfig.instance.enableCrashReporting);

  // Database Configuration
  String get databaseName =>
      _getEnvValue('DATABASE_NAME', 'flutter_starter.db');
  int get databaseVersion =>
      int.tryParse(_getEnvValue('DATABASE_VERSION', '1')) ?? 1;

  // Authentication
  String get authDomain => _getEnvValue('AUTH_DOMAIN', 'example.com');
  String get authClientId => _getEnvValue('AUTH_CLIENT_ID', '');

  // Third-party Services
  String get firebaseProjectId => _getEnvValue('FIREBASE_PROJECT_ID', '');
  String get sentryDsn => _getEnvValue('SENTRY_DSN', '');

  // UI Configuration
  String get themeMode => _getEnvValue('THEME_MODE', 'system');
  String get primaryColor => _getEnvValue('PRIMARY_COLOR', '0xFF6750A4');
  bool get enableMaterialYou => _getBoolEnvValue('ENABLE_MATERIAL_YOU', true);

  // Development Tools
  bool get enableInspector =>
      _getBoolEnvValue('ENABLE_INSPECTOR', FlavorConfig.instance.isDev);
  bool get enableWidgetInspector =>
      _getBoolEnvValue('ENABLE_WIDGET_INSPECTOR', FlavorConfig.instance.isDev);
  bool get enablePerformanceMonitoring => _getBoolEnvValue(
      'ENABLE_PERFORMANCE_MONITORING',
      FlavorConfig.instance.enablePerformanceMonitoring);

  // Logging Configuration
  String get logLevel =>
      _getEnvValue('LOG_LEVEL', FlavorConfig.instance.isDev ? 'debug' : 'info');
  bool get logToConsole =>
      _getBoolEnvValue('LOG_TO_CONSOLE', FlavorConfig.instance.isDev);
  bool get logToFile => _getBoolEnvValue('LOG_TO_FILE', false);

  // Network Configuration
  bool get enableCertificatePinning => _getBoolEnvValue(
      'ENABLE_CERTIFICATE_PINNING', FlavorConfig.instance.isProd);
  bool get enableNetworkLogging =>
      _getBoolEnvValue('ENABLE_NETWORK_LOGGING', FlavorConfig.instance.isDev);

  // Cache Configuration
  int get cacheDuration =>
      int.tryParse(_getEnvValue('CACHE_DURATION', '300')) ?? 300;
  String get maxCacheSize => _getEnvValue('MAX_CACHE_SIZE', '50MB');

  /// Helper method to get environment value with fallback
  String _getEnvValue(String key, String defaultValue) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// Helper method to get boolean environment value with fallback
  bool _getBoolEnvValue(String key, bool defaultValue) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }

  /// Get the full app name with suffix
  String get fullAppName => '$appName$appSuffix';

  /// Check if the app is running in debug mode
  bool get isDebugMode => FlavorConfig.instance.isDev;

  /// Check if the app is running in release mode
  bool get isReleaseMode => FlavorConfig.instance.isProd;

  /// Get current flavor name
  String get flavorName => FlavorConfig.instance.name;

  /// Print configuration summary (for debugging)
  void printConfigSummary() {
    if (!enableLogging) return;

    print('=== App Configuration Summary ===');
    print('Flavor: $flavorName');
    print('App Name: $fullAppName');
    print('App Version: $appVersion');
    print('API Base URL: $apiBaseUrl');
    print('Enable Logging: $enableLogging');
    print('Enable Analytics: $enableAnalytics');
    print('Enable Crash Reporting: $enableCrashReporting');
    print('================================');
  }
}
