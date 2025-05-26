/// API error models for comprehensive error handling
///
/// Provides structured error handling for network and API-related errors
/// throughout the application.
library;

/// Base API error class
abstract class ApiError {
  /// Error message
  final String message;

  /// Error code (can be HTTP status code or custom error code)
  final String? code;

  /// Additional error details
  final Map<String, dynamic>? details;

  /// Timestamp when the error occurred
  final DateTime timestamp;

  ApiError({
    required this.message,
    this.code,
    this.details,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Convert to a user-friendly message
  String get userMessage => message;

  /// Check if this error should be retried
  bool get isRetryable => false;

  /// Check if this error requires user authentication
  bool get requiresAuth => false;

  @override
  String toString() {
    return 'ApiError(message: $message, code: $code)';
  }
}

/// Network connectivity errors
class NetworkError extends ApiError {
  NetworkError({
    required super.message,
    super.code,
    super.details,
    super.timestamp,
  });

  /// No internet connection
  factory NetworkError.noConnection() {
    return NetworkError(
      message: 'No internet connection available',
      code: 'NO_CONNECTION',
    );
  }

  /// Connection timeout
  factory NetworkError.timeout() {
    return NetworkError(
      message: 'Request timed out',
      code: 'TIMEOUT',
    );
  }

  /// DNS resolution failed
  factory NetworkError.dnsFailure() {
    return NetworkError(
      message: 'Failed to resolve server address',
      code: 'DNS_FAILURE',
    );
  }

  /// SSL/TLS certificate error
  factory NetworkError.certificateError() {
    return NetworkError(
      message: 'SSL certificate verification failed',
      code: 'CERTIFICATE_ERROR',
    );
  }

  @override
  bool get isRetryable => true;

  @override
  String get userMessage {
    switch (code) {
      case 'NO_CONNECTION':
        return 'Please check your internet connection and try again.';
      case 'TIMEOUT':
        return 'The request took too long. Please try again.';
      case 'DNS_FAILURE':
        return 'Unable to connect to the server. Please try again later.';
      case 'CERTIFICATE_ERROR':
        return 'Security certificate error. Please contact support.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }
}

/// HTTP status code errors
class HttpError extends ApiError {
  /// HTTP status code
  final int statusCode;

  HttpError({
    required this.statusCode,
    required super.message,
    super.code,
    super.details,
    super.timestamp,
  });

  /// Create from HTTP status code
  factory HttpError.fromStatusCode(
    int statusCode, {
    String? message,
    String? code,
    Map<String, dynamic>? details,
  }) {
    final defaultMessage = _getDefaultMessageForStatusCode(statusCode);

    return HttpError(
      statusCode: statusCode,
      message: message ?? defaultMessage,
      code: code ?? statusCode.toString(),
      details: details,
    );
  }

  /// Bad request (400)
  factory HttpError.badRequest({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return HttpError(
      statusCode: 400,
      message: message ?? 'Invalid request',
      code: 'BAD_REQUEST',
      details: details,
    );
  }

  /// Unauthorized (401)
  factory HttpError.unauthorized({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return HttpError(
      statusCode: 401,
      message: message ?? 'Authentication required',
      code: 'UNAUTHORIZED',
      details: details,
    );
  }

  /// Forbidden (403)
  factory HttpError.forbidden({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return HttpError(
      statusCode: 403,
      message: message ?? 'Access denied',
      code: 'FORBIDDEN',
      details: details,
    );
  }

  /// Not found (404)
  factory HttpError.notFound({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return HttpError(
      statusCode: 404,
      message: message ?? 'Resource not found',
      code: 'NOT_FOUND',
      details: details,
    );
  }

  /// Validation error (422)
  factory HttpError.validationError({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return HttpError(
      statusCode: 422,
      message: message ?? 'Validation failed',
      code: 'VALIDATION_ERROR',
      details: details,
    );
  }

  /// Internal server error (500)
  factory HttpError.serverError({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return HttpError(
      statusCode: 500,
      message: message ?? 'Internal server error',
      code: 'SERVER_ERROR',
      details: details,
    );
  }

  /// Service unavailable (503)
  factory HttpError.serviceUnavailable({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return HttpError(
      statusCode: 503,
      message: message ?? 'Service temporarily unavailable',
      code: 'SERVICE_UNAVAILABLE',
      details: details,
    );
  }

  /// Check if this is a client error (4xx)
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Check if this is a server error (5xx)
  bool get isServerError => statusCode >= 500;

  /// Check if this is an authentication error
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  @override
  bool get requiresAuth => statusCode == 401;

  @override
  bool get isRetryable =>
      isServerError || statusCode == 408 || statusCode == 429;

  @override
  String get userMessage {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input and try again.';
      case 401:
        return 'Please log in to continue.';
      case 403:
        return 'You don\'t have permission to access this resource.';
      case 404:
        return 'The requested resource was not found.';
      case 408:
        return 'Request timed out. Please try again.';
      case 422:
        return 'Please check your input and try again.';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Service temporarily unavailable. Please try again later.';
      case 503:
        return 'Service temporarily unavailable. Please try again later.';
      case 504:
        return 'Request timed out. Please try again later.';
      default:
        if (isClientError) {
          return 'Request error. Please check your input and try again.';
        } else if (isServerError) {
          return 'Server error. Please try again later.';
        } else {
          return message;
        }
    }
  }

  static String _getDefaultMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 408:
        return 'Request Timeout';
      case 422:
        return 'Unprocessable Entity';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';
      default:
        return 'HTTP Error $statusCode';
    }
  }

  @override
  String toString() {
    return 'HttpError(statusCode: $statusCode, message: $message, code: $code)';
  }
}

/// Parsing and serialization errors
class ParseError extends ApiError {
  ParseError({
    required super.message,
    super.code,
    super.details,
    super.timestamp,
  });

  /// JSON parsing error
  factory ParseError.json({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return ParseError(
      message: message ?? 'Failed to parse JSON response',
      code: 'JSON_PARSE_ERROR',
      details: details,
    );
  }

  /// Invalid response format
  factory ParseError.invalidFormat({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return ParseError(
      message: message ?? 'Invalid response format',
      code: 'INVALID_FORMAT',
      details: details,
    );
  }

  @override
  String get userMessage => 'Invalid server response. Please try again.';
}

/// Business logic errors
class BusinessError extends ApiError {
  BusinessError({
    required super.message,
    super.code,
    super.details,
    super.timestamp,
  });

  /// Validation failed
  factory BusinessError.validation({
    required String message,
    Map<String, dynamic>? details,
  }) {
    return BusinessError(
      message: message,
      code: 'VALIDATION_FAILED',
      details: details,
    );
  }

  /// Operation not allowed
  factory BusinessError.notAllowed({
    required String message,
    Map<String, dynamic>? details,
  }) {
    return BusinessError(
      message: message,
      code: 'NOT_ALLOWED',
      details: details,
    );
  }

  /// Resource conflict
  factory BusinessError.conflict({
    required String message,
    Map<String, dynamic>? details,
  }) {
    return BusinessError(
      message: message,
      code: 'CONFLICT',
      details: details,
    );
  }

  @override
  String get userMessage => message;
}

/// Unknown or unexpected errors
class UnknownError extends ApiError {
  /// Original exception that caused this error
  final Exception? originalException;

  UnknownError({
    required super.message,
    this.originalException,
    super.code,
    super.details,
    super.timestamp,
  });

  factory UnknownError.fromException(Exception exception) {
    return UnknownError(
      message: exception.toString(),
      originalException: exception,
      code: 'UNKNOWN_ERROR',
    );
  }

  @override
  String get userMessage => 'An unexpected error occurred. Please try again.';

  @override
  String toString() {
    return 'UnknownError(message: $message, originalException: $originalException)';
  }
}

/// Utility class for creating API errors from various sources
class ApiErrorFactory {
  ApiErrorFactory._();

  /// Create error from HTTP response
  static ApiError fromHttpResponse(
    int statusCode,
    String? body, {
    Map<String, dynamic>? details,
  }) {
    try {
      // Try to parse error message from response body
      String? message;
      if (body != null && body.isNotEmpty) {
        // This is a simple implementation - you might want to parse JSON
        message = body.length > 200 ? body.substring(0, 200) : body;
      }

      return HttpError.fromStatusCode(
        statusCode,
        message: message,
        details: details,
      );
    } catch (e) {
      return HttpError.fromStatusCode(statusCode, details: details);
    }
  }

  /// Create error from exception
  static ApiError fromException(Exception exception) {
    final message = exception.toString();

    // Check for common network errors
    if (message.contains('SocketException') ||
        message.contains('NetworkException')) {
      return NetworkError.noConnection();
    }

    if (message.contains('TimeoutException')) {
      return NetworkError.timeout();
    }

    if (message.contains('FormatException') ||
        message.contains('JsonUnsupportedObjectError')) {
      return ParseError.json();
    }

    return UnknownError.fromException(exception);
  }
}
