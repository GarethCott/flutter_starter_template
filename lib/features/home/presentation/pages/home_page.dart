import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/demo_data.dart';
import '../../../../shared/shared.dart';
import '../widgets/activity_feed.dart';
import '../widgets/feature_showcase.dart';
import '../widgets/navigation_cards.dart';
import '../widgets/stats_overview.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Column(
        children: [
          const NetworkStatusBanner(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Custom App Bar with user info
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primaryContainer.withValues(alpha: 0.3),
                            colorScheme.secondaryContainer
                                .withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (user != null) ...[
                                Row(
                                  children: [
                                    // User avatar
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: colorScheme.primary,
                                      backgroundImage:
                                          user.profilePictureUrl != null
                                              ? NetworkImage(
                                                  user.profilePictureUrl!)
                                              : null,
                                      child: user.profilePictureUrl == null
                                          ? AccessibleText(
                                              user.displayName
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: theme.textTheme.titleLarge
                                                  ?.copyWith(
                                                color: colorScheme.onPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              semanticsLabel:
                                                  'User avatar: ${user.displayName}',
                                            )
                                          : null,
                                    ),

                                    const SizedBox(width: 16),

                                    // Welcome message
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AccessibleText(
                                            _getGreeting(),
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                            semanticsLabel: _getGreeting(),
                                          ),
                                          AccessibleText(
                                            user.displayName,
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onSurface,
                                            ),
                                            semanticsLabel:
                                                'Welcome ${user.displayName}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                AccessibleText(
                                  'Welcome to Flutter Starter',
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                  semanticsLabel: 'Welcome to Flutter Starter',
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    const CompactNetworkStatusIndicator(),
                    const SizedBox(width: 8),
                  ],
                ),

                // Main content
                SliverToBoxAdapter(
                  child: ResponsiveConstraints(
                    centerContent: true,
                    child: ResponsiveContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveSpacing(vertical: true),

                          // Quick Actions Section
                          _buildSection(
                            context,
                            title: 'Quick Actions',
                            subtitle: 'Navigate to key features',
                            child: const NavigationCards(),
                          ),

                          ResponsiveSpacing(vertical: true, factor: 2),

                          // Statistics Overview Section
                          _buildSection(
                            context,
                            title: 'Dashboard Overview',
                            subtitle: 'Key metrics and performance indicators',
                            child: const StatsOverview(),
                          ),

                          ResponsiveSpacing(vertical: true, factor: 2),

                          // Recent Activity and Feature Showcase
                          ResponsiveLayout(
                            spacing: 24,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Recent Activity (takes 2/3 on larger screens)
                              Flexible(
                                flex: 2,
                                child: const ActivityFeed(),
                              ),

                              // User Stats Card (takes 1/3 on larger screens)
                              Flexible(
                                flex: 1,
                                child: _buildUserStatsCard(context, user),
                              ),
                            ],
                          ),

                          ResponsiveSpacing(vertical: true, factor: 2),

                          // Feature Showcase Section
                          const FeatureShowcase(),

                          ResponsiveSpacing(vertical: true, factor: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccessibleText(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          semanticsLabel: '$title section',
        ),
        if (subtitle != null) ...[
          ResponsiveSpacing(vertical: true, factor: 0.5),
          AccessibleText(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            semanticsLabel: subtitle,
          ),
        ],
        ResponsiveSpacing(vertical: true),
        child,
      ],
    );
  }

  Widget _buildUserStatsCard(BuildContext context, user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userData = DemoData.sampleUserData;

    return Card(
      child: ResponsiveContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                AccessibleText(
                  'Your Progress',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: 'Your Progress section',
                ),
              ],
            ),

            ResponsiveSpacing(vertical: true),

            // Progress stats
            _buildStatRow(
              context,
              'Total Logins',
              '${userData['totalLogins']}',
              Icons.login,
            ),
            _buildStatRow(
              context,
              'Tasks Completed',
              '${userData['completedTasks']}/${userData['totalTasks']}',
              Icons.task_alt,
            ),
            _buildStatRow(
              context,
              'Current Streak',
              '${userData['streakDays']} days',
              Icons.local_fire_department,
            ),
            _buildStatRow(
              context,
              'Badges Earned',
              '${userData['badgesEarned']}',
              Icons.emoji_events,
            ),

            ResponsiveSpacing(vertical: true),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AccessibleText(
                      'Completion',
                      style: theme.textTheme.labelMedium,
                    ),
                    AccessibleText(
                      '${((userData['completedTasks'] / userData['totalTasks']) * 100).toInt()}%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: userData['completedTasks'] / userData['totalTasks'],
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AccessibleText(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              semanticsLabel: label,
            ),
          ),
          AccessibleText(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            semanticsLabel: '$label: $value',
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}
