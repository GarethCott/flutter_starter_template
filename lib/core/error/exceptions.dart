/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  const ServerException(super.message, {super.code, super.details});

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when network request fails
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.details});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.details});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.details});

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.details});

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when permission is denied
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code, super.details});

  @override
  String toString() => 'PermissionException: $message';
}

/// Exception thrown when resource is not found
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.details});

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown when operation times out
class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code, super.details});

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception thrown when storage operation fails
class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.details});

  @override
  String toString() => 'StorageException: $message';
}
