/// Centralized API endpoint management
///
/// Provides a structured way to manage all API endpoints and URL construction
/// throughout the application with environment-specific configurations.
library;

import '../config/app_config.dart';

/// API endpoint management class
class ApiEndpoints {
  ApiEndpoints._();

  /// Get the base URL for the current environment
  static String get baseUrl => AppConfig.instance.apiBaseUrl;

  /// Get the GraphQL endpoint for the current environment
  static String get graphqlUrl => AppConfig.instance.graphqlUrl;

  /// API version prefix
  static const String apiVersion = '/api/v1';

  /// Full API base URL with version
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // ========== Authentication Endpoints ==========

  /// Authentication base path
  static const String _authPath = '/auth';

  /// Login endpoint
  static String get login => '$apiBaseUrl$_authPath/login';

  /// Register endpoint
  static String get register => '$apiBaseUrl$_authPath/register';

  /// Logout endpoint
  static String get logout => '$apiBaseUrl$_authPath/logout';

  /// Refresh token endpoint
  static String get refreshToken => '$apiBaseUrl$_authPath/refresh';

  /// Forgot password endpoint
  static String get forgotPassword => '$apiBaseUrl$_authPath/forgot-password';

  /// Reset password endpoint
  static String get resetPassword => '$apiBaseUrl$_authPath/reset-password';

  /// Verify email endpoint
  static String get verifyEmail => '$apiBaseUrl$_authPath/verify-email';

  /// Resend email verification endpoint
  static String get resendEmailVerification =>
      '$apiBaseUrl$_authPath/resend-verification';

  /// Change password endpoint
  static String get changePassword => '$apiBaseUrl$_authPath/change-password';

  /// Verify phone endpoint
  static String get verifyPhone => '$apiBaseUrl$_authPath/verify-phone';

  /// Send phone verification endpoint
  static String get sendPhoneVerification =>
      '$apiBaseUrl$_authPath/send-phone-verification';

  // ========== User Endpoints ==========

  /// User base path
  static const String _userPath = '/users';

  /// Get current user profile
  static String get userProfile => '$apiBaseUrl$_userPath/profile';

  /// Update user profile
  static String get updateProfile => '$apiBaseUrl$_userPath/profile';

  /// Get user by ID
  static String getUserById(String userId) => '$apiBaseUrl$_userPath/$userId';

  /// Upload user avatar
  static String get uploadAvatar => '$apiBaseUrl$_userPath/avatar';

  /// Delete user account
  static String get deleteAccount => '$apiBaseUrl$_userPath/account';

  // ========== Settings Endpoints ==========

  /// Settings base path
  static const String _settingsPath = '/settings';

  /// Get user settings
  static String get userSettings => '$apiBaseUrl$_settingsPath';

  /// Update user settings
  static String get updateSettings => '$apiBaseUrl$_settingsPath';

  /// Get app configuration
  static String get appConfig => '$apiBaseUrl$_settingsPath/app-config';

  // ========== File Upload Endpoints ==========

  /// File upload base path
  static const String _filesPath = '/files';

  /// Upload file endpoint
  static String get uploadFile => '$apiBaseUrl$_filesPath/upload';

  /// Download file endpoint
  static String getDownloadFile(String fileId) =>
      '$apiBaseUrl$_filesPath/$fileId';

  /// Delete file endpoint
  static String getDeleteFile(String fileId) =>
      '$apiBaseUrl$_filesPath/$fileId';

  // ========== Notification Endpoints ==========

  /// Notifications base path
  static const String _notificationsPath = '/notifications';

  /// Get notifications
  static String get notifications => '$apiBaseUrl$_notificationsPath';

  /// Mark notification as read
  static String markNotificationRead(String notificationId) =>
      '$apiBaseUrl$_notificationsPath/$notificationId/read';

  /// Mark all notifications as read
  static String get markAllNotificationsRead =>
      '$apiBaseUrl$_notificationsPath/read-all';

  /// Delete notification
  static String deleteNotification(String notificationId) =>
      '$apiBaseUrl$_notificationsPath/$notificationId';

  // ========== Search Endpoints ==========

  /// Search base path
  static const String _searchPath = '/search';

  /// Global search endpoint
  static String get search => '$apiBaseUrl$_searchPath';

  /// Search with filters
  static String getSearchWithFilters(Map<String, String> filters) {
    final queryParams = filters.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return '$search?$queryParams';
  }

  // ========== Utility Methods ==========

  /// Build URL with query parameters
  static String buildUrlWithParams(
      String baseUrl, Map<String, dynamic> params) {
    if (params.isEmpty) return baseUrl;

    final queryParams = params.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return '$baseUrl?$queryParams';
  }

  /// Build paginated URL
  static String buildPaginatedUrl(
    String baseUrl, {
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    Map<String, dynamic>? filters,
  }) {
    final params = <String, dynamic>{};

    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;

    if (filters != null) {
      params.addAll(filters);
    }

    return buildUrlWithParams(baseUrl, params);
  }

  /// Validate URL format
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Get environment-specific endpoint
  static String getEnvironmentEndpoint(String path) {
    return '$baseUrl$path';
  }
}

/// HTTP methods enumeration
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE'),
  head('HEAD'),
  options('OPTIONS');

  const HttpMethod(this.value);

  final String value;

  @override
  String toString() => value;
}

/// API endpoint configuration
class ApiEndpointConfig {
  /// Endpoint URL
  final String url;

  /// HTTP method
  final HttpMethod method;

  /// Whether authentication is required
  final bool requiresAuth;

  /// Request timeout in milliseconds
  final int? timeoutMs;

  /// Whether to cache the response
  final bool cacheable;

  /// Cache duration in seconds
  final int? cacheDurationSeconds;

  /// Custom headers for this endpoint
  final Map<String, String>? headers;

  const ApiEndpointConfig({
    required this.url,
    required this.method,
    this.requiresAuth = true,
    this.timeoutMs,
    this.cacheable = false,
    this.cacheDurationSeconds,
    this.headers,
  });

  /// Create a copy with updated values
  ApiEndpointConfig copyWith({
    String? url,
    HttpMethod? method,
    bool? requiresAuth,
    int? timeoutMs,
    bool? cacheable,
    int? cacheDurationSeconds,
    Map<String, String>? headers,
  }) {
    return ApiEndpointConfig(
      url: url ?? this.url,
      method: method ?? this.method,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      timeoutMs: timeoutMs ?? this.timeoutMs,
      cacheable: cacheable ?? this.cacheable,
      cacheDurationSeconds: cacheDurationSeconds ?? this.cacheDurationSeconds,
      headers: headers ?? this.headers,
    );
  }

  @override
  String toString() {
    return 'ApiEndpointConfig(url: $url, method: $method, requiresAuth: $requiresAuth)';
  }
}

/// Predefined endpoint configurations
class EndpointConfigs {
  EndpointConfigs._();

  /// Authentication endpoints
  static const Map<String, ApiEndpointConfig> auth = {
    'login': ApiEndpointConfig(
      url: '/auth/login',
      method: HttpMethod.post,
      requiresAuth: false,
      timeoutMs: 10000,
    ),
    'register': ApiEndpointConfig(
      url: '/auth/register',
      method: HttpMethod.post,
      requiresAuth: false,
      timeoutMs: 10000,
    ),
    'logout': ApiEndpointConfig(
      url: '/auth/logout',
      method: HttpMethod.post,
      requiresAuth: true,
    ),
    'refreshToken': ApiEndpointConfig(
      url: '/auth/refresh',
      method: HttpMethod.post,
      requiresAuth: false,
      timeoutMs: 5000,
    ),
  };

  /// User endpoints
  static const Map<String, ApiEndpointConfig> user = {
    'profile': ApiEndpointConfig(
      url: '/users/profile',
      method: HttpMethod.get,
      requiresAuth: true,
      cacheable: true,
      cacheDurationSeconds: 300, // 5 minutes
    ),
    'updateProfile': ApiEndpointConfig(
      url: '/users/profile',
      method: HttpMethod.put,
      requiresAuth: true,
    ),
    'uploadAvatar': ApiEndpointConfig(
      url: '/users/avatar',
      method: HttpMethod.post,
      requiresAuth: true,
      timeoutMs: 30000, // 30 seconds for file upload
    ),
  };

  /// Settings endpoints
  static const Map<String, ApiEndpointConfig> settings = {
    'get': ApiEndpointConfig(
      url: '/settings',
      method: HttpMethod.get,
      requiresAuth: true,
      cacheable: true,
      cacheDurationSeconds: 600, // 10 minutes
    ),
    'update': ApiEndpointConfig(
      url: '/settings',
      method: HttpMethod.put,
      requiresAuth: true,
    ),
  };

  /// Get endpoint configuration by category and name
  static ApiEndpointConfig? getConfig(String category, String name) {
    switch (category) {
      case 'auth':
        return auth[name];
      case 'user':
        return user[name];
      case 'settings':
        return settings[name];
      default:
        return null;
    }
  }
}
