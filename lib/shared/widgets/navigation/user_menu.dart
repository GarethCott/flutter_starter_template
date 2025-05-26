import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../routing/route_names.dart';
import '../../providers/theme_provider.dart';

class UserMenu extends ConsumerWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: colorScheme.onSurface,
      ),
      tooltip: 'User Menu',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      offset: const Offset(0, 8),
      itemBuilder: (BuildContext context) => [
        // Profile section
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colorScheme.primary,
                    backgroundImage: authState.user?.profilePictureUrl != null
                        ? NetworkImage(authState.user!.profilePictureUrl!)
                        : null,
                    child: authState.user?.profilePictureUrl == null
                        ? Text(
                            authState.user?.name
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                'U',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authState.user?.name ?? 'User',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          authState.user?.email ?? 'user@example.com',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(
                color: colorScheme.outline.withOpacity(0.3),
                thickness: 1,
              ),
            ],
          ),
        ),

        // Profile menu item
        PopupMenuItem<String>(
          value: 'profile',
          child: _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: 'View and edit profile',
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),

        // Settings menu item
        PopupMenuItem<String>(
          value: 'settings',
          child: _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'App preferences',
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),

        // Theme toggle menu item
        PopupMenuItem<String>(
          value: 'theme',
          child: _buildMenuItem(
            icon: themeMode == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            title: themeMode == ThemeMode.dark ? 'Light Mode' : 'Dark Mode',
            subtitle: 'Toggle theme',
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),

        // Language menu item
        PopupMenuItem<String>(
          value: 'language',
          child: _buildMenuItem(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'Change language',
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),

        // Divider
        const PopupMenuDivider(),

        // Help menu item
        PopupMenuItem<String>(
          value: 'help',
          child: _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get assistance',
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),

        // About menu item
        PopupMenuItem<String>(
          value: 'about',
          child: _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App information',
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),

        // Divider
        const PopupMenuDivider(),

        // Logout menu item
        PopupMenuItem<String>(
          value: 'logout',
          child: _buildMenuItem(
            icon: Icons.logout,
            title: 'Sign Out',
            subtitle: 'Logout from account',
            colorScheme: colorScheme,
            theme: theme,
            isDestructive: true,
          ),
        ),
      ],
      onSelected: (String value) => _handleMenuSelection(context, ref, value),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
    required ThemeData theme,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive ? colorScheme.error : colorScheme.onSurface;
    final titleColor =
        isDestructive ? colorScheme.error : colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'profile':
        context.go(RouteNames.profile);
        break;

      case 'settings':
        context.go(RouteNames.settings);
        break;

      case 'theme':
        _toggleTheme(ref);
        break;

      case 'language':
        _showLanguageDialog(context);
        break;

      case 'help':
        _showHelpDialog(context);
        break;

      case 'about':
        _showAboutDialog(context);
        break;

      case 'logout':
        _showLogoutConfirmation(context, ref);
        break;
    }
  }

  void _toggleTheme(WidgetRef ref) {
    final currentTheme = ref.read(themeModeNotifierProvider);
    final newTheme =
        currentTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    ref.read(themeModeNotifierProvider.notifier).setThemeMode(newTheme);
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language'),
        content: const Text(
            'Language switching will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help? Here are some resources:'),
            SizedBox(height: 16),
            Text('• Documentation: Check the README file'),
            Text('• Issues: Report bugs on GitHub'),
            Text('• Community: Join our Discord server'),
            Text('• Email: support@example.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Flutter Starter',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.flutter_dash,
        size: 48,
      ),
      children: const [
        Text(
            'A complete Flutter starter template with authentication, navigation, and professional UI components.'),
        SizedBox(height: 16),
        Text(
            'Built with clean architecture principles and modern Flutter practices.'),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performLogout(context, ref);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _performLogout(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).signOut(context: context);
  }
}
