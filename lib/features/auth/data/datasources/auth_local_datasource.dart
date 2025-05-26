import '../models/auth_token_model.dart';
import '../models/user_model.dart';

/// Local data source for authentication operations
abstract class AuthLocalDataSource {
  /// Get cached authentication token
  Future<AuthTokenModel?> getCachedToken();

  /// Cache authentication token
  Future<void> cacheToken(AuthTokenModel token);

  /// Remove cached authentication token
  Future<void> removeCachedToken();

  /// Get cached user data
  Future<UserModel?> getCachedUser();

  /// Cache user data
  Future<void> cacheUser(UserModel user);

  /// Remove cached user data
  Future<void> removeCachedUser();

  /// Check if user is logged in (has valid token)
  Future<bool> isLoggedIn();

  /// Get remember me preference
  Future<bool> getRememberMe();

  /// Set remember me preference
  Future<void> setRememberMe(bool rememberMe);

  /// Clear all authentication data
  Future<void> clearAuthData();
}
