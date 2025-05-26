import '../entities/auth_token.dart';
import '../entities/user.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? firstName,
    String? lastName,
  });

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle();

  /// Sign in with Apple
  Future<AuthResult> signInWithApple();

  /// Sign out the current user
  Future<void> signOut();

  /// Get the current authenticated user
  Future<User?> getCurrentUser();

  /// Get the current auth token
  Future<AuthToken?> getCurrentToken();

  /// Refresh the current auth token
  Future<AuthToken?> refreshToken();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Reset password with token
  Future<void> resetPasswordWithToken({
    required String token,
    required String newPassword,
  });

  /// Change password for authenticated user
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Send email verification
  Future<void> sendEmailVerification();

  /// Verify email with token
  Future<void> verifyEmail(String token);

  /// Send phone verification code
  Future<void> sendPhoneVerification(String phoneNumber);

  /// Verify phone with code
  Future<void> verifyPhone({
    required String phoneNumber,
    required String verificationCode,
  });

  /// Update user profile
  Future<User> updateProfile({
    String? name,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  });

  /// Upload and update profile picture
  Future<User> updateProfilePicture(String imagePath);

  /// Delete user account
  Future<void> deleteAccount();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Stream of user changes
  Stream<User?> get userChanges;
}

/// Result of authentication operations
class AuthResult {
  /// The authenticated user (null if authentication failed)
  final User? user;

  /// The authentication token (null if authentication failed)
  final AuthToken? token;

  /// Error message if authentication failed
  final String? error;

  /// Whether the authentication was successful
  final bool isSuccess;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  const AuthResult({
    this.user,
    this.token,
    this.error,
    required this.isSuccess,
    this.metadata,
  });

  /// Create a successful authentication result
  factory AuthResult.success({
    required User user,
    required AuthToken token,
    Map<String, dynamic>? metadata,
  }) {
    return AuthResult(
      user: user,
      token: token,
      isSuccess: true,
      metadata: metadata,
    );
  }

  /// Create a failed authentication result
  factory AuthResult.failure({
    required String error,
    Map<String, dynamic>? metadata,
  }) {
    return AuthResult(
      error: error,
      isSuccess: false,
      metadata: metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResult &&
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
    return 'AuthResult(isSuccess: $isSuccess, user: ${user?.email}, error: $error)';
  }
}
