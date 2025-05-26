/// Application-wide constants for timeouts, limits, and configurations
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'Flutter Starter Template';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Timeouts (in milliseconds)
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
  static const int cacheTimeout = 300000; // 5 minutes

  // Retry Configuration
  static const int maxRetryAttempts = 3;
  static const int retryDelay = 1000; // 1 second

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Upload
  static const int maxFileSize = 10485760; // 10MB in bytes
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt'
  ];

  // Cache Keys
  static const String userCacheKey = 'user_cache';
  static const String settingsCacheKey = 'settings_cache';
  static const String themeCacheKey = 'theme_cache';
  static const String languageCacheKey = 'language_cache';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String biometricEnabledKey = 'biometric_enabled';

  // Validation Limits
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 500;

  // Animation Durations (in milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Debounce Delays (in milliseconds)
  static const int searchDebounceDelay = 500;
  static const int buttonDebounceDelay = 300;

  // Error Messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'Please check your internet connection.';
  static const String timeoutErrorMessage =
      'Request timed out. Please try again.';
  static const String unauthorizedErrorMessage =
      'You are not authorized to perform this action.';

  // Success Messages
  static const String saveSuccessMessage = 'Changes saved successfully!';
  static const String deleteSuccessMessage = 'Item deleted successfully!';
  static const String updateSuccessMessage = 'Updated successfully!';

  // Feature Flags
  static const bool enableBiometrics = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
}
