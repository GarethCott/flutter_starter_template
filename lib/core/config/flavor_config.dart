/// Defines the different build flavors for the application
enum Flavor {
  dev,
  staging,
  prod,
}

/// Configuration class for managing different build flavors
class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String appName;
  final String appSuffix;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableDebugBanner;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool enablePerformanceMonitoring;

  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.appName,
    required this.appSuffix,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableDebugBanner,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.enablePerformanceMonitoring,
  });

  /// Current flavor configuration instance
  static FlavorConfig? _instance;

  /// Get the current flavor configuration
  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception(
          'FlavorConfig not initialized. Call FlavorConfig.initialize() first.');
    }
    return _instance!;
  }

  /// Initialize the flavor configuration
  static void initialize(Flavor flavor) {
    _instance = _createConfig(flavor);
  }

  /// Create configuration based on flavor
  static FlavorConfig _createConfig(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return FlavorConfig._(
          flavor: Flavor.dev,
          name: 'Development',
          appName: 'Flutter Starter (Dev)',
          appSuffix: '.dev',
          apiBaseUrl: 'https://api-dev.example.com',
          enableLogging: true,
          enableDebugBanner: true,
          enableAnalytics: false,
          enableCrashReporting: false,
          enablePerformanceMonitoring: false,
        );
      case Flavor.staging:
        return FlavorConfig._(
          flavor: Flavor.staging,
          name: 'Staging',
          appName: 'Flutter Starter (Staging)',
          appSuffix: '.staging',
          apiBaseUrl: 'https://api-staging.example.com',
          enableLogging: true,
          enableDebugBanner: false,
          enableAnalytics: true,
          enableCrashReporting: true,
          enablePerformanceMonitoring: true,
        );
      case Flavor.prod:
        return FlavorConfig._(
          flavor: Flavor.prod,
          name: 'Production',
          appName: 'Flutter Starter',
          appSuffix: '',
          apiBaseUrl: 'https://api.example.com',
          enableLogging: false,
          enableDebugBanner: false,
          enableAnalytics: true,
          enableCrashReporting: true,
          enablePerformanceMonitoring: true,
        );
    }
  }

  /// Check if current flavor is development
  bool get isDev => flavor == Flavor.dev;

  /// Check if current flavor is staging
  bool get isStaging => flavor == Flavor.staging;

  /// Check if current flavor is production
  bool get isProd => flavor == Flavor.prod;

  /// Get the full app name with suffix
  String get fullAppName => '$appName$appSuffix';

  @override
  String toString() {
    return 'FlavorConfig{flavor: $flavor, name: $name, appName: $appName}';
  }
}
