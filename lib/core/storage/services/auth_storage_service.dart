import '../../error/app_error.dart';
import '../secure_storage.dart';
import '../shared_prefs.dart';

/// Authentication data storage service
class AuthStorageService {
  // Storage keys
  static const String _userDataKey = 'user_data';
  static const String _authStateKey = 'auth_state';
  static const String _sessionDataKey = 'session_data';
  static const String _loginHistoryKey = 'login_history';

  /// User data model for storage
  static const int _maxLoginHistoryEntries = 10;

  /// Store user authentication data
  static Future<void> storeAuthData({
    required String token,
    required String refreshToken,
    required String userId,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? sessionData,
  }) async {
    try {
      // Store sensitive data in secure storage
      await Future.wait([
        SecureStorage.setToken(token),
        SecureStorage.setRefreshToken(refreshToken),
        SecureStorage.setUserId(userId),
      ]);

      // Store user data if provided
      if (userData != null) {
        await SecureStorage.setCustomData(_userDataKey, userData);
      }

      // Store session data if provided
      if (sessionData != null) {
        await SecureStorage.setCustomData(_sessionDataKey, sessionData);
      }

      // Update auth state
      await _updateAuthState(true);

      // Record login
      await _recordLogin(userId);
    } catch (e) {
      throw StorageError(message: 'Failed to store authentication data: $e');
    }
  }

  /// Get stored authentication data
  static Future<Map<String, dynamic>?> getAuthData() async {
    try {
      final token = await SecureStorage.getToken();
      final refreshToken = await SecureStorage.getRefreshToken();
      final userId = await SecureStorage.getUserId();

      if (token == null || refreshToken == null || userId == null) {
        return null;
      }

      final userData = await SecureStorage.getCustomData(_userDataKey);
      final sessionData = await SecureStorage.getCustomData(_sessionDataKey);

      return {
        'token': token,
        'refresh_token': refreshToken,
        'user_id': userId,
        'user_data': userData,
        'session_data': sessionData,
      };
    } catch (e) {
      throw StorageError(message: 'Failed to get authentication data: $e');
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final token = await SecureStorage.getToken();
      final userId = await SecureStorage.getUserId();
      return token != null && userId != null;
    } catch (e) {
      return false;
    }
  }

  /// Get current user ID
  static Future<String?> getCurrentUserId() async {
    try {
      return await SecureStorage.getUserId();
    } catch (e) {
      return null;
    }
  }

  /// Get current auth token
  static Future<String?> getCurrentToken() async {
    try {
      return await SecureStorage.getToken();
    } catch (e) {
      return null;
    }
  }

  /// Get current refresh token
  static Future<String?> getCurrentRefreshToken() async {
    try {
      return await SecureStorage.getRefreshToken();
    } catch (e) {
      return null;
    }
  }

  /// Update authentication token
  static Future<void> updateToken(String newToken) async {
    try {
      await SecureStorage.setToken(newToken);
    } catch (e) {
      throw StorageError(message: 'Failed to update authentication token: $e');
    }
  }

  /// Update refresh token
  static Future<void> updateRefreshToken(String newRefreshToken) async {
    try {
      await SecureStorage.setRefreshToken(newRefreshToken);
    } catch (e) {
      throw StorageError(message: 'Failed to update refresh token: $e');
    }
  }

  /// Update user data
  static Future<void> updateUserData(Map<String, dynamic> userData) async {
    try {
      await SecureStorage.setCustomData(_userDataKey, userData);
    } catch (e) {
      throw StorageError(message: 'Failed to update user data: $e');
    }
  }

  /// Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      return await SecureStorage.getCustomData(_userDataKey);
    } catch (e) {
      return null;
    }
  }

  /// Update session data
  static Future<void> updateSessionData(
      Map<String, dynamic> sessionData) async {
    try {
      await SecureStorage.setCustomData(_sessionDataKey, sessionData);
    } catch (e) {
      throw StorageError(message: 'Failed to update session data: $e');
    }
  }

  /// Get session data
  static Future<Map<String, dynamic>?> getSessionData() async {
    try {
      return await SecureStorage.getCustomData(_sessionDataKey);
    } catch (e) {
      return null;
    }
  }

  /// Store biometric authentication preference
  static Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await SecureStorage.setBiometricEnabled(enabled);
    } catch (e) {
      throw StorageError(message: 'Failed to set biometric preference: $e');
    }
  }

  /// Get biometric authentication preference
  static Future<bool> isBiometricEnabled() async {
    try {
      return await SecureStorage.getBiometricEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Store device ID
  static Future<void> setDeviceId(String deviceId) async {
    try {
      await SecureStorage.setDeviceId(deviceId);
    } catch (e) {
      throw StorageError(message: 'Failed to set device ID: $e');
    }
  }

  /// Get device ID
  static Future<String?> getDeviceId() async {
    try {
      return await SecureStorage.getDeviceId();
    } catch (e) {
      return null;
    }
  }

  /// Record last login timestamp
  static Future<void> recordLastLogin() async {
    try {
      await SecureStorage.setLastLogin(DateTime.now());
    } catch (e) {
      throw StorageError(message: 'Failed to record last login: $e');
    }
  }

  /// Get last login timestamp
  static Future<DateTime?> getLastLogin() async {
    try {
      return await SecureStorage.getLastLogin();
    } catch (e) {
      return null;
    }
  }

  /// Clear all authentication data
  static Future<void> clearAuthData() async {
    try {
      // Clear secure storage
      await SecureStorage.clearAuthData();
      await SecureStorage.deleteCustomData(_userDataKey);
      await SecureStorage.deleteCustomData(_sessionDataKey);

      // Update auth state
      await _updateAuthState(false);
    } catch (e) {
      throw StorageError(message: 'Failed to clear authentication data: $e');
    }
  }

  /// Logout and clear all data
  static Future<void> logout() async {
    try {
      // Record logout in history
      final userId = await getCurrentUserId();
      if (userId != null) {
        await _recordLogout(userId);
      }

      // Clear all auth data
      await clearAuthData();
    } catch (e) {
      throw StorageError(message: 'Failed to logout: $e');
    }
  }

  /// Update authentication state in shared preferences
  static Future<void> _updateAuthState(bool isAuthenticated) async {
    try {
      await SharedPrefs.setJson(_authStateKey, {
        'is_authenticated': isAuthenticated,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      // Don't throw error for non-critical operation
    }
  }

  /// Get authentication state from shared preferences
  static Future<Map<String, dynamic>?> getAuthState() async {
    try {
      return SharedPrefs.getJson(_authStateKey);
    } catch (e) {
      return null;
    }
  }

  /// Record login in history
  static Future<void> _recordLogin(String userId) async {
    try {
      final history = await getLoginHistory();
      final loginEntry = {
        'user_id': userId,
        'action': 'login',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'device_id': await getDeviceId(),
      };

      history.insert(0, loginEntry);

      // Keep only the last N entries
      if (history.length > _maxLoginHistoryEntries) {
        history.removeRange(_maxLoginHistoryEntries, history.length);
      }

      await SharedPrefs.setJson(_loginHistoryKey, {'entries': history});
    } catch (e) {
      // Don't throw error for non-critical operation
    }
  }

  /// Record logout in history
  static Future<void> _recordLogout(String userId) async {
    try {
      final history = await getLoginHistory();
      final logoutEntry = {
        'user_id': userId,
        'action': 'logout',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'device_id': await getDeviceId(),
      };

      history.insert(0, logoutEntry);

      // Keep only the last N entries
      if (history.length > _maxLoginHistoryEntries) {
        history.removeRange(_maxLoginHistoryEntries, history.length);
      }

      await SharedPrefs.setJson(_loginHistoryKey, {'entries': history});
    } catch (e) {
      // Don't throw error for non-critical operation
    }
  }

  /// Get login history
  static Future<List<Map<String, dynamic>>> getLoginHistory() async {
    try {
      final historyData = SharedPrefs.getJson(_loginHistoryKey);
      if (historyData == null || !historyData.containsKey('entries')) {
        return [];
      }

      final entries = historyData['entries'] as List<dynamic>;
      return entries.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Clear login history
  static Future<void> clearLoginHistory() async {
    try {
      await SharedPrefs.remove(_loginHistoryKey);
    } catch (e) {
      throw StorageError(message: 'Failed to clear login history: $e');
    }
  }

  /// Get authentication summary
  static Future<Map<String, dynamic>> getAuthSummary() async {
    try {
      final isAuth = await isAuthenticated();
      final userId = await getCurrentUserId();
      final lastLogin = await getLastLogin();
      final biometricEnabled = await isBiometricEnabled();
      final deviceId = await getDeviceId();
      final history = await getLoginHistory();

      return {
        'is_authenticated': isAuth,
        'user_id': userId,
        'last_login': lastLogin?.toIso8601String(),
        'biometric_enabled': biometricEnabled,
        'device_id': deviceId,
        'login_history_count': history.length,
        'last_activity': history.isNotEmpty ? history.first : null,
      };
    } catch (e) {
      throw StorageError(message: 'Failed to get authentication summary: $e');
    }
  }

  /// Validate stored authentication data
  static Future<bool> validateAuthData() async {
    try {
      final authData = await getAuthData();
      if (authData == null) return false;

      // Check required fields
      final token = authData['token'] as String?;
      final userId = authData['user_id'] as String?;

      if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
        return false;
      }

      // Additional validation can be added here
      // For example, token format validation, expiry check, etc.

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Migrate old authentication data (if needed)
  static Future<void> migrateAuthData() async {
    try {
      // This method can be used to migrate data from old storage formats
      // Implementation depends on specific migration needs

      // Example: Check if old format exists and migrate
      final authState = await getAuthState();
      if (authState == null) {
        // Initialize auth state if it doesn't exist
        await _updateAuthState(await isAuthenticated());
      }
    } catch (e) {
      // Migration errors shouldn't break the app
    }
  }

  /// Export authentication data for backup (excluding sensitive tokens)
  static Future<Map<String, dynamic>> exportAuthData() async {
    try {
      final userData = await getUserData();
      final sessionData = await getSessionData();
      final lastLogin = await getLastLogin();
      final biometricEnabled = await isBiometricEnabled();
      final history = await getLoginHistory();

      return {
        'user_data': userData,
        'session_data': sessionData,
        'last_login': lastLogin?.toIso8601String(),
        'biometric_enabled': biometricEnabled,
        'login_history': history,
        'exported_at': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw StorageError(message: 'Failed to export authentication data: $e');
    }
  }

  /// Import authentication data from backup (excluding sensitive tokens)
  static Future<void> importAuthData(Map<String, dynamic> data) async {
    try {
      if (data.containsKey('user_data') && data['user_data'] != null) {
        await updateUserData(data['user_data'] as Map<String, dynamic>);
      }

      if (data.containsKey('session_data') && data['session_data'] != null) {
        await updateSessionData(data['session_data'] as Map<String, dynamic>);
      }

      if (data.containsKey('biometric_enabled') &&
          data['biometric_enabled'] != null) {
        await setBiometricEnabled(data['biometric_enabled'] as bool);
      }

      if (data.containsKey('login_history') && data['login_history'] != null) {
        await SharedPrefs.setJson(_loginHistoryKey,
            {'entries': data['login_history'] as List<dynamic>});
      }
    } catch (e) {
      throw StorageError(message: 'Failed to import authentication data: $e');
    }
  }
}
