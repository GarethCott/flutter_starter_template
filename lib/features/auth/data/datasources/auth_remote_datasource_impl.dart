import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/user.dart';
import '../models/auth_request_models.dart';
import '../models/auth_response_models.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Implementation of [AuthRemoteDataSource] using HTTP API
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  /// Dummy credentials for demo purposes
  static const Map<String, Map<String, dynamic>> _dummyCredentials = {
    'admin@example.com': {
      'password': 'admin123',
      'name': 'Admin User',
      'firstName': 'Admin',
      'lastName': 'User',
      'role': UserRole.admin,
      'phoneNumber': '+1234567890',
    },
    'user@example.com': {
      'password': 'user123',
      'name': 'John Doe',
      'firstName': 'John',
      'lastName': 'Doe',
      'role': UserRole.user,
      'phoneNumber': '+1234567891',
    },
    'demo@example.com': {
      'password': 'demo123',
      'name': 'Demo User',
      'firstName': 'Demo',
      'lastName': 'User',
      'role': UserRole.user,
      'phoneNumber': null,
    },
  };

  /// Generate user name from email for demo purposes
  String _getNameFromEmail(String email) {
    final credentials = _dummyCredentials[email];
    return credentials?['name'] ?? email.split('@').first.replaceAll('.', ' ');
  }

  /// Generate demo user data based on email
  UserModel _generateDemoUser(String email) {
    final credentials = _dummyCredentials[email];
    final now = DateTime.now();

    return UserModel(
      id: 'user_${email.hashCode.abs()}',
      email: email,
      name: credentials?['name'] ?? _getNameFromEmail(email),
      firstName: credentials?['firstName'],
      lastName: credentials?['lastName'],
      phoneNumber: credentials?['phoneNumber'],
      profilePictureUrl:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_getNameFromEmail(email))}&background=6366f1&color=fff',
      isEmailVerified: true,
      isPhoneVerified: credentials?['phoneNumber'] != null,
      role: credentials?['role'] ?? UserRole.user,
      status: UserStatus.active,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now.subtract(const Duration(days: 1)),
      lastLoginAt: now,
      locale: 'en',
      timezone: 'UTC',
      metadata: {
        'isDemoUser': true,
        'loginCount': 42,
        'lastIpAddress': '192.168.1.1',
      },
    );
  }

  /// Generate demo auth token
  AuthTokenModel _generateDemoToken() {
    final now = DateTime.now();
    return AuthTokenModel(
      accessToken: 'demo_access_token_${now.millisecondsSinceEpoch}',
      refreshToken: 'demo_refresh_token_${now.millisecondsSinceEpoch}',
      tokenType: 'Bearer',
      expiresAt: now.add(const Duration(hours: 24)),
      issuedAt: now,
      scopes: ['read', 'write'],
    );
  }

  @override
  Future<AuthResponse> signInWithEmail(SignInRequest request) async {
    // Simulate network delay for realistic demo experience
    await Future.delayed(const Duration(seconds: 2));

    // Check if this is a demo credential
    if (_dummyCredentials.containsKey(request.email)) {
      final credentials = _dummyCredentials[request.email]!;

      // Validate password
      if (credentials['password'] == request.password) {
        // Generate demo user and token
        final user = _generateDemoUser(request.email);
        final token = _generateDemoToken();

        return AuthResponse(
          user: user,
          token: token,
        );
      } else {
        // Invalid password for demo credential
        throw ServerException(
          'Invalid email or password',
          code: 'INVALID_CREDENTIALS',
          details: {'statusCode': 401},
        );
      }
    }

    // Fall back to real API for non-demo credentials
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to sign in: $e');
    }
  }

  @override
  Future<AuthResponse> signUpWithEmail(SignUpRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to sign up: $e');
    }
  }

  @override
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return RefreshTokenResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to refresh token: $e');
    }
  }

  @override
  Future<MessageResponse> signOut() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.logout);

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to sign out: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userProfile);

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to get current user: $e');
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.updateProfile,
        data: updates,
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to update profile: $e');
    }
  }

  @override
  Future<MessageResponse> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to send password reset: $e');
    }
  }

  @override
  Future<MessageResponse> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to reset password: $e');
    }
  }

  @override
  Future<MessageResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.changePassword,
        data: request.toJson(),
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to change password: $e');
    }
  }

  @override
  Future<MessageResponse> verifyEmail(String token) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyEmail,
        data: {'token': token},
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to verify email: $e');
    }
  }

  @override
  Future<MessageResponse> resendEmailVerification() async {
    try {
      final response =
          await _apiClient.post(ApiEndpoints.resendEmailVerification);

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to resend email verification: $e');
    }
  }

  @override
  Future<MessageResponse> verifyPhone(String code) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyPhone,
        data: {'code': code},
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to verify phone: $e');
    }
  }

  @override
  Future<MessageResponse> sendPhoneVerification(String phoneNumber) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendPhoneVerification,
        data: {'phoneNumber': phoneNumber},
      );

      if (response.data == null) {
        throw ServerException('Empty response from server');
      }

      return MessageResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to send phone verification: $e');
    }
  }
}
