/// Standardized API response wrapper for consistent response handling
///
/// Provides a unified way to handle API responses throughout the application
/// with proper error handling and data validation.
library;

/// Generic API response wrapper
class ApiResponse<T> {
  /// Indicates if the request was successful
  final bool success;

  /// Response data (null if error occurred)
  final T? data;

  /// Error message (null if successful)
  final String? message;

  /// HTTP status code
  final int? statusCode;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Timestamp of the response
  final DateTime timestamp;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create from JSON response
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final success = json['success'] ?? true;
    final message = json['message'] as String?;
    final statusCode = json['status_code'] as int?;
    final metadata = json['metadata'] as Map<String, dynamic>?;

    T? data;
    if (success && json['data'] != null && fromJsonT != null) {
      data = fromJsonT(json['data']);
    } else if (json['data'] is T) {
      data = json['data'] as T;
    }

    return ApiResponse<T>(
      success: success,
      data: data,
      message: message,
      statusCode: statusCode,
      metadata: metadata,
    );
  }

  /// Create a successful response
  factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode ?? 200,
      metadata: metadata,
    );
  }

  /// Create an error response
  factory ApiResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode ?? 500,
      metadata: metadata,
    );
  }

  /// Check if response has data
  bool get hasData => success && data != null;

  /// Check if response has error
  bool get hasError => !success;

  /// Get error message or default
  String getErrorMessage([String defaultMessage = 'Unknown error occurred']) {
    return message ?? defaultMessage;
  }

  /// Get data or throw exception
  T getDataOrThrow() {
    if (hasData) {
      return data!;
    }
    throw ApiException(
      message: getErrorMessage(),
      statusCode: statusCode,
    );
  }

  /// Get data or return default value
  T getDataOrDefault(T defaultValue) {
    return hasData ? data! : defaultValue;
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, message: $message, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiResponse<T> &&
        other.success == success &&
        other.data == data &&
        other.message == message &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        data.hashCode ^
        message.hashCode ^
        statusCode.hashCode;
  }
}

/// API exception for error handling
class ApiException implements Exception {
  /// Error message
  final String message;

  /// HTTP status code
  final int? statusCode;

  /// Additional error data
  final Map<String, dynamic>? data;

  /// Original exception that caused this error
  final Exception? originalException;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.originalException,
  });

  /// Create from API response
  factory ApiException.fromResponse(ApiResponse response) {
    return ApiException(
      message: response.getErrorMessage(),
      statusCode: response.statusCode,
      data: response.metadata,
    );
  }

  /// Check if this is a network error
  bool get isNetworkError => statusCode == null || statusCode! >= 500;

  /// Check if this is a client error
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Check if this is a server error
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Check if this is an authentication error
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  /// Check if this is a not found error
  bool get isNotFoundError => statusCode == 404;

  /// Check if this is a validation error
  bool get isValidationError => statusCode == 422;

  @override
  String toString() {
    return 'ApiException(message: $message, statusCode: $statusCode)';
  }
}
