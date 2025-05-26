import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Favorites page with demo content
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Favorites',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your saved items and preferences',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Empty State Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_outline,
                            size: 64,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Favorites Yet',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start exploring and save your favorite items here. They\'ll appear in this section for quick access.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Explore feature coming soon!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.explore),
                            label: const Text('Start Exploring'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Demo Favorites Section
                  Text(
                    'Demo Favorites',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDemoFavoriteCard(
                    context,
                    icon: Icons.article,
                    title: 'Flutter Best Practices',
                    subtitle: 'Development Guide',
                    description:
                        'A comprehensive guide to Flutter development best practices and patterns.',
                  ),
                  const SizedBox(height: 12),

                  _buildDemoFavoriteCard(
                    context,
                    icon: Icons.video_library,
                    title: 'UI/UX Design Principles',
                    subtitle: 'Design Tutorial',
                    description:
                        'Learn the fundamental principles of user interface and experience design.',
                  ),
                  const SizedBox(height: 12),

                  _buildDemoFavoriteCard(
                    context,
                    icon: Icons.code,
                    title: 'Clean Architecture',
                    subtitle: 'Code Structure',
                    description:
                        'Understanding clean architecture patterns in mobile development.',
                  ),
                  const SizedBox(height: 12),

                  _buildDemoFavoriteCard(
                    context,
                    icon: Icons.palette,
                    title: 'Material Design 3',
                    subtitle: 'Design System',
                    description:
                        'Exploring the latest Material Design 3 components and theming.',
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          icon: Icons.bookmark_add,
                          title: 'Add Bookmark',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Bookmark feature coming soon!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          icon: Icons.share,
                          title: 'Share List',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Share feature coming soon!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoFavoriteCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondaryContainer,
          child: Icon(
            icon,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: colorScheme.onSurfaceVariant,
          ),
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$value - Coming Soon!'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'Share',
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'Remove',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Remove'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $title - Coming Soon!'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
