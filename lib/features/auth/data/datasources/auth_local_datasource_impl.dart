import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/services/auth_storage_service.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

/// Implementation of [AuthLocalDataSource] using secure storage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  @override
  Future<AuthTokenModel?> getCachedToken() async {
    try {
      final token = await AuthStorageService.getCurrentToken();
      final refreshToken = await AuthStorageService.getCurrentRefreshToken();

      if (token == null || refreshToken == null) return null;

      // Create a token model from the stored data
      return AuthTokenModel(
        accessToken: token,
        refreshToken: refreshToken,
        tokenType: 'Bearer',
        expiresAt:
            DateTime.now().add(const Duration(hours: 1)), // Default expiry
        issuedAt: DateTime.now(),
      );
    } catch (e) {
      throw CacheException('Failed to get cached token: $e');
    }
  }

  @override
  Future<void> cacheToken(AuthTokenModel token) async {
    try {
      await AuthStorageService.updateToken(token.accessToken);
      if (token.refreshToken != null) {
        await AuthStorageService.updateRefreshToken(token.refreshToken!);
      }
    } catch (e) {
      throw CacheException('Failed to cache token: $e');
    }
  }

  @override
  Future<void> removeCachedToken() async {
    try {
      await AuthStorageService.clearAuthData();
    } catch (e) {
      throw CacheException('Failed to remove cached token: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userData = await AuthStorageService.getUserData();
      if (userData == null) return null;

      return UserModel.fromJson(userData);
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await AuthStorageService.updateUserData(user.toJson());
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<void> removeCachedUser() async {
    try {
      await AuthStorageService.clearAuthData();
    } catch (e) {
      throw CacheException('Failed to remove cached user: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await AuthStorageService.isAuthenticated();
    } catch (e) {
      throw CacheException('Failed to check login status: $e');
    }
  }

  @override
  Future<bool> getRememberMe() async {
    try {
      // Use biometric preference as remember me for now
      return await AuthStorageService.isBiometricEnabled();
    } catch (e) {
      throw CacheException('Failed to get remember me preference: $e');
    }
  }

  @override
  Future<void> setRememberMe(bool rememberMe) async {
    try {
      // Use biometric preference as remember me for now
      await AuthStorageService.setBiometricEnabled(rememberMe);
    } catch (e) {
      throw CacheException('Failed to set remember me preference: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await AuthStorageService.clearAuthData();
    } catch (e) {
      throw CacheException('Failed to clear auth data: $e');
    }
  }
}
