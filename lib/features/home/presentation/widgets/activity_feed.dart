import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/demo_data.dart';
import '../../../../core/models/activity_item.dart';
import '../../../../shared/shared.dart';

/// Activity feed widget for recent activities
class ActivityFeed extends ConsumerWidget {
  const ActivityFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: ResponsiveContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AccessibleText(
                  'Recent Activity',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: 'Recent Activity section',
                ),
                AccessibleTapTarget(
                  onTap: () => _showAllActivities(context),
                  semanticLabel: 'View all activities',
                  semanticHint: 'Shows all activities in a detailed view',
                  isButton: true,
                  child: TextButton(
                    onPressed: () => _showAllActivities(context),
                    child: const AccessibleText('View All'),
                  ),
                ),
              ],
            ),

            ResponsiveSpacing(vertical: true),

            // Activity list
            ...DemoData.recentActivities.take(5).map((activity) {
              return _ActivityItem(activity: activity);
            }),

            // Show more button if there are more activities
            if (DemoData.recentActivities.length > 5) ...[
              ResponsiveSpacing(vertical: true),
              Center(
                child: AccessibleTapTarget(
                  onTap: () => _showAllActivities(context),
                  semanticLabel: 'Show more activities',
                  semanticHint:
                      'Shows remaining ${DemoData.recentActivities.length - 5} activities',
                  isButton: true,
                  child: OutlinedButton.icon(
                    onPressed: () => _showAllActivities(context),
                    icon: const Icon(Icons.expand_more),
                    label: AccessibleText(
                      'Show ${DemoData.recentActivities.length - 5} More',
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAllActivities(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _AllActivitiesSheet(),
    );
  }
}

class _ActivityItem extends StatefulWidget {
  final ActivityItem activity;

  const _ActivityItem({required this.activity});

  @override
  State<_ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<_ActivityItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibleTapTarget(
      semanticLabel: '${widget.activity.title}: ${widget.activity.description}',
      semanticHint: 'Activity from ${widget.activity.timestamp}',
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? colorScheme.outline.withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Activity icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (widget.activity.color ?? colorScheme.primary)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.activity.icon,
                  size: 20,
                  color: widget.activity.color ?? colorScheme.primary,
                ),
              ),

              const SizedBox(width: 12),

              // Activity content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccessibleText(
                      widget.activity.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      semanticsLabel: widget.activity.title,
                    ),
                    const SizedBox(height: 2),
                    AccessibleText(
                      widget.activity.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      semanticsLabel: widget.activity.description,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Timestamp
              AccessibleText(
                widget.activity.timestamp,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                semanticsLabel: 'Time: ${widget.activity.timestamp}',
              ),

              // Unread indicator
              if (!widget.activity.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    if (mounted) {
      setState(() {
        _isHovered = isHovered;
      });
    }
  }
}

class _AllActivitiesSheet extends StatelessWidget {
  const _AllActivitiesSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AccessibleText(
                      'All Activities',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      semanticsLabel: 'All Activities',
                    ),
                    AccessibleTapTarget(
                      onTap: () => Navigator.of(context).pop(),
                      semanticLabel: 'Close',
                      semanticHint: 'Closes the activities sheet',
                      isButton: true,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Activities list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: DemoData.recentActivities.length,
                  itemBuilder: (context, index) {
                    final activity = DemoData.recentActivities[index];
                    return _ActivityItem(activity: activity);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
