import '../models/auth_request_models.dart';
import '../models/auth_response_models.dart';
import '../models/user_model.dart';

/// Remote data source for authentication operations
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail(SignInRequest request);

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail(SignUpRequest request);

  /// Refresh authentication token
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request);

  /// Sign out (invalidate token on server)
  Future<MessageResponse> signOut();

  /// Get current user profile
  Future<UserModel> getCurrentUser();

  /// Update user profile
  Future<UserModel> updateProfile(Map<String, dynamic> updates);

  /// Send password reset email
  Future<MessageResponse> forgotPassword(ForgotPasswordRequest request);

  /// Reset password with token
  Future<MessageResponse> resetPassword(ResetPasswordRequest request);

  /// Change password
  Future<MessageResponse> changePassword(ChangePasswordRequest request);

  /// Verify email address
  Future<MessageResponse> verifyEmail(String token);

  /// Resend email verification
  Future<MessageResponse> resendEmailVerification();

  /// Verify phone number
  Future<MessageResponse> verifyPhone(String code);

  /// Send phone verification code
  Future<MessageResponse> sendPhoneVerification(String phoneNumber);
}
