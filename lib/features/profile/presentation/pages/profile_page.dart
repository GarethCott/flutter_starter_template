import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/user_provider.dart';
import '../../../../shared/widgets/connectivity/network_status_indicator.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_completion_card.dart';
import '../widgets/profile_edit_dialog.dart';
import '../widgets/profile_info_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userProfile = ref.watch(userProfileProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final userActions = ref.read(userActionsProvider);

    // If not authenticated, show sign-in prompt
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: const [
            CompactNetworkStatusIndicator(),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Sign In Required',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Please sign in to view and manage your profile.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.go(RouteNames.login),
                  icon: const Icon(Icons.login),
                  label: const Text('Sign In'),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => context.go(RouteNames.home),
                  icon: const Icon(Icons.home),
                  label: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: userProfile != null
                ? () =>
                    _showEditProfileDialog(context, userProfile, userActions)
                : null,
            tooltip: 'Edit Profile',
          ),
          const CompactNetworkStatusIndicator(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh user data
          // In a real app, this would fetch fresh data from the server
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: userState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : userState.hasError
                ? _buildErrorState(
                    context, userState.errorMessage!, userActions)
                : userProfile == null
                    ? _buildNoProfileState(context)
                    : _buildProfileContent(context, userProfile, userActions),
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, String error, UserActions userActions) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => userActions.clearError(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoProfileState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Profile Data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Your profile information is not available. Please try signing in again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(RouteNames.login),
              icon: const Icon(Icons.login),
              label: const Text('Sign In Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, UserProfile profile, UserActions userActions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header with Avatar and Basic Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfileAvatar(
                    profile: profile,
                    size: 80,
                    onTap: () => _showAvatarOptions(context, userActions),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.displayName,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      profile.bio!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatusChip(
                        context,
                        profile.user.isEmailVerified
                            ? 'Verified'
                            : 'Unverified',
                        profile.user.isEmailVerified
                            ? Icons.verified
                            : Icons.warning,
                        profile.user.isEmailVerified
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                      _buildStatusChip(
                        context,
                        'Member since ${_formatDate(profile.user.createdAt)}',
                        Icons.calendar_today,
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Profile Completion Card
          ProfileCompletionCard(profile: profile),
          const SizedBox(height: 16),

          // Profile Information Card
          ProfileInfoCard(
            profile: profile,
            onEdit: () => _showEditProfileDialog(context, profile, userActions),
          ),
          const SizedBox(height: 16),

          // Account Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    subtitle: const Text('Manage your preferences'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go(RouteNames.settings),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Privacy & Security'),
                    subtitle: const Text('Manage your privacy settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Privacy settings coming soon!'),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    subtitle: const Text('Sign out of your account'),
                    onTap: () => _showSignOutDialog(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Navigation
          ElevatedButton.icon(
            onPressed: () => context.go(RouteNames.home),
            icon: const Icon(Icons.home),
            label: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context, String label, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  void _showEditProfileDialog(
      BuildContext context, UserProfile profile, UserActions userActions) {
    showDialog(
      context: context,
      builder: (context) => ProfileEditDialog(
        profile: profile,
        userActions: userActions,
      ),
    );
  }

  void _showAvatarOptions(BuildContext context, UserActions userActions) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Camera functionality coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gallery functionality coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove Photo'),
              onTap: () async {
                Navigator.pop(context);
                await userActions.updateProfile(avatarUrl: null);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile photo removed'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.login);
              // TODO: Implement actual sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sign out functionality coming soon!'),
                ),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
