import '../../../../core/utils/validators/form_validators.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing up with email and password
class SignUpWithEmailUseCase {
  final AuthRepository _repository;

  const SignUpWithEmailUseCase(this._repository);

  /// Execute the sign up operation
  Future<SignUpResult> call(SignUpParams params) async {
    // Validate input parameters
    final validation = _validateParams(params);
    if (validation != null) {
      return SignUpResult.failure(validation);
    }

    try {
      // Attempt to sign up
      final result = await _repository.signUpWithEmailAndPassword(
        email: params.email,
        password: params.password,
        name: params.name,
        firstName: params.firstName,
        lastName: params.lastName,
      );

      if (result.isSuccess && result.user != null && result.token != null) {
        return SignUpResult.success(
          user: result.user!,
          token: result.token!,
        );
      } else {
        return SignUpResult.failure(
          result.error ?? 'Sign up failed',
        );
      }
    } catch (e) {
      return SignUpResult.failure(
        'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Validate sign up parameters
  String? _validateParams(SignUpParams params) {
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

    // Validate confirm password
    if (params.password != params.confirmPassword) {
      return 'Passwords do not match';
    }

    // Validate name if provided
    if (params.name != null && params.name!.trim().isEmpty) {
      return 'Name cannot be empty';
    }

    // Validate first name if provided
    if (params.firstName != null && params.firstName!.trim().isEmpty) {
      return 'First name cannot be empty';
    }

    // Validate last name if provided
    if (params.lastName != null && params.lastName!.trim().isEmpty) {
      return 'Last name cannot be empty';
    }

    return null;
  }
}

/// Parameters for sign up operation
class SignUpParams {
  final String email;
  final String password;
  final String confirmPassword;
  final String? name;
  final String? firstName;
  final String? lastName;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.name,
    this.firstName,
    this.lastName,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignUpParams &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.name == name &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode {
    return Object.hash(
      email,
      password,
      confirmPassword,
      name,
      firstName,
      lastName,
    );
  }

  @override
  String toString() => 'SignUpParams(email: $email, name: $name)';
}

/// Result of sign up operation
class SignUpResult {
  final User? user;
  final AuthToken? token;
  final String? error;
  final bool isSuccess;

  const SignUpResult({
    this.user,
    this.token,
    this.error,
    required this.isSuccess,
  });

  /// Create a successful sign up result
  factory SignUpResult.success({
    required User user,
    required AuthToken token,
  }) {
    return SignUpResult(
      user: user,
      token: token,
      isSuccess: true,
    );
  }

  /// Create a failed sign up result
  factory SignUpResult.failure(String error) {
    return SignUpResult(
      error: error,
      isSuccess: false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignUpResult &&
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
    return 'SignUpResult(isSuccess: $isSuccess, user: ${user?.email}, error: $error)';
  }
}
