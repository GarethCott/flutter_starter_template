import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/shared.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeNotifier = ref.read(themeModeNotifierProvider.notifier);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final themeModeDisplayName = ref.watch(themeModeDisplayNameProvider);

    // Locale state
    final currentLocale = ref.watch(currentSupportedLocaleProvider);
    final localeActions = ref.read(localeActionsProvider);
    final isLocaleLoading = ref.watch(localeLoadingProvider);

    // User state
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final userProfile = ref.watch(userProfileProvider);
    final userPreferences = ref.watch(userPreferencesProvider);
    final userActions = ref.read(userActionsProvider);
    final isUserLoading = ref.watch(userLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const AccessibleText(
          'Settings',
          semanticsLabel: 'Settings page',
        ),
        actions: const [
          CompactNetworkStatusIndicator(),
        ],
      ),
      body: ResponsiveConstraints(
        centerContent: true,
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            child: Column(
              children: [
                // Theme Settings Section
                Card(
                  child: ResponsiveContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AccessibleText(
                          'Theme Settings',
                          style: Theme.of(context).textTheme.titleLarge,
                          semanticsLabel: 'Theme Settings section',
                        ),
                        ResponsiveSpacing(vertical: true),
                        AccessibleTapTarget(
                          onTap: () => _showThemeDialog(
                              context, themeModeNotifier, themeMode),
                          semanticLabel: 'Theme mode setting',
                          semanticHint:
                              'Current theme is $themeModeDisplayName, tap to change',
                          isButton: true,
                          child: ListTile(
                            leading: Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: const AccessibleText('Theme Mode'),
                            subtitle: AccessibleText(
                                'Current: $themeModeDisplayName'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _showThemeDialog(
                                context, themeModeNotifier, themeMode),
                          ),
                        ),
                        const Divider(),
                        AccessibleTapTarget(
                          semanticLabel: 'Material You toggle',
                          semanticHint: 'Use dynamic colors from wallpaper',
                          child: SwitchListTile(
                            secondary: const Icon(Icons.palette),
                            title: const AccessibleText('Material You'),
                            subtitle: const AccessibleText(
                                'Use dynamic colors from wallpaper'),
                            value:
                                true, // This would be from a provider in real implementation
                            onChanged: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: AccessibleText(
                                      'Material You toggle coming soon!'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveSpacing(vertical: true),

                // App Settings Section
                Card(
                  child: ResponsiveContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AccessibleText(
                          'App Settings',
                          style: Theme.of(context).textTheme.titleLarge,
                          semanticsLabel: 'App Settings section',
                        ),
                        ResponsiveSpacing(vertical: true),
                        AccessibleTapTarget(
                          semanticLabel: 'Notifications toggle',
                          semanticHint: userPreferences.notificationsEnabled
                              ? 'Notifications are enabled, tap to disable'
                              : 'Notifications are disabled, tap to enable',
                          child: SwitchListTile(
                            secondary: const Icon(Icons.notifications),
                            title: const AccessibleText('Notifications'),
                            subtitle: const AccessibleText(
                                'Enable app notifications'),
                            value: userPreferences.notificationsEnabled,
                            onChanged: isAuthenticated && !isUserLoading
                                ? (value) async {
                                    await userActions
                                        .toggleNotifications(value);
                                  }
                                : null,
                          ),
                        ),
                        if (userPreferences.notificationsEnabled &&
                            isAuthenticated) ...[
                          const Divider(),
                          AccessibleTapTarget(
                            semanticLabel: 'Email notifications toggle',
                            semanticHint: userPreferences
                                    .emailNotificationsEnabled
                                ? 'Email notifications are enabled, tap to disable'
                                : 'Email notifications are disabled, tap to enable',
                            child: SwitchListTile(
                              secondary: const Icon(Icons.email),
                              title:
                                  const AccessibleText('Email Notifications'),
                              subtitle: const AccessibleText(
                                  'Receive notifications via email'),
                              value: userPreferences.emailNotificationsEnabled,
                              onChanged: !isUserLoading
                                  ? (value) async {
                                      await userActions
                                          .toggleEmailNotifications(value);
                                    }
                                  : null,
                            ),
                          ),
                          const Divider(),
                          AccessibleTapTarget(
                            semanticLabel: 'Push notifications toggle',
                            semanticHint: userPreferences
                                    .pushNotificationsEnabled
                                ? 'Push notifications are enabled, tap to disable'
                                : 'Push notifications are disabled, tap to enable',
                            child: SwitchListTile(
                              secondary: const Icon(Icons.push_pin),
                              title: const AccessibleText('Push Notifications'),
                              subtitle: const AccessibleText(
                                  'Receive push notifications'),
                              value: userPreferences.pushNotificationsEnabled,
                              onChanged: !isUserLoading
                                  ? (value) async {
                                      await userActions
                                          .togglePushNotifications(value);
                                    }
                                  : null,
                            ),
                          ),
                        ],
                        const Divider(),
                        AccessibleTapTarget(
                          onTap: isLocaleLoading
                              ? null
                              : () => _showLanguageDialog(
                                  context, localeActions, currentLocale),
                          semanticLabel: 'Language setting',
                          semanticHint: isLocaleLoading
                              ? 'Language setting is loading'
                              : 'Current language is ${currentLocale.displayName}, tap to change',
                          isButton: true,
                          child: ListTile(
                            leading: Icon(
                              Icons.language,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: const AccessibleText('Language'),
                            subtitle: AccessibleText(
                              isLocaleLoading
                                  ? 'Loading...'
                                  : currentLocale.displayName,
                            ),
                            trailing: isLocaleLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.chevron_right),
                            onTap: isLocaleLoading
                                ? null
                                : () => _showLanguageDialog(
                                    context, localeActions, currentLocale),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveSpacing(vertical: true),

                // Privacy & Analytics Section
                if (isAuthenticated)
                  Card(
                    child: ResponsiveContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AccessibleText(
                            'Privacy & Analytics',
                            style: Theme.of(context).textTheme.titleLarge,
                            semanticsLabel: 'Privacy and Analytics section',
                          ),
                          ResponsiveSpacing(vertical: true),
                          AccessibleTapTarget(
                            semanticLabel: 'Analytics toggle',
                            semanticHint: userPreferences.analyticsEnabled
                                ? 'Analytics are enabled, tap to disable'
                                : 'Analytics are disabled, tap to enable',
                            child: SwitchListTile(
                              secondary: const Icon(Icons.analytics),
                              title: const AccessibleText('Analytics'),
                              subtitle: const AccessibleText(
                                  'Help improve the app with usage data'),
                              value: userPreferences.analyticsEnabled,
                              onChanged: !isUserLoading
                                  ? (value) async {
                                      final newPrefs = userPreferences.copyWith(
                                        analyticsEnabled: value,
                                      );
                                      await userActions
                                          .updatePreferences(newPrefs);
                                    }
                                  : null,
                            ),
                          ),
                          const Divider(),
                          AccessibleTapTarget(
                            semanticLabel: 'Crash reporting toggle',
                            semanticHint: userPreferences.crashReportingEnabled
                                ? 'Crash reporting is enabled, tap to disable'
                                : 'Crash reporting is disabled, tap to enable',
                            child: SwitchListTile(
                              secondary: const Icon(Icons.bug_report),
                              title: const AccessibleText('Crash Reporting'),
                              subtitle: const AccessibleText(
                                  'Send crash reports to help fix issues'),
                              value: userPreferences.crashReportingEnabled,
                              onChanged: !isUserLoading
                                  ? (value) async {
                                      final newPrefs = userPreferences.copyWith(
                                        crashReportingEnabled: value,
                                      );
                                      await userActions
                                          .updatePreferences(newPrefs);
                                    }
                                  : null,
                            ),
                          ),
                          const Divider(),
                          AccessibleTapTarget(
                            onTap: () => context.go(RouteNames.profile),
                            semanticLabel: 'Profile',
                            semanticHint: userProfile != null
                                ? 'Manage your profile information'
                                : 'Sign in to manage your profile',
                            isButton: true,
                            child: ListTile(
                              leading: const Icon(Icons.account_circle),
                              title: const AccessibleText('Profile'),
                              subtitle: AccessibleText(
                                userProfile != null
                                    ? 'Manage your profile information'
                                    : 'Sign in to manage your profile',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.go(RouteNames.profile),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ResponsiveSpacing(vertical: true),

                // About Section
                Card(
                  child: ResponsiveContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AccessibleText(
                          'About',
                          style: Theme.of(context).textTheme.titleLarge,
                          semanticsLabel: 'About section',
                        ),
                        ResponsiveSpacing(vertical: true),
                        AccessibleTapTarget(
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'Flutter Starter Template',
                              applicationVersion: '1.0.0',
                              applicationIcon: const Icon(Icons.flutter_dash),
                              children: [
                                const AccessibleText(
                                  'A professional Flutter starter template with clean architecture, theming, and navigation.',
                                ),
                              ],
                            );
                          },
                          semanticLabel: 'App version',
                          semanticHint:
                              'Version 1.0.0, tap to show about dialog',
                          isButton: true,
                          child: ListTile(
                            leading: const Icon(Icons.info),
                            title: const AccessibleText('App Version'),
                            subtitle: const AccessibleText('1.0.0'),
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'Flutter Starter Template',
                                applicationVersion: '1.0.0',
                                applicationIcon: const Icon(Icons.flutter_dash),
                                children: [
                                  const AccessibleText(
                                    'A professional Flutter starter template with clean architecture, theming, and navigation.',
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveSpacing(vertical: true, factor: 2.0),

                // Navigation
                AccessibleTapTarget(
                  onTap: () => context.go(RouteNames.home),
                  semanticLabel: 'Go to Home',
                  semanticHint: 'Navigate back to home page',
                  isButton: true,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(RouteNames.home),
                    icon: const Icon(Icons.home),
                    label: const AccessibleText('Go to Home'),
                  ),
                ),
                ResponsiveSpacing(vertical: true, factor: 2.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(
      BuildContext context, ThemeModeNotifier notifier, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AccessibleText('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AccessibleTapTarget(
              onTap: () {
                notifier.setLightTheme();
                Navigator.of(context).pop();
              },
              semanticLabel: 'Light theme',
              semanticHint: 'Switch to light theme',
              isButton: true,
              child: RadioListTile<ThemeMode>(
                title: const AccessibleText('Light'),
                value: ThemeMode.light,
                groupValue: currentMode,
                onChanged: (value) {
                  notifier.setLightTheme();
                  Navigator.of(context).pop();
                },
              ),
            ),
            AccessibleTapTarget(
              onTap: () {
                notifier.setDarkTheme();
                Navigator.of(context).pop();
              },
              semanticLabel: 'Dark theme',
              semanticHint: 'Switch to dark theme',
              isButton: true,
              child: RadioListTile<ThemeMode>(
                title: const AccessibleText('Dark'),
                value: ThemeMode.dark,
                groupValue: currentMode,
                onChanged: (value) {
                  notifier.setDarkTheme();
                  Navigator.of(context).pop();
                },
              ),
            ),
            AccessibleTapTarget(
              onTap: () {
                notifier.setSystemTheme();
                Navigator.of(context).pop();
              },
              semanticLabel: 'System theme',
              semanticHint: 'Use system theme setting',
              isButton: true,
              child: RadioListTile<ThemeMode>(
                title: const AccessibleText('System'),
                value: ThemeMode.system,
                groupValue: currentMode,
                onChanged: (value) {
                  notifier.setSystemTheme();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        actions: [
          AccessibleTapTarget(
            onTap: () => Navigator.of(context).pop(),
            semanticLabel: 'Cancel',
            semanticHint: 'Close dialog without changing theme',
            isButton: true,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const AccessibleText('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleActions localeActions,
      SupportedLocale currentLocale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AccessibleText('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: SupportedLocale.values.length,
            itemBuilder: (context, index) {
              final locale = SupportedLocale.values[index];
              return AccessibleTapTarget(
                onTap: () async {
                  await localeActions.changeLocale(locale);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                semanticLabel: locale.displayName,
                semanticHint: locale == currentLocale
                    ? 'Currently selected language'
                    : 'Switch to ${locale.displayName}',
                isButton: true,
                child: RadioListTile<SupportedLocale>(
                  title: AccessibleText(locale.displayName),
                  value: locale,
                  groupValue: currentLocale,
                  onChanged: (value) async {
                    if (value != null) {
                      await localeActions.changeLocale(value);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          AccessibleTapTarget(
            onTap: () => Navigator.of(context).pop(),
            semanticLabel: 'Cancel',
            semanticHint: 'Close dialog without changing language',
            isButton: true,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const AccessibleText('Cancel'),
            ),
          ),
          AccessibleTapTarget(
            onTap: () async {
              await localeActions.resetToDeviceLocale();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            semanticLabel: 'Reset to device language',
            semanticHint: 'Use device default language setting',
            isButton: true,
            child: TextButton(
              onPressed: () async {
                await localeActions.resetToDeviceLocale();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const AccessibleText('Reset'),
            ),
          ),
        ],
      ),
    );
  }
}
