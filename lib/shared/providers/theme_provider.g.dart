// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isDarkModeHash() => r'ba07bbff12007d5d250f9ab33dde8f61ad2b6180';

/// Convenience provider for checking if current theme is dark
///
/// Copied from [isDarkMode].
@ProviderFor(isDarkMode)
final isDarkModeProvider = AutoDisposeProvider<bool>.internal(
  isDarkMode,
  name: r'isDarkModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isDarkModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDarkModeRef = AutoDisposeProviderRef<bool>;
String _$themeModeDisplayNameHash() =>
    r'7477f1a1634b6c9770d49a6b4e1a30aff88f519d';

/// Convenience provider for getting theme mode display name
///
/// Copied from [themeModeDisplayName].
@ProviderFor(themeModeDisplayName)
final themeModeDisplayNameProvider = AutoDisposeProvider<String>.internal(
  themeModeDisplayName,
  name: r'themeModeDisplayNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeDisplayNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThemeModeDisplayNameRef = AutoDisposeProviderRef<String>;
String _$themeModeNotifierHash() => r'80c757e65bd05a305580ca6bc6cdeda413367a46';

/// Theme mode notifier that handles theme changes and persistence
///
/// Copied from [ThemeModeNotifier].
@ProviderFor(ThemeModeNotifier)
final themeModeNotifierProvider =
    AutoDisposeNotifierProvider<ThemeModeNotifier, ThemeMode>.internal(
  ThemeModeNotifier.new,
  name: r'themeModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeNotifier = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
