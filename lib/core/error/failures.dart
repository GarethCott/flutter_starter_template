/// Base failure class for the application
abstract class Failure {
  final String message;
  final String? code;
  final dynamic details;

  const Failure(this.message, {this.code, this.details});

  @override
  String toString() => 'Failure: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => Object.hash(message, code);
}

/// Failure when server returns an error
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'ServerFailure: $message';
}

/// Failure when network request fails
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'NetworkFailure: $message';
}

/// Failure when cache operation fails
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'CacheFailure: $message';
}

/// Failure when authentication fails
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'AuthFailure: $message';
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'ValidationFailure: $message';
}

/// Failure when permission is denied
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'PermissionFailure: $message';
}

/// Failure when resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'NotFoundFailure: $message';
}

/// Failure when operation times out
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'TimeoutFailure: $message';
}

/// Failure when storage operation fails
class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'StorageFailure: $message';
}
