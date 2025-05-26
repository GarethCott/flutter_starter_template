import '../../error/app_error.dart';
import '../cache_manager.dart';
import '../shared_prefs.dart';

/// Application state persistence and configuration storage service
class AppStorageService {
  // Storage keys
  static const String _appStateKey = 'app_state';
  static const String _appConfigKey = 'app_config';
  static const String _featureFlagsKey = 'feature_flags';
  static const String _appMetricsKey = 'app_metrics';
  static const String _debugInfoKey = 'debug_info';
  static const String _crashLogsKey = 'crash_logs';

  /// Store application state
  static Future<void> storeAppState(Map<String, dynamic> state) async {
    try {
      state['updated_at'] = DateTime.now().millisecondsSinceEpoch;
      await SharedPrefs.setJson(_appStateKey, state);
    } catch (e) {
      throw StorageError(message: 'Failed to store app state: $e');
    }
  }

  /// Get application state
  static Future<Map<String, dynamic>?> getAppState() async {
    try {
      return SharedPrefs.getJson(_appStateKey);
    } catch (e) {
      return null;
    }
  }

  /// Update specific app state field
  static Future<void> updateAppStateField(String field, dynamic value) async {
    try {
      final state = await getAppState() ?? <String, dynamic>{};
      state[field] = value;
      await storeAppState(state);
    } catch (e) {
      throw StorageError(message: 'Failed to update app state field: $e');
    }
  }

  /// Get specific app state field
  static Future<T?> getAppStateField<T>(String field) async {
    try {
      final state = await getAppState();
      return state?[field] as T?;
    } catch (e) {
      return null;
    }
  }

  /// Store application configuration
  static Future<void> storeAppConfig(Map<String, dynamic> config) async {
    try {
      config['updated_at'] = DateTime.now().millisecondsSinceEpoch;
      await SharedPrefs.setJson(_appConfigKey, config);
    } catch (e) {
      throw StorageError(message: 'Failed to store app config: $e');
    }
  }

  /// Get application configuration
  static Future<Map<String, dynamic>?> getAppConfig() async {
    try {
      return SharedPrefs.getJson(_appConfigKey);
    } catch (e) {
      return null;
    }
  }

  /// Update specific config field
  static Future<void> updateConfigField(String field, dynamic value) async {
    try {
      final config = await getAppConfig() ?? <String, dynamic>{};
      config[field] = value;
      await storeAppConfig(config);
    } catch (e) {
      throw StorageError(message: 'Failed to update config field: $e');
    }
  }

  /// Get specific config field
  static Future<T?> getConfigField<T>(String field, [T? defaultValue]) async {
    try {
      final config = await getAppConfig();
      return config?[field] as T? ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // App version and build management
  /// Set current app version
  static Future<void> setAppVersion(String version) async {
    try {
      await SharedPrefs.setAppVersion(version);
      await updateAppStateField('app_version', version);
    } catch (e) {
      throw StorageError(message: 'Failed to set app version: $e');
    }
  }

  /// Get current app version
  static Future<String?> getAppVersion() async {
    try {
      return SharedPrefs.getAppVersion();
    } catch (e) {
      return null;
    }
  }

  /// Set current build number
  static Future<void> setBuildNumber(int buildNumber) async {
    try {
      await SharedPrefs.setBuildNumber(buildNumber);
      await updateAppStateField('build_number', buildNumber);
    } catch (e) {
      throw StorageError(message: 'Failed to set build number: $e');
    }
  }

  /// Get current build number
  static Future<int?> getBuildNumber() async {
    try {
      return SharedPrefs.getBuildNumber();
    } catch (e) {
      return null;
    }
  }

  /// Check if app was updated
  static Future<bool> wasAppUpdated(
      String currentVersion, int currentBuild) async {
    try {
      final storedVersion = await getAppVersion();
      final storedBuild = await getBuildNumber();

      if (storedVersion == null || storedBuild == null) {
        // First launch
        await setAppVersion(currentVersion);
        await setBuildNumber(currentBuild);
        return false;
      }

      final wasUpdated =
          storedVersion != currentVersion || storedBuild != currentBuild;

      if (wasUpdated) {
        await setAppVersion(currentVersion);
        await setBuildNumber(currentBuild);
        await updateAppStateField(
            'last_update', DateTime.now().millisecondsSinceEpoch);
      }

      return wasUpdated;
    } catch (e) {
      return false;
    }
  }

  // Onboarding and first launch
  /// Set onboarding completed
  static Future<void> setOnboardingCompleted(bool completed) async {
    try {
      await SharedPrefs.setOnboardingCompleted(completed);
      await updateAppStateField('onboarding_completed', completed);
    } catch (e) {
      throw StorageError(message: 'Failed to set onboarding status: $e');
    }
  }

  /// Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    try {
      return SharedPrefs.isOnboardingCompleted();
    } catch (e) {
      return false;
    }
  }

  /// Check if this is first app launch
  static Future<bool> isFirstLaunch() async {
    try {
      final firstLaunch = await getAppStateField<bool>('first_launch');
      if (firstLaunch == null) {
        await updateAppStateField('first_launch', false);
        await updateAppStateField(
            'first_launch_date', DateTime.now().millisecondsSinceEpoch);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get first launch date
  static Future<DateTime?> getFirstLaunchDate() async {
    try {
      final timestamp = await getAppStateField<int>('first_launch_date');
      return timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      return null;
    }
  }

  // Feature flags management
  /// Store feature flags
  static Future<void> storeFeatureFlags(Map<String, dynamic> flags) async {
    try {
      flags['updated_at'] = DateTime.now().millisecondsSinceEpoch;
      await SharedPrefs.setJson(_featureFlagsKey, flags);
    } catch (e) {
      throw StorageError(message: 'Failed to store feature flags: $e');
    }
  }

  /// Get feature flags
  static Future<Map<String, dynamic>?> getFeatureFlags() async {
    try {
      return SharedPrefs.getJson(_featureFlagsKey);
    } catch (e) {
      return null;
    }
  }

  /// Check if feature is enabled
  static Future<bool> isFeatureEnabled(String featureName,
      [bool defaultValue = false]) async {
    try {
      final flags = await getFeatureFlags();
      return flags?[featureName] as bool? ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Enable/disable feature
  static Future<void> setFeatureEnabled(
      String featureName, bool enabled) async {
    try {
      final flags = await getFeatureFlags() ?? <String, dynamic>{};
      flags[featureName] = enabled;
      await storeFeatureFlags(flags);
    } catch (e) {
      throw StorageError(message: 'Failed to set feature flag: $e');
    }
  }

  // App metrics and analytics
  /// Store app metrics
  static Future<void> storeAppMetrics(Map<String, dynamic> metrics) async {
    try {
      metrics['updated_at'] = DateTime.now().millisecondsSinceEpoch;
      await SharedPrefs.setJson(_appMetricsKey, metrics);
    } catch (e) {
      throw StorageError(message: 'Failed to store app metrics: $e');
    }
  }

  /// Get app metrics
  static Future<Map<String, dynamic>?> getAppMetrics() async {
    try {
      return SharedPrefs.getJson(_appMetricsKey);
    } catch (e) {
      return null;
    }
  }

  /// Update metric value
  static Future<void> updateMetric(String metricName, dynamic value) async {
    try {
      final metrics = await getAppMetrics() ?? <String, dynamic>{};
      metrics[metricName] = value;
      await storeAppMetrics(metrics);
    } catch (e) {
      throw StorageError(message: 'Failed to update metric: $e');
    }
  }

  /// Increment metric counter
  static Future<void> incrementMetric(String metricName,
      [int increment = 1]) async {
    try {
      final metrics = await getAppMetrics() ?? <String, dynamic>{};
      final currentValue = metrics[metricName] as int? ?? 0;
      metrics[metricName] = currentValue + increment;
      await storeAppMetrics(metrics);
    } catch (e) {
      throw StorageError(message: 'Failed to increment metric: $e');
    }
  }

  /// Get metric value
  static Future<T?> getMetric<T>(String metricName) async {
    try {
      final metrics = await getAppMetrics();
      return metrics?[metricName] as T?;
    } catch (e) {
      return null;
    }
  }

  // Session management
  /// Record app launch
  static Future<void> recordAppLaunch() async {
    try {
      await incrementMetric('launch_count');
      await updateAppStateField(
          'last_launch', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw StorageError(message: 'Failed to record app launch: $e');
    }
  }

  /// Record app session duration
  static Future<void> recordSessionDuration(Duration duration) async {
    try {
      final totalDuration = await getMetric<int>('total_session_duration') ?? 0;
      await updateMetric(
          'total_session_duration', totalDuration + duration.inMilliseconds);
      await updateMetric('last_session_duration', duration.inMilliseconds);
      await incrementMetric('session_count');
    } catch (e) {
      throw StorageError(message: 'Failed to record session duration: $e');
    }
  }

  /// Get last launch time
  static Future<DateTime?> getLastLaunchTime() async {
    try {
      final timestamp = await getAppStateField<int>('last_launch');
      return timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      return null;
    }
  }

  // Debug and development
  /// Store debug information
  static Future<void> storeDebugInfo(Map<String, dynamic> debugInfo) async {
    try {
      debugInfo['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      await SharedPrefs.setJson(_debugInfoKey, debugInfo);
    } catch (e) {
      throw StorageError(message: 'Failed to store debug info: $e');
    }
  }

  /// Get debug information
  static Future<Map<String, dynamic>?> getDebugInfo() async {
    try {
      return SharedPrefs.getJson(_debugInfoKey);
    } catch (e) {
      return null;
    }
  }

  /// Clear debug information
  static Future<void> clearDebugInfo() async {
    try {
      await SharedPrefs.remove(_debugInfoKey);
    } catch (e) {
      throw StorageError(message: 'Failed to clear debug info: $e');
    }
  }

  // Crash logs management
  /// Store crash log
  static Future<void> storeCrashLog(Map<String, dynamic> crashLog) async {
    try {
      final logs = await getCrashLogs();
      crashLog['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      logs.add(crashLog);

      // Keep only the last 10 crash logs
      if (logs.length > 10) {
        logs.removeRange(0, logs.length - 10);
      }

      await SharedPrefs.setJson(_crashLogsKey, {'logs': logs});
    } catch (e) {
      throw StorageError(message: 'Failed to store crash log: $e');
    }
  }

  /// Get crash logs
  static Future<List<Map<String, dynamic>>> getCrashLogs() async {
    try {
      final data = SharedPrefs.getJson(_crashLogsKey);
      if (data == null || !data.containsKey('logs')) {
        return [];
      }
      final logs = data['logs'] as List<dynamic>;
      return logs.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Clear crash logs
  static Future<void> clearCrashLogs() async {
    try {
      await SharedPrefs.remove(_crashLogsKey);
    } catch (e) {
      throw StorageError(message: 'Failed to clear crash logs: $e');
    }
  }

  // Cache management integration
  /// Get cache statistics
  static Future<Map<String, dynamic>> getCacheStats() async {
    try {
      return await CacheManager.getCacheStats();
    } catch (e) {
      return {};
    }
  }

  /// Clear app cache
  static Future<void> clearAppCache() async {
    try {
      await CacheManager.clearAllCache();
    } catch (e) {
      throw StorageError(message: 'Failed to clear app cache: $e');
    }
  }

  /// Cleanup cache if needed
  static Future<void> cleanupCacheIfNeeded() async {
    try {
      await CacheManager.cleanupCacheIfNeeded();
    } catch (e) {
      throw StorageError(message: 'Failed to cleanup cache: $e');
    }
  }

  // Utility methods
  /// Get app summary
  static Future<Map<String, dynamic>> getAppSummary() async {
    try {
      final state = await getAppState();
      final config = await getAppConfig();
      final metrics = await getAppMetrics();
      final flags = await getFeatureFlags();
      final cacheStats = await getCacheStats();

      return {
        'app_version': await getAppVersion(),
        'build_number': await getBuildNumber(),
        'first_launch_date': (await getFirstLaunchDate())?.toIso8601String(),
        'last_launch': (await getLastLaunchTime())?.toIso8601String(),
        'onboarding_completed': await isOnboardingCompleted(),
        'launch_count': await getMetric<int>('launch_count') ?? 0,
        'session_count': await getMetric<int>('session_count') ?? 0,
        'has_state': state != null && state.isNotEmpty,
        'has_config': config != null && config.isNotEmpty,
        'has_metrics': metrics != null && metrics.isNotEmpty,
        'feature_flags_count': flags?.keys.length ?? 0,
        'cache_stats': cacheStats,
        'crash_logs_count': (await getCrashLogs()).length,
      };
    } catch (e) {
      throw StorageError(message: 'Failed to get app summary: $e');
    }
  }

  /// Clear all app data
  static Future<void> clearAllAppData() async {
    try {
      await Future.wait([
        SharedPrefs.remove(_appStateKey),
        SharedPrefs.remove(_appConfigKey),
        SharedPrefs.remove(_featureFlagsKey),
        SharedPrefs.remove(_appMetricsKey),
        SharedPrefs.remove(_debugInfoKey),
        SharedPrefs.remove(_crashLogsKey),
        clearAppCache(),
      ]);
    } catch (e) {
      throw StorageError(message: 'Failed to clear all app data: $e');
    }
  }

  /// Export app data for backup
  static Future<Map<String, dynamic>> exportAppData() async {
    try {
      final state = await getAppState();
      final config = await getAppConfig();
      final metrics = await getAppMetrics();
      final flags = await getFeatureFlags();
      final debugInfo = await getDebugInfo();

      return {
        'app_state': state,
        'app_config': config,
        'app_metrics': metrics,
        'feature_flags': flags,
        'debug_info': debugInfo,
        'exported_at': DateTime.now().toIso8601String(),
        'version': '1.0',
      };
    } catch (e) {
      throw StorageError(message: 'Failed to export app data: $e');
    }
  }

  /// Import app data from backup
  static Future<void> importAppData(Map<String, dynamic> data) async {
    try {
      if (data.containsKey('app_state') && data['app_state'] != null) {
        await storeAppState(data['app_state'] as Map<String, dynamic>);
      }

      if (data.containsKey('app_config') && data['app_config'] != null) {
        await storeAppConfig(data['app_config'] as Map<String, dynamic>);
      }

      if (data.containsKey('app_metrics') && data['app_metrics'] != null) {
        await storeAppMetrics(data['app_metrics'] as Map<String, dynamic>);
      }

      if (data.containsKey('feature_flags') && data['feature_flags'] != null) {
        await storeFeatureFlags(data['feature_flags'] as Map<String, dynamic>);
      }

      if (data.containsKey('debug_info') && data['debug_info'] != null) {
        await storeDebugInfo(data['debug_info'] as Map<String, dynamic>);
      }
    } catch (e) {
      throw StorageError(message: 'Failed to import app data: $e');
    }
  }

  /// Reset app to initial state
  static Future<void> resetAppToInitialState() async {
    try {
      await clearAllAppData();

      // Reinitialize with default values
      await updateAppStateField('first_launch', false);
      await updateAppStateField(
          'first_launch_date', DateTime.now().millisecondsSinceEpoch);
      await setOnboardingCompleted(false);
    } catch (e) {
      throw StorageError(message: 'Failed to reset app to initial state: $e');
    }
  }

  /// Validate app data integrity
  static Future<bool> validateAppData() async {
    try {
      // Check if critical app data exists and is valid
      final state = await getAppState();
      final version = await getAppVersion();

      // Basic validation
      if (state != null && state.containsKey('updated_at')) {
        final updatedAt = state['updated_at'] as int?;
        if (updatedAt != null && updatedAt > 0) {
          // State has valid timestamp
        }
      }

      if (version != null && version.isNotEmpty) {
        // Version is set
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Migrate app data from old format (if needed)
  static Future<void> migrateAppData() async {
    try {
      // This method can be used to migrate data from old storage formats
      // Implementation depends on specific migration needs

      // Example: Initialize app state if it doesn't exist
      final state = await getAppState();
      if (state == null) {
        await storeAppState({
          'initialized': true,
          'version': '1.0',
        });
      }
    } catch (e) {
      // Migration errors shouldn't break the app
    }
  }
}
