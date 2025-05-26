/// API endpoints and HTTP constants for network layer
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // Base URLs for different environments
  static const String devBaseUrl = 'https://api-dev.example.com';
  static const String stagingBaseUrl = 'https://api-staging.example.com';
  static const String prodBaseUrl = 'https://api.example.com';

  // API Versions
  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // Authentication Endpoints
  static const String loginEndpoint = '$apiPrefix/auth/login';
  static const String registerEndpoint = '$apiPrefix/auth/register';
  static const String refreshTokenEndpoint = '$apiPrefix/auth/refresh';
  static const String logoutEndpoint = '$apiPrefix/auth/logout';
  static const String forgotPasswordEndpoint =
      '$apiPrefix/auth/forgot-password';
  static const String resetPasswordEndpoint = '$apiPrefix/auth/reset-password';
  static const String verifyEmailEndpoint = '$apiPrefix/auth/verify-email';

  // User Endpoints
  static const String userProfileEndpoint = '$apiPrefix/user/profile';
  static const String updateProfileEndpoint = '$apiPrefix/user/profile';
  static const String changePasswordEndpoint =
      '$apiPrefix/user/change-password';
  static const String deleteAccountEndpoint = '$apiPrefix/user/delete';
  static const String uploadAvatarEndpoint = '$apiPrefix/user/avatar';

  // Settings Endpoints
  static const String userSettingsEndpoint = '$apiPrefix/user/settings';
  static const String notificationSettingsEndpoint =
      '$apiPrefix/user/settings/notifications';
  static const String privacySettingsEndpoint =
      '$apiPrefix/user/settings/privacy';

  // Content Endpoints
  static const String postsEndpoint = '$apiPrefix/posts';
  static const String commentsEndpoint = '$apiPrefix/comments';
  static const String likesEndpoint = '$apiPrefix/likes';
  static const String sharesEndpoint = '$apiPrefix/shares';

  // File Upload Endpoints
  static const String uploadEndpoint = '$apiPrefix/upload';
  static const String downloadEndpoint = '$apiPrefix/download';
  static const String deleteFileEndpoint = '$apiPrefix/files';

  // HTTP Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'Accept';
  static const String userAgentHeader = 'User-Agent';
  static const String acceptLanguageHeader = 'Accept-Language';

  // Content Types
  static const String jsonContentType = 'application/json';
  static const String formDataContentType = 'multipart/form-data';
  static const String urlEncodedContentType =
      'application/x-www-form-urlencoded';

  // HTTP Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusAccepted = 202;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusMethodNotAllowed = 405;
  static const int statusConflict = 409;
  static const int statusUnprocessableEntity = 422;
  static const int statusTooManyRequests = 429;
  static const int statusInternalServerError = 500;
  static const int statusBadGateway = 502;
  static const int statusServiceUnavailable = 503;
  static const int statusGatewayTimeout = 504;

  // Request Parameters
  static const String pageParam = 'page';
  static const String limitParam = 'limit';
  static const String sortParam = 'sort';
  static const String orderParam = 'order';
  static const String searchParam = 'search';
  static const String filterParam = 'filter';

  // Sort Orders
  static const String ascOrder = 'asc';
  static const String descOrder = 'desc';

  // Cache Control
  static const String cacheControlHeader = 'Cache-Control';
  static const String noCacheValue = 'no-cache';
  static const String maxAgeValue = 'max-age=300'; // 5 minutes

  // Error Codes (Custom API Error Codes)
  static const String invalidCredentialsCode = 'INVALID_CREDENTIALS';
  static const String userNotFoundCode = 'USER_NOT_FOUND';
  static const String emailAlreadyExistsCode = 'EMAIL_ALREADY_EXISTS';
  static const String invalidTokenCode = 'INVALID_TOKEN';
  static const String tokenExpiredCode = 'TOKEN_EXPIRED';
  static const String insufficientPermissionsCode = 'INSUFFICIENT_PERMISSIONS';
  static const String validationErrorCode = 'VALIDATION_ERROR';
  static const String serverErrorCode = 'SERVER_ERROR';
  static const String networkErrorCode = 'NETWORK_ERROR';
  static const String timeoutErrorCode = 'TIMEOUT_ERROR';
}
