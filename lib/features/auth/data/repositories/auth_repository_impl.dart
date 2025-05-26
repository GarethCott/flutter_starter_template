import 'dart:async';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_request_models.dart';

/// Implementation of [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  // Stream controllers for auth state changes
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();
  final StreamController<User?> _userController =
      StreamController<User?>.broadcast();

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final request = SignInRequest(
          email: email,
          password: password,
          rememberMe: false,
        );

        final response = await _remoteDataSource.signInWithEmail(request);

        // Cache the authentication data
        await _localDataSource.cacheToken(response.token);
        await _localDataSource.cacheUser(response.user);

        final user = response.user.toEntity();
        final token = response.token.toEntity();

        // Notify listeners
        _authStateController.add(user);
        _userController.add(user);

        return AuthResult.success(user: user, token: token);
      } on ServerException catch (e) {
        return AuthResult.failure(error: e.message);
      } on NetworkException catch (e) {
        return AuthResult.failure(error: e.message);
      } catch (e) {
        return AuthResult.failure(error: 'Unexpected error: $e');
      }
    } else {
      return AuthResult.failure(error: 'No internet connection');
    }
  }

  @override
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? firstName,
    String? lastName,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final request = SignUpRequest(
          email: email,
          password: password,
          firstName: firstName ?? '',
          lastName: lastName ?? '',
        );

        final response = await _remoteDataSource.signUpWithEmail(request);

        // Cache the authentication data
        await _localDataSource.cacheToken(response.token);
        await _localDataSource.cacheUser(response.user);

        final user = response.user.toEntity();
        final token = response.token.toEntity();

        // Notify listeners
        _authStateController.add(user);
        _userController.add(user);

        return AuthResult.success(user: user, token: token);
      } on ServerException catch (e) {
        return AuthResult.failure(error: e.message);
      } on NetworkException catch (e) {
        return AuthResult.failure(error: e.message);
      } catch (e) {
        return AuthResult.failure(error: 'Unexpected error: $e');
      }
    } else {
      return AuthResult.failure(error: 'No internet connection');
    }
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    // TODO: Implement Google Sign In
    return AuthResult.failure(error: 'Google Sign In not implemented yet');
  }

  @override
  Future<AuthResult> signInWithApple() async {
    // TODO: Implement Apple Sign In
    return AuthResult.failure(error: 'Apple Sign In not implemented yet');
  }

  @override
  Future<void> signOut() async {
    try {
      // Try to sign out from server if connected
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.signOut();
        } catch (e) {
          // Continue with local sign out even if server sign out fails
        }
      }

      // Clear local authentication data
      await _localDataSource.clearAuthData();

      // Notify listeners
      _authStateController.add(null);
      _userController.add(null);
    } on CacheException catch (e) {
      throw Exception('Failed to sign out: ${e.message}');
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // First try to get from cache
      final cachedUser = await _localDataSource.getCachedUser();

      if (cachedUser != null) {
        // If we have network, try to refresh user data
        if (await _networkInfo.isConnected) {
          try {
            final remoteUser = await _remoteDataSource.getCurrentUser();
            await _localDataSource.cacheUser(remoteUser);
            final user = remoteUser.toEntity();
            _userController.add(user);
            return user;
          } catch (e) {
            // Return cached user if remote fetch fails
            return cachedUser.toEntity();
          }
        } else {
          return cachedUser.toEntity();
        }
      }

      // If no cached user and we have network, try to fetch from server
      if (await _networkInfo.isConnected) {
        try {
          final remoteUser = await _remoteDataSource.getCurrentUser();
          await _localDataSource.cacheUser(remoteUser);
          final user = remoteUser.toEntity();
          _userController.add(user);
          return user;
        } catch (e) {
          return null;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthToken?> getCurrentToken() async {
    try {
      final cachedToken = await _localDataSource.getCachedToken();
      return cachedToken?.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthToken?> refreshToken() async {
    if (await _networkInfo.isConnected) {
      try {
        final cachedToken = await _localDataSource.getCachedToken();
        if (cachedToken?.refreshToken == null) {
          return null;
        }

        final request = RefreshTokenRequest(
          refreshToken: cachedToken!.refreshToken!,
        );

        final response = await _remoteDataSource.refreshToken(request);

        // Cache the new token
        await _localDataSource.cacheToken(response.token);

        return response.token.toEntity();
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        final request = ForgotPasswordRequest(email: email);
        await _remoteDataSource.forgotPassword(request);
      } on ServerException catch (e) {
        throw Exception(e.message);
      } on NetworkException catch (e) {
        throw Exception(e.message);
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> resetPasswordWithToken({
    required String token,
    required String newPassword,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final request = ResetPasswordRequest(
          token: token,
          newPassword: newPassword,
        );
        await _remoteDataSource.resetPassword(request);
      } on ServerException catch (e) {
        throw Exception(e.message);
      } on NetworkException catch (e) {
        throw Exception(e.message);
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final request = ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        await _remoteDataSource.changePassword(request);
      } on ServerException catch (e) {
        throw Exception(e.message);
      } on NetworkException catch (e) {
        throw Exception(e.message);
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.resendEmailVerification();
      } on ServerException catch (e) {
        throw Exception(e.message);
      } on NetworkException catch (e) {
        throw Exception(e.message);
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.verifyEmail(token);
      } on ServerException catch (e) {
        throw Exception(e.message);
      } on NetworkException catch (e) {
        throw Exception(e.message);
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> sendPhoneVerification(String phoneNumber) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.sendPhoneVerification(phoneNumber);
      } on ServerException catch (e) {
        throw Exception(e.message);
      } on NetworkException catch (e) {
        throw Exception(e.message);
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> verifyPhone({
    required String phoneNumber,
    required String verificationCode,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.verifyPhone(verificationCode);
      } on ServerException catch (e) {
        throw Exception(e.message);
      } on NetworkException catch (e) {
        throw Exception(e.message);
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final updates = <String, dynamic>{};
        if (name != null) updates['name'] = name;
        if (firstName != null) updates['firstName'] = firstName;
        if (lastName != null) updates['lastName'] = lastName;
        if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;

        final updatedUser = await _remoteDataSource.updateProfile(updates);

        // Cache the updated user
        await _localDataSource.cacheUser(updatedUser);

        final user = updatedUser.toEntity();
        _userController.add(user);

        return user;
      } on ServerException catch (e) {
        throw Exception(e.message);
      } on NetworkException catch (e) {
        throw Exception(e.message);
      } on CacheException catch (e) {
        throw Exception(e.message);
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<User> updateProfilePicture(String imagePath) async {
    // TODO: Implement profile picture upload
    throw UnimplementedError('Profile picture upload not implemented yet');
  }

  @override
  Future<void> deleteAccount() async {
    // TODO: Implement account deletion
    throw UnimplementedError('Account deletion not implemented yet');
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await _localDataSource.isLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Stream<User?> get userChanges => _userController.stream;

  /// Dispose resources
  void dispose() {
    _authStateController.close();
    _userController.close();
  }
}
