import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported locales in the app
enum SupportedLocale {
  english('en', 'US', 'English'),
  spanish('es', 'ES', 'Español'),
  french('fr', 'FR', 'Français'),
  german('de', 'DE', 'Deutsch'),
  italian('it', 'IT', 'Italiano'),
  portuguese('pt', 'BR', 'Português'),
  chinese('zh', 'CN', '中文'),
  japanese('ja', 'JP', '日本語'),
  korean('ko', 'KR', '한국어'),
  arabic('ar', 'SA', 'العربية');

  const SupportedLocale(this.languageCode, this.countryCode, this.displayName);

  final String languageCode;
  final String countryCode;
  final String displayName;

  /// Convert to Flutter Locale
  Locale get locale => Locale(languageCode, countryCode);

  /// Get locale from language and country codes
  static SupportedLocale? fromCodes(String languageCode,
      [String? countryCode]) {
    for (final supportedLocale in SupportedLocale.values) {
      if (supportedLocale.languageCode == languageCode &&
          (countryCode == null || supportedLocale.countryCode == countryCode)) {
        return supportedLocale;
      }
    }
    return null;
  }

  /// Get locale from Flutter Locale
  static SupportedLocale? fromLocale(Locale locale) {
    return fromCodes(locale.languageCode, locale.countryCode);
  }

  /// Get all supported locales as Flutter Locales
  static List<Locale> get supportedLocales {
    return SupportedLocale.values.map((e) => e.locale).toList();
  }

  /// Check if a locale is supported
  static bool isSupported(Locale locale) {
    return fromLocale(locale) != null;
  }

  /// Get default locale (English)
  static SupportedLocale get defaultLocale => SupportedLocale.english;

  /// Get device locale if supported, otherwise default
  static SupportedLocale getDeviceLocaleOrDefault() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    return fromLocale(deviceLocale) ?? defaultLocale;
  }
}

/// Locale state class
class LocaleState {
  final SupportedLocale currentLocale;
  final bool isLoading;
  final String? errorMessage;

  const LocaleState({
    required this.currentLocale,
    this.isLoading = false,
    this.errorMessage,
  });

  LocaleState copyWith({
    SupportedLocale? currentLocale,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocaleState(
      currentLocale: currentLocale ?? this.currentLocale,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  /// Get current locale as Flutter Locale
  Locale get locale => currentLocale.locale;

  /// Check if current locale is RTL
  bool get isRTL => currentLocale == SupportedLocale.arabic;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocaleState &&
        other.currentLocale == currentLocale &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(currentLocale, isLoading, errorMessage);

  @override
  String toString() {
    return 'LocaleState(locale: ${currentLocale.displayName}, isLoading: $isLoading)';
  }
}

/// Locale notifier that manages app localization
class LocaleNotifier extends StateNotifier<LocaleState> {
  LocaleNotifier()
      : super(
          LocaleState(
              currentLocale: SupportedLocale.getDeviceLocaleOrDefault()),
        ) {
    _initialize();
  }

  static const String _localeKey = 'app_locale';

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localeKey);

      if (savedLocaleCode != null) {
        final parts = savedLocaleCode.split('_');
        final languageCode = parts[0];
        final countryCode = parts.length > 1 ? parts[1] : null;

        final savedLocale =
            SupportedLocale.fromCodes(languageCode, countryCode);
        if (savedLocale != null) {
          state = state.copyWith(
            currentLocale: savedLocale,
            isLoading: false,
            errorMessage: null,
          );
          return;
        }
      }

      // If no saved locale or invalid, use device locale or default
      state = state.copyWith(
        currentLocale: SupportedLocale.getDeviceLocaleOrDefault(),
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load locale preference: $e',
      );
    }
  }

  /// Change the app locale
  Future<void> changeLocale(SupportedLocale newLocale) async {
    if (state.currentLocale == newLocale) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = '${newLocale.languageCode}_${newLocale.countryCode}';

      await prefs.setString(_localeKey, localeCode);

      state = state.copyWith(
        currentLocale: newLocale,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save locale preference: $e',
      );
    }
  }

  /// Reset to device locale or default
  Future<void> resetToDeviceLocale() async {
    final deviceLocale = SupportedLocale.getDeviceLocaleOrDefault();
    await changeLocale(deviceLocale);
  }

  /// Clear any error messages
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}

/// Provider for locale state
final localeProvider =
    StateNotifierProvider<LocaleNotifier, LocaleState>((ref) {
  return LocaleNotifier();
});

/// Convenience provider for current locale
final currentLocaleProvider = Provider<Locale>((ref) {
  return ref.watch(localeProvider).locale;
});

/// Convenience provider for current supported locale
final currentSupportedLocaleProvider = Provider<SupportedLocale>((ref) {
  return ref.watch(localeProvider).currentLocale;
});

/// Convenience provider for RTL check
final isRTLProvider = Provider<bool>((ref) {
  return ref.watch(localeProvider).isRTL;
});

/// Convenience provider for locale loading state
final localeLoadingProvider = Provider<bool>((ref) {
  return ref.watch(localeProvider).isLoading;
});

/// Provider for locale actions
final localeActionsProvider = Provider<LocaleActions>((ref) {
  return LocaleActions(ref);
});

/// Actions class for locale operations
class LocaleActions {
  final Ref _ref;

  LocaleActions(this._ref);

  /// Change app locale
  Future<void> changeLocale(SupportedLocale locale) async {
    await _ref.read(localeProvider.notifier).changeLocale(locale);
  }

  /// Reset to device locale
  Future<void> resetToDeviceLocale() async {
    await _ref.read(localeProvider.notifier).resetToDeviceLocale();
  }

  /// Clear error messages
  void clearError() {
    _ref.read(localeProvider.notifier).clearError();
  }

  /// Get all supported locales
  List<SupportedLocale> getSupportedLocales() {
    return SupportedLocale.values;
  }

  /// Check if locale is currently selected
  bool isCurrentLocale(SupportedLocale locale) {
    return _ref.read(currentSupportedLocaleProvider) == locale;
  }

  /// Get locale display name
  String getLocaleDisplayName(SupportedLocale locale) {
    return locale.displayName;
  }
}
