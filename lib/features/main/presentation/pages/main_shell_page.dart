import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/user_provider.dart';
import '../../../../shared/widgets/navigation/bottom_nav_bar.dart';
import '../../../../shared/widgets/navigation/custom_app_bar.dart';

/// Main shell page that provides tab-based navigation
class MainShellPage extends ConsumerStatefulWidget {
  /// The child widget to display in the shell
  final Widget child;

  /// The current location path
  final String location;

  const MainShellPage({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // Tab configuration
  static const List<MainTab> _tabs = [
    MainTab(
      index: 0,
      path: '/',
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    MainTab(
      index: 1,
      path: '/explore',
      label: 'Explore',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
    ),
    MainTab(
      index: 2,
      path: '/favorites',
      label: 'Favorites',
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
    ),
    MainTab(
      index: 3,
      path: '/profile',
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _updateCurrentIndex();
  }

  @override
  void didUpdateWidget(MainShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _updateCurrentIndex();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateCurrentIndex() {
    final newIndex = _getIndexFromLocation(widget.location);
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
        _tabController.index = newIndex;
      });
    }
  }

  int _getIndexFromLocation(String location) {
    for (final tab in _tabs) {
      if (location == tab.path || location.startsWith('${tab.path}/')) {
        return tab.index;
      }
    }
    return 0; // Default to home
  }

  String _getPageTitle() {
    if (_currentIndex < _tabs.length) {
      return _tabs[_currentIndex].label;
    }
    return 'App';
  }

  List<Widget> _getAppBarActions() {
    switch (_currentIndex) {
      case 0: // Home
        return [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications - Coming Soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Notifications',
          ),
        ];
      case 1: // Explore
        return [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Open search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search - Coming Soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Search',
          ),
        ];
      case 2: // Favorites
        return [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Sort favorites
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sort - Coming Soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Sort',
          ),
        ];
      case 3: // Profile
        return [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/settings');
            },
            tooltip: 'Settings',
          ),
        ];
      default:
        return [];
    }
  }

  void _onTabTapped(int index) {
    if (index < _tabs.length) {
      final tab = _tabs[index];
      context.go(tab.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: _getPageTitle(),
        actions: _getAppBarActions(),
        showMenuButton: true,
        onMenuPressed: () {
          _showUserMenu(context);
        },
      ),
      body: widget.child,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _tabs.map((tab) {
          return CustomBottomNavItem(
            icon: tab.icon,
            selectedIcon: tab.selectedIcon,
            label: tab.label,
          );
        }).toList(),
        type: CustomBottomNavType.fixed,
        showLabels: true,
        enableHapticFeedback: true,
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    final userProfile = ref.read(userProfileProvider);
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => UserMenuBottomSheet(
        userProfile: userProfile,
        isAuthenticated: isAuthenticated,
      ),
    );
  }
}

/// Tab configuration data class
class MainTab {
  final int index;
  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const MainTab({
    required this.index,
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

/// User menu bottom sheet widget
class UserMenuBottomSheet extends ConsumerWidget {
  final UserProfile? userProfile;
  final bool isAuthenticated;

  const UserMenuBottomSheet({
    super.key,
    required this.userProfile,
    required this.isAuthenticated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // User info section
          if (isAuthenticated && userProfile != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: userProfile!.avatarUrl != null
                      ? NetworkImage(userProfile!.avatarUrl!)
                      : null,
                  child: userProfile!.avatarUrl == null
                      ? Text(
                          userProfile!.initials,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile!.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userProfile!.user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
          ],

          // Menu items
          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help & Support - Coming Soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('About - Coming Soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          if (isAuthenticated) ...[
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: 'Sign Out',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                _showSignOutDialog(context, ref);
              },
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? colorScheme.error : colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? colorScheme.error : colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(globalAuthActionsProvider).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
