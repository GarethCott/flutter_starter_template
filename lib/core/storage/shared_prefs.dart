import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../error/app_error.dart';

/// Type-safe SharedPreferences wrapper for app settings and preferences
class SharedPrefs {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      throw StorageError(message: 'Failed to initialize SharedPreferences: $e');
    }
  }

  /// Get SharedPreferences instance
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StorageError(
          message:
              'SharedPreferences not initialized. Call SharedPrefs.init() first.');
    }
    return _prefs!;
  }

  // Preference keys
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _analyticsKey = 'analytics_enabled';
  static const String _crashReportingKey = 'crash_reporting_enabled';
  static const String _autoBackupKey = 'auto_backup_enabled';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _appVersionKey = 'app_version';
  static const String _buildNumberKey = 'build_number';

  // String methods
  /// Get string value
  static String? getString(String key) {
    try {
      return _instance.getString(key);
    } catch (e) {
      throw StorageError(
          message: 'Failed to get string from SharedPreferences: $e');
    }
  }

  /// Set string value
  static Future<bool> setString(String key, String value) async {
    try {
      return await _instance.setString(key, value);
    } catch (e) {
      throw StorageError(
          message: 'Failed to set string in SharedPreferences: $e');
    }
  }

  // Integer methods
  /// Get integer value
  static int? getInt(String key) {
    try {
      return _instance.getInt(key);
    } catch (e) {
      throw StorageError(
          message: 'Failed to get int from SharedPreferences: $e');
    }
  }

  /// Set integer value
  static Future<bool> setInt(String key, int value) async {
    try {
      return await _instance.setInt(key, value);
    } catch (e) {
      throw StorageError(message: 'Failed to set int in SharedPreferences: $e');
    }
  }

  // Double methods
  /// Get double value
  static double? getDouble(String key) {
    try {
      return _instance.getDouble(key);
    } catch (e) {
      throw StorageError(
          message: 'Failed to get double from SharedPreferences: $e');
    }
  }

  /// Set double value
  static Future<bool> setDouble(String key, double value) async {
    try {
      return await _instance.setDouble(key, value);
    } catch (e) {
      throw StorageError(
          message: 'Failed to set double in SharedPreferences: $e');
    }
  }

  // Boolean methods
  /// Get boolean value
  static bool? getBool(String key) {
    try {
      return _instance.getBool(key);
    } catch (e) {
      throw StorageError(
          message: 'Failed to get bool from SharedPreferences: $e');
    }
  }

  /// Set boolean value
  static Future<bool> setBool(String key, bool value) async {
    try {
      return await _instance.setBool(key, value);
    } catch (e) {
      throw StorageError(
          message: 'Failed to set bool in SharedPreferences: $e');
    }
  }

  // String list methods
  /// Get string list value
  static List<String>? getStringList(String key) {
    try {
      return _instance.getStringList(key);
    } catch (e) {
      throw StorageError(
          message: 'Failed to get string list from SharedPreferences: $e');
    }
  }

  /// Set string list value
  static Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _instance.setStringList(key, value);
    } catch (e) {
      throw StorageError(
          message: 'Failed to set string list in SharedPreferences: $e');
    }
  }

  // JSON methods
  /// Get JSON object
  static Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _instance.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw StorageError(
          message: 'Failed to get JSON from SharedPreferences: $e');
    }
  }

  /// Set JSON object
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await _instance.setString(key, jsonString);
    } catch (e) {
      throw StorageError(
          message: 'Failed to set JSON in SharedPreferences: $e');
    }
  }

  // Utility methods
  /// Check if key exists
  static bool containsKey(String key) {
    try {
      return _instance.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Remove a key
  static Future<bool> remove(String key) async {
    try {
      return await _instance.remove(key);
    } catch (e) {
      throw StorageError(
          message: 'Failed to remove key from SharedPreferences: $e');
    }
  }

  /// Clear all preferences
  static Future<bool> clear() async {
    try {
      return await _instance.clear();
    } catch (e) {
      throw StorageError(message: 'Failed to clear SharedPreferences: $e');
    }
  }

  /// Get all keys
  static Set<String> getKeys() {
    try {
      return _instance.getKeys();
    } catch (e) {
      throw StorageError(
          message: 'Failed to get keys from SharedPreferences: $e');
    }
  }

  /// Reload preferences from storage
  static Future<void> reload() async {
    try {
      await _instance.reload();
    } catch (e) {
      throw StorageError(message: 'Failed to reload SharedPreferences: $e');
    }
  }

  // App-specific preference methods
  /// Get theme mode
  static String getThemeMode() {
    return getString(_themeKey) ?? 'system';
  }

  /// Set theme mode
  static Future<bool> setThemeMode(String themeMode) async {
    return await setString(_themeKey, themeMode);
  }

  /// Get language code
  static String? getLanguageCode() {
    return getString(_languageKey);
  }

  /// Set language code
  static Future<bool> setLanguageCode(String languageCode) async {
    return await setString(_languageKey, languageCode);
  }

  /// Get onboarding completion status
  static bool isOnboardingCompleted() {
    return getBool(_onboardingKey) ?? false;
  }

  /// Set onboarding completion status
  static Future<bool> setOnboardingCompleted(bool completed) async {
    return await setBool(_onboardingKey, completed);
  }

  /// Get notifications enabled status
  static bool areNotificationsEnabled() {
    return getBool(_notificationsKey) ?? true;
  }

  /// Set notifications enabled status
  static Future<bool> setNotificationsEnabled(bool enabled) async {
    return await setBool(_notificationsKey, enabled);
  }

  /// Get analytics enabled status
  static bool isAnalyticsEnabled() {
    return getBool(_analyticsKey) ?? true;
  }

  /// Set analytics enabled status
  static Future<bool> setAnalyticsEnabled(bool enabled) async {
    return await setBool(_analyticsKey, enabled);
  }

  /// Get crash reporting enabled status
  static bool isCrashReportingEnabled() {
    return getBool(_crashReportingKey) ?? true;
  }

  /// Set crash reporting enabled status
  static Future<bool> setCrashReportingEnabled(bool enabled) async {
    return await setBool(_crashReportingKey, enabled);
  }

  /// Get auto backup enabled status
  static bool isAutoBackupEnabled() {
    return getBool(_autoBackupKey) ?? false;
  }

  /// Set auto backup enabled status
  static Future<bool> setAutoBackupEnabled(bool enabled) async {
    return await setBool(_autoBackupKey, enabled);
  }

  /// Get last sync timestamp
  static DateTime? getLastSyncTimestamp() {
    final timestamp = getInt(_lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Set last sync timestamp
  static Future<bool> setLastSyncTimestamp(DateTime timestamp) async {
    return await setInt(_lastSyncKey, timestamp.millisecondsSinceEpoch);
  }

  /// Get app version
  static String? getAppVersion() {
    return getString(_appVersionKey);
  }

  /// Set app version
  static Future<bool> setAppVersion(String version) async {
    return await setString(_appVersionKey, version);
  }

  /// Get build number
  static int? getBuildNumber() {
    return getInt(_buildNumberKey);
  }

  /// Set build number
  static Future<bool> setBuildNumber(int buildNumber) async {
    return await setInt(_buildNumberKey, buildNumber);
  }

  /// Get user preferences as a map
  static Map<String, dynamic> getUserPreferences() {
    return {
      'theme_mode': getThemeMode(),
      'language_code': getLanguageCode(),
      'notifications_enabled': areNotificationsEnabled(),
      'analytics_enabled': isAnalyticsEnabled(),
      'crash_reporting_enabled': isCrashReportingEnabled(),
      'auto_backup_enabled': isAutoBackupEnabled(),
    };
  }

  /// Set multiple user preferences at once
  static Future<void> setUserPreferences(
      Map<String, dynamic> preferences) async {
    final futures = <Future<bool>>[];

    if (preferences.containsKey('theme_mode')) {
      futures.add(setThemeMode(preferences['theme_mode'] as String));
    }
    if (preferences.containsKey('language_code')) {
      futures.add(setLanguageCode(preferences['language_code'] as String));
    }
    if (preferences.containsKey('notifications_enabled')) {
      futures.add(setNotificationsEnabled(
          preferences['notifications_enabled'] as bool));
    }
    if (preferences.containsKey('analytics_enabled')) {
      futures
          .add(setAnalyticsEnabled(preferences['analytics_enabled'] as bool));
    }
    if (preferences.containsKey('crash_reporting_enabled')) {
      futures.add(setCrashReportingEnabled(
          preferences['crash_reporting_enabled'] as bool));
    }
    if (preferences.containsKey('auto_backup_enabled')) {
      futures.add(
          setAutoBackupEnabled(preferences['auto_backup_enabled'] as bool));
    }

    await Future.wait(futures);
  }
}
