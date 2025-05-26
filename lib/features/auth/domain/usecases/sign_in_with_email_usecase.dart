import '../../../../core/utils/validators/form_validators.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing in with email and password
class SignInWithEmailUseCase {
  final AuthRepository _repository;

  const SignInWithEmailUseCase(this._repository);

  /// Execute the sign in operation
  Future<SignInResult> call(SignInParams params) async {
    // Validate input parameters
    final validation = _validateParams(params);
    if (validation != null) {
      return SignInResult.failure(validation);
    }

    try {
      // Attempt to sign in
      final result = await _repository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      if (result.isSuccess && result.user != null && result.token != null) {
        return SignInResult.success(
          user: result.user!,
          token: result.token!,
        );
      } else {
        return SignInResult.failure(
          result.error ?? 'Sign in failed',
        );
      }
    } catch (e) {
      return SignInResult.failure(
        'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Validate sign in parameters
  String? _validateParams(SignInParams params) {
    // Validate email
    final emailError = FormValidators.validateEmail(params.email);
    if (emailError != null) {
      return emailError;
    }

    // Validate password
    final passwordError = FormValidators.validatePassword(params.password);
    if (passwordError != null) {
      return passwordError;
    }

    return null;
  }
}

/// Parameters for sign in operation
class SignInParams {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignInParams &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(email, password);

  @override
  String toString() => 'SignInParams(email: $email)';
}

/// Result of sign in operation
class SignInResult {
  final User? user;
  final AuthToken? token;
  final String? error;
  final bool isSuccess;

  const SignInResult({
    this.user,
    this.token,
    this.error,
    required this.isSuccess,
  });

  /// Create a successful sign in result
  factory SignInResult.success({
    required User user,
    required AuthToken token,
  }) {
    return SignInResult(
      user: user,
      token: token,
      isSuccess: true,
    );
  }

  /// Create a failed sign in result
  factory SignInResult.failure(String error) {
    return SignInResult(
      error: error,
      isSuccess: false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignInResult &&
        other.user == user &&
        other.token == token &&
        other.error == error &&
        other.isSuccess == isSuccess;
  }

  @override
  int get hashCode {
    return Object.hash(user, token, error, isSuccess);
  }

  @override
  String toString() {
    return 'SignInResult(isSuccess: $isSuccess, user: ${user?.email}, error: $error)';
  }
}
