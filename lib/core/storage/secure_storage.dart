import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../error/app_error.dart';

/// Secure storage wrapper for sensitive data with enhanced error handling and type safety
class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _lastLoginKey = 'last_login';
  static const String _deviceIdKey = 'device_id';

  /// Generic method to read a value from secure storage
  static Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw StorageError(message: 'Failed to read from secure storage: $e');
    }
  }

  /// Generic method to write a value to secure storage
  static Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw StorageError(message: 'Failed to write to secure storage: $e');
    }
  }

  /// Generic method to delete a value from secure storage
  static Future<void> _delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw StorageError(message: 'Failed to delete from secure storage: $e');
    }
  }

  /// Store a JSON object in secure storage
  static Future<void> _writeJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      await _write(key, jsonString);
    } catch (e) {
      throw StorageError(message: 'Failed to write JSON to secure storage: $e');
    }
  }

  /// Read a JSON object from secure storage
  static Future<Map<String, dynamic>?> _readJson(String key) async {
    try {
      final jsonString = await _read(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw StorageError(
          message: 'Failed to read JSON from secure storage: $e');
    }
  }

  // Authentication token methods
  /// Get authentication token
  static Future<String?> getToken() async {
    return await _read(_tokenKey);
  }

  /// Store authentication token
  static Future<void> setToken(String token) async {
    await _write(_tokenKey, token);
  }

  /// Clear authentication token
  static Future<void> clearToken() async {
    await _delete(_tokenKey);
  }

  // Refresh token methods
  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _read(_refreshTokenKey);
  }

  /// Store refresh token
  static Future<void> setRefreshToken(String token) async {
    await _write(_refreshTokenKey, token);
  }

  /// Clear refresh token
  static Future<void> clearRefreshToken() async {
    await _delete(_refreshTokenKey);
  }

  // User ID methods
  /// Get user ID
  static Future<String?> getUserId() async {
    return await _read(_userIdKey);
  }

  /// Store user ID
  static Future<void> setUserId(String userId) async {
    await _write(_userIdKey, userId);
  }

  /// Clear user ID
  static Future<void> clearUserId() async {
    await _delete(_userIdKey);
  }

  // Biometric settings
  /// Get biometric enabled status
  static Future<bool> getBiometricEnabled() async {
    final value = await _read(_biometricEnabledKey);
    return value == 'true';
  }

  /// Set biometric enabled status
  static Future<void> setBiometricEnabled(bool enabled) async {
    await _write(_biometricEnabledKey, enabled.toString());
  }

  // Last login timestamp
  /// Get last login timestamp
  static Future<DateTime?> getLastLogin() async {
    final value = await _read(_lastLoginKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  /// Set last login timestamp
  static Future<void> setLastLogin(DateTime dateTime) async {
    await _write(_lastLoginKey, dateTime.toIso8601String());
  }

  // Device ID
  /// Get device ID
  static Future<String?> getDeviceId() async {
    return await _read(_deviceIdKey);
  }

  /// Set device ID
  static Future<void> setDeviceId(String deviceId) async {
    await _write(_deviceIdKey, deviceId);
  }

  // Utility methods
  /// Check if a key exists in secure storage
  static Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  /// Get all keys from secure storage
  static Future<Set<String>> getAllKeys() async {
    try {
      final all = await _storage.readAll();
      return all.keys.toSet();
    } catch (e) {
      throw StorageError(
          message: 'Failed to get all keys from secure storage: $e');
    }
  }

  /// Clear all authentication-related data
  static Future<void> clearAuthData() async {
    await Future.wait([
      clearToken(),
      clearRefreshToken(),
      clearUserId(),
    ]);
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw StorageError(message: 'Failed to clear all secure storage: $e');
    }
  }

  /// Store custom data as JSON
  static Future<void> setCustomData(
      String key, Map<String, dynamic> data) async {
    await _writeJson(key, data);
  }

  /// Get custom data as JSON
  static Future<Map<String, dynamic>?> getCustomData(String key) async {
    return await _readJson(key);
  }

  /// Store custom string data
  static Future<void> setCustomString(String key, String value) async {
    await _write(key, value);
  }

  /// Get custom string data
  static Future<String?> getCustomString(String key) async {
    return await _read(key);
  }

  /// Delete custom data
  static Future<void> deleteCustomData(String key) async {
    await _delete(key);
  }
}
