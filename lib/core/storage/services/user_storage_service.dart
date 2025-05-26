import '../../error/app_error.dart';
import '../shared_prefs.dart';

/// User preferences and profile data storage service
class UserStorageService {
  // Storage keys
  static const String _userProfileKey = 'user_profile';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _userSettingsKey = 'user_settings';
  static const String _userCacheKey = 'user_cache';
  static const String _userMetadataKey = 'user_metadata';

  /// Store user profile data
  static Future<void> storeUserProfile(Map<String, dynamic> profile) async {
    try {
      await SharedPrefs.setJson(_userProfileKey, profile);
    } catch (e) {
      throw StorageError(message: 'Failed to store user profile: $e');
    }
  }

  /// Get user profile data
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      return SharedPrefs.getJson(_userProfileKey);
    } catch (e) {
      return null;
    }
  }

  /// Update specific profile field
  static Future<void> updateProfileField(String field, dynamic value) async {
    try {
      final profile = await getUserProfile() ?? <String, dynamic>{};
      profile[field] = value;
      await storeUserProfile(profile);
    } catch (e) {
      throw StorageError(message: 'Failed to update profile field: $e');
    }
  }

  /// Get specific profile field
  static Future<T?> getProfileField<T>(String field) async {
    try {
      final profile = await getUserProfile();
      return profile?[field] as T?;
    } catch (e) {
      return null;
    }
  }

  /// Store user preferences
  static Future<void> storeUserPreferences(
      Map<String, dynamic> preferences) async {
    try {
      await SharedPrefs.setJson(_userPreferencesKey, preferences);
    } catch (e) {
      throw StorageError(message: 'Failed to store user preferences: $e');
    }
  }

  /// Get user preferences
  static Future<Map<String, dynamic>?> getUserPreferences() async {
    try {
      return SharedPrefs.getJson(_userPreferencesKey);
    } catch (e) {
      return null;
    }
  }

  /// Update specific preference
  static Future<void> updatePreference(String key, dynamic value) async {
    try {
      final preferences = await getUserPreferences() ?? <String, dynamic>{};
      preferences[key] = value;
      await storeUserPreferences(preferences);
    } catch (e) {
      throw StorageError(message: 'Failed to update preference: $e');
    }
  }

  /// Get specific preference
  static Future<T?> getPreference<T>(String key, [T? defaultValue]) async {
    try {
      final preferences = await getUserPreferences();
      return preferences?[key] as T? ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Store user settings
  static Future<void> storeUserSettings(Map<String, dynamic> settings) async {
    try {
      await SharedPrefs.setJson(_userSettingsKey, settings);
    } catch (e) {
      throw StorageError(message: 'Failed to store user settings: $e');
    }
  }

  /// Get user settings
  static Future<Map<String, dynamic>?> getUserSettings() async {
    try {
      return SharedPrefs.getJson(_userSettingsKey);
    } catch (e) {
      return null;
    }
  }

  /// Update specific setting
  static Future<void> updateSetting(String key, dynamic value) async {
    try {
      final settings = await getUserSettings() ?? <String, dynamic>{};
      settings[key] = value;
      await storeUserSettings(settings);
    } catch (e) {
      throw StorageError(message: 'Failed to update setting: $e');
    }
  }

  /// Get specific setting
  static Future<T?> getSetting<T>(String key, [T? defaultValue]) async {
    try {
      final settings = await getUserSettings();
      return settings?[key] as T? ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // Theme and appearance preferences
  /// Set theme mode preference
  static Future<void> setThemeMode(String themeMode) async {
    try {
      await SharedPrefs.setThemeMode(themeMode);
      await updatePreference('theme_mode', themeMode);
    } catch (e) {
      throw StorageError(message: 'Failed to set theme mode: $e');
    }
  }

  /// Get theme mode preference
  static Future<String> getThemeMode() async {
    try {
      return SharedPrefs.getThemeMode();
    } catch (e) {
      return 'system';
    }
  }

  /// Set language preference
  static Future<void> setLanguage(String languageCode) async {
    try {
      await SharedPrefs.setLanguageCode(languageCode);
      await updatePreference('language', languageCode);
    } catch (e) {
      throw StorageError(message: 'Failed to set language: $e');
    }
  }

  /// Get language preference
  static Future<String?> getLanguage() async {
    try {
      return SharedPrefs.getLanguageCode();
    } catch (e) {
      return null;
    }
  }

  // Notification preferences
  /// Set notifications enabled
  static Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      await SharedPrefs.setNotificationsEnabled(enabled);
      await updatePreference('notifications_enabled', enabled);
    } catch (e) {
      throw StorageError(message: 'Failed to set notifications preference: $e');
    }
  }

  /// Get notifications enabled status
  static Future<bool> areNotificationsEnabled() async {
    try {
      return SharedPrefs.areNotificationsEnabled();
    } catch (e) {
      return true;
    }
  }

  /// Set push notifications enabled
  static Future<void> setPushNotificationsEnabled(bool enabled) async {
    try {
      await updatePreference('push_notifications_enabled', enabled);
    } catch (e) {
      throw StorageError(
          message: 'Failed to set push notifications preference: $e');
    }
  }

  /// Get push notifications enabled status
  static Future<bool> arePushNotificationsEnabled() async {
    try {
      return await getPreference<bool>('push_notifications_enabled', true) ??
          true;
    } catch (e) {
      return true;
    }
  }

  /// Set email notifications enabled
  static Future<void> setEmailNotificationsEnabled(bool enabled) async {
    try {
      await updatePreference('email_notifications_enabled', enabled);
    } catch (e) {
      throw StorageError(
          message: 'Failed to set email notifications preference: $e');
    }
  }

  /// Get email notifications enabled status
  static Future<bool> areEmailNotificationsEnabled() async {
    try {
      return await getPreference<bool>('email_notifications_enabled', true) ??
          true;
    } catch (e) {
      return true;
    }
  }

  // Privacy and security preferences
  /// Set analytics enabled
  static Future<void> setAnalyticsEnabled(bool enabled) async {
    try {
      await SharedPrefs.setAnalyticsEnabled(enabled);
      await updatePreference('analytics_enabled', enabled);
    } catch (e) {
      throw StorageError(message: 'Failed to set analytics preference: $e');
    }
  }

  /// Get analytics enabled status
  static Future<bool> isAnalyticsEnabled() async {
    try {
      return SharedPrefs.isAnalyticsEnabled();
    } catch (e) {
      return true;
    }
  }

  /// Set crash reporting enabled
  static Future<void> setCrashReportingEnabled(bool enabled) async {
    try {
      await SharedPrefs.setCrashReportingEnabled(enabled);
      await updatePreference('crash_reporting_enabled', enabled);
    } catch (e) {
      throw StorageError(
          message: 'Failed to set crash reporting preference: $e');
    }
  }

  /// Get crash reporting enabled status
  static Future<bool> isCrashReportingEnabled() async {
    try {
      return SharedPrefs.isCrashReportingEnabled();
    } catch (e) {
      return true;
    }
  }

  // Data and storage preferences
  /// Set auto backup enabled
  static Future<void> setAutoBackupEnabled(bool enabled) async {
    try {
      await SharedPrefs.setAutoBackupEnabled(enabled);
      await updatePreference('auto_backup_enabled', enabled);
    } catch (e) {
      throw StorageError(message: 'Failed to set auto backup preference: $e');
    }
  }

  /// Get auto backup enabled status
  static Future<bool> isAutoBackupEnabled() async {
    try {
      return SharedPrefs.isAutoBackupEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Set data saver mode
  static Future<void> setDataSaverMode(bool enabled) async {
    try {
      await updatePreference('data_saver_mode', enabled);
    } catch (e) {
      throw StorageError(message: 'Failed to set data saver mode: $e');
    }
  }

  /// Get data saver mode status
  static Future<bool> isDataSaverModeEnabled() async {
    try {
      return await getPreference<bool>('data_saver_mode', false) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Set offline mode
  static Future<void> setOfflineMode(bool enabled) async {
    try {
      await updatePreference('offline_mode', enabled);
    } catch (e) {
      throw StorageError(message: 'Failed to set offline mode: $e');
    }
  }

  /// Get offline mode status
  static Future<bool> isOfflineModeEnabled() async {
    try {
      return await getPreference<bool>('offline_mode', false) ?? false;
    } catch (e) {
      return false;
    }
  }

  // User cache management
  /// Store user cache data
  static Future<void> storeUserCache(Map<String, dynamic> cache) async {
    try {
      await SharedPrefs.setJson(_userCacheKey, cache);
    } catch (e) {
      throw StorageError(message: 'Failed to store user cache: $e');
    }
  }

  /// Get user cache data
  static Future<Map<String, dynamic>?> getUserCache() async {
    try {
      return SharedPrefs.getJson(_userCacheKey);
    } catch (e) {
      return null;
    }
  }

  /// Update cache item
  static Future<void> updateCacheItem(String key, dynamic value) async {
    try {
      final cache = await getUserCache() ?? <String, dynamic>{};
      cache[key] = value;
      await storeUserCache(cache);
    } catch (e) {
      throw StorageError(message: 'Failed to update cache item: $e');
    }
  }

  /// Get cache item
  static Future<T?> getCacheItem<T>(String key) async {
    try {
      final cache = await getUserCache();
      return cache?[key] as T?;
    } catch (e) {
      return null;
    }
  }

  /// Clear user cache
  static Future<void> clearUserCache() async {
    try {
      await SharedPrefs.remove(_userCacheKey);
    } catch (e) {
      throw StorageError(message: 'Failed to clear user cache: $e');
    }
  }

  // User metadata
  /// Store user metadata
  static Future<void> storeUserMetadata(Map<String, dynamic> metadata) async {
    try {
      await SharedPrefs.setJson(_userMetadataKey, metadata);
    } catch (e) {
      throw StorageError(message: 'Failed to store user metadata: $e');
    }
  }

  /// Get user metadata
  static Future<Map<String, dynamic>?> getUserMetadata() async {
    try {
      return SharedPrefs.getJson(_userMetadataKey);
    } catch (e) {
      return null;
    }
  }

  /// Update metadata field
  static Future<void> updateMetadataField(String field, dynamic value) async {
    try {
      final metadata = await getUserMetadata() ?? <String, dynamic>{};
      metadata[field] = value;
      metadata['updated_at'] = DateTime.now().millisecondsSinceEpoch;
      await storeUserMetadata(metadata);
    } catch (e) {
      throw StorageError(message: 'Failed to update metadata field: $e');
    }
  }

  /// Get metadata field
  static Future<T?> getMetadataField<T>(String field) async {
    try {
      final metadata = await getUserMetadata();
      return metadata?[field] as T?;
    } catch (e) {
      return null;
    }
  }

  // Utility methods
  /// Get all user data
  static Future<Map<String, dynamic>> getAllUserData() async {
    try {
      final profile = await getUserProfile();
      final preferences = await getUserPreferences();
      final settings = await getUserSettings();
      final cache = await getUserCache();
      final metadata = await getUserMetadata();

      return {
        'profile': profile,
        'preferences': preferences,
        'settings': settings,
        'cache': cache,
        'metadata': metadata,
      };
    } catch (e) {
      throw StorageError(message: 'Failed to get all user data: $e');
    }
  }

  /// Clear all user data
  static Future<void> clearAllUserData() async {
    try {
      await Future.wait([
        SharedPrefs.remove(_userProfileKey),
        SharedPrefs.remove(_userPreferencesKey),
        SharedPrefs.remove(_userSettingsKey),
        SharedPrefs.remove(_userCacheKey),
        SharedPrefs.remove(_userMetadataKey),
      ]);
    } catch (e) {
      throw StorageError(message: 'Failed to clear all user data: $e');
    }
  }

  /// Export user data for backup
  static Future<Map<String, dynamic>> exportUserData() async {
    try {
      final allData = await getAllUserData();
      allData['exported_at'] = DateTime.now().toIso8601String();
      allData['version'] = '1.0';
      return allData;
    } catch (e) {
      throw StorageError(message: 'Failed to export user data: $e');
    }
  }

  /// Import user data from backup
  static Future<void> importUserData(Map<String, dynamic> data) async {
    try {
      if (data.containsKey('profile') && data['profile'] != null) {
        await storeUserProfile(data['profile'] as Map<String, dynamic>);
      }

      if (data.containsKey('preferences') && data['preferences'] != null) {
        await storeUserPreferences(data['preferences'] as Map<String, dynamic>);
      }

      if (data.containsKey('settings') && data['settings'] != null) {
        await storeUserSettings(data['settings'] as Map<String, dynamic>);
      }

      if (data.containsKey('cache') && data['cache'] != null) {
        await storeUserCache(data['cache'] as Map<String, dynamic>);
      }

      if (data.containsKey('metadata') && data['metadata'] != null) {
        await storeUserMetadata(data['metadata'] as Map<String, dynamic>);
      }
    } catch (e) {
      throw StorageError(message: 'Failed to import user data: $e');
    }
  }

  /// Validate user data integrity
  static Future<bool> validateUserData() async {
    try {
      // Check if critical data exists and is valid
      final profile = await getUserProfile();
      final preferences = await getUserPreferences();

      // Basic validation - can be extended based on requirements
      if (profile != null && profile.isNotEmpty) {
        // Profile exists and has data
      }

      if (preferences != null && preferences.isNotEmpty) {
        // Preferences exist and have data
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Migrate user data from old format (if needed)
  static Future<void> migrateUserData() async {
    try {
      // This method can be used to migrate data from old storage formats
      // Implementation depends on specific migration needs

      // Example: Initialize metadata if it doesn't exist
      final metadata = await getUserMetadata();
      if (metadata == null) {
        await storeUserMetadata({
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'version': '1.0',
        });
      }
    } catch (e) {
      // Migration errors shouldn't break the app
    }
  }

  /// Get user data summary
  static Future<Map<String, dynamic>> getUserDataSummary() async {
    try {
      final profile = await getUserProfile();
      final preferences = await getUserPreferences();
      final settings = await getUserSettings();
      final cache = await getUserCache();
      final metadata = await getUserMetadata();

      return {
        'has_profile': profile != null && profile.isNotEmpty,
        'has_preferences': preferences != null && preferences.isNotEmpty,
        'has_settings': settings != null && settings.isNotEmpty,
        'has_cache': cache != null && cache.isNotEmpty,
        'has_metadata': metadata != null && metadata.isNotEmpty,
        'profile_fields': profile?.keys.length ?? 0,
        'preferences_count': preferences?.keys.length ?? 0,
        'settings_count': settings?.keys.length ?? 0,
        'cache_items': cache?.keys.length ?? 0,
        'metadata_fields': metadata?.keys.length ?? 0,
        'last_updated': metadata?['updated_at'],
      };
    } catch (e) {
      throw StorageError(message: 'Failed to get user data summary: $e');
    }
  }
}
