import '../repositories/auth_repository.dart';

/// Use case for signing out the current user
class SignOutUseCase {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  /// Execute the sign out operation
  Future<SignOutResult> call() async {
    try {
      await _repository.signOut();
      return const SignOutResult.success();
    } catch (e) {
      return SignOutResult.failure(
        'Failed to sign out: ${e.toString()}',
      );
    }
  }
}

/// Result of sign out operation
class SignOutResult {
  final String? error;
  final bool isSuccess;

  const SignOutResult({
    this.error,
    required this.isSuccess,
  });

  /// Create a successful sign out result
  const SignOutResult.success()
      : error = null,
        isSuccess = true;

  /// Create a failed sign out result
  const SignOutResult.failure(String error)
      : error = error,
        isSuccess = false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignOutResult &&
        other.error == error &&
        other.isSuccess == isSuccess;
  }

  @override
  int get hashCode => Object.hash(error, isSuccess);

  @override
  String toString() {
    return 'SignOutResult(isSuccess: $isSuccess, error: $error)';
  }
}
