/// Base class for all application errors
abstract class AppError implements Exception {
  const AppError({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final String? code;
  final String? details;

  @override
  String toString() =>
      'AppError: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related errors
class NetworkError extends AppError {
  const NetworkError({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  final int? statusCode;

  factory NetworkError.noConnection() => const NetworkError(
        message: 'No internet connection available',
        code: 'NO_CONNECTION',
      );

  factory NetworkError.timeout() => const NetworkError(
        message: 'Request timed out',
        code: 'TIMEOUT',
      );

  factory NetworkError.serverError([int? statusCode]) => NetworkError(
        message: 'Server error occurred',
        code: 'SERVER_ERROR',
        statusCode: statusCode,
      );

  factory NetworkError.unauthorized() => const NetworkError(
        message: 'Unauthorized access',
        code: 'UNAUTHORIZED',
        statusCode: 401,
      );

  factory NetworkError.forbidden() => const NetworkError(
        message: 'Access forbidden',
        code: 'FORBIDDEN',
        statusCode: 403,
      );

  factory NetworkError.notFound() => const NetworkError(
        message: 'Resource not found',
        code: 'NOT_FOUND',
        statusCode: 404,
      );
}

/// Authentication-related errors
class AuthError extends AppError {
  const AuthError({
    required super.message,
    super.code,
    super.details,
  });

  factory AuthError.invalidCredentials() => const AuthError(
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthError.userNotFound() => const AuthError(
        message: 'User account not found',
        code: 'USER_NOT_FOUND',
      );

  factory AuthError.emailAlreadyExists() => const AuthError(
        message: 'An account with this email already exists',
        code: 'EMAIL_EXISTS',
      );

  factory AuthError.weakPassword() => const AuthError(
        message: 'Password is too weak',
        code: 'WEAK_PASSWORD',
      );

  factory AuthError.sessionExpired() => const AuthError(
        message: 'Your session has expired. Please log in again',
        code: 'SESSION_EXPIRED',
      );
}

/// Validation-related errors
class ValidationError extends AppError {
  const ValidationError({
    required super.message,
    super.code,
    super.details,
    this.field,
  });

  final String? field;

  factory ValidationError.required(String field) => ValidationError(
        message: '$field is required',
        code: 'REQUIRED_FIELD',
        field: field,
      );

  factory ValidationError.invalidEmail() => const ValidationError(
        message: 'Please enter a valid email address',
        code: 'INVALID_EMAIL',
        field: 'email',
      );

  factory ValidationError.invalidFormat(String field) => ValidationError(
        message: '$field format is invalid',
        code: 'INVALID_FORMAT',
        field: field,
      );

  factory ValidationError.tooShort(String field, int minLength) =>
      ValidationError(
        message: '$field must be at least $minLength characters',
        code: 'TOO_SHORT',
        field: field,
      );

  factory ValidationError.tooLong(String field, int maxLength) =>
      ValidationError(
        message: '$field must be no more than $maxLength characters',
        code: 'TOO_LONG',
        field: field,
      );
}

/// Storage-related errors
class StorageError extends AppError {
  const StorageError({
    required super.message,
    super.code,
    super.details,
  });

  factory StorageError.readFailed() => const StorageError(
        message: 'Failed to read data from storage',
        code: 'READ_FAILED',
      );

  factory StorageError.writeFailed() => const StorageError(
        message: 'Failed to write data to storage',
        code: 'WRITE_FAILED',
      );

  factory StorageError.notFound() => const StorageError(
        message: 'Data not found in storage',
        code: 'NOT_FOUND',
      );

  factory StorageError.permissionDenied() => const StorageError(
        message: 'Storage permission denied',
        code: 'PERMISSION_DENIED',
      );
}

/// Unknown or unexpected errors
class UnknownError extends AppError {
  const UnknownError({
    super.message = 'An unexpected error occurred',
    super.code = 'UNKNOWN',
    super.details,
  });

  factory UnknownError.fromException(Exception exception) => UnknownError(
        message: 'An unexpected error occurred',
        details: exception.toString(),
      );
}
