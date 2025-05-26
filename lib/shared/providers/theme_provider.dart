import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Theme mode notifier that handles theme changes and persistence
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const String _themeModeKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  /// Load theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeModeKey);

      if (themeModeString != null) {
        final themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.system,
        );
        state = themeMode;
      }
    } catch (e) {
      // If loading fails, keep the default system theme
      state = ThemeMode.system;
    }
  }

  /// Set theme mode and persist to SharedPreferences
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, themeMode.toString());
      state = themeMode;
    } catch (e) {
      // If saving fails, still update the state
      state = themeMode;
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newThemeMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    await setThemeMode(newThemeMode);
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}

/// Convenience provider for checking if current theme is dark
@riverpod
bool isDarkMode(IsDarkModeRef ref) {
  final themeMode = ref.watch(themeModeNotifierProvider);
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  return switch (themeMode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system => brightness == Brightness.dark,
  };
}

/// Convenience provider for getting theme mode display name
@riverpod
String themeModeDisplayName(ThemeModeDisplayNameRef ref) {
  final themeMode = ref.watch(themeModeNotifierProvider);

  return switch (themeMode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    ThemeMode.system => 'System',
  };
}
