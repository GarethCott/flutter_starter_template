import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/demo_data.dart';
import '../../../../core/models/stat_item.dart';
import '../../../../shared/shared.dart';

/// Statistics overview widget for the dashboard
class StatsOverview extends ConsumerWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveGrid(
      spacing: 16,
      runSpacing: 16,
      minItemWidth: 200,
      children: DemoData.dashboardStats.map((stat) {
        return _StatCard(stat: stat);
      }).toList(),
    );
  }
}

class _StatCard extends StatefulWidget {
  final StatItem stat;

  const _StatCard({required this.stat});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.stat.progress ?? 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibleTapTarget(
      semanticLabel: '${widget.stat.title}: ${widget.stat.value}',
      semanticHint: widget.stat.subtitle != null
          ? '${widget.stat.subtitle}. ${widget.stat.change != null ? 'Change: ${widget.stat.change}' : ''}'
          : widget.stat.change != null
              ? 'Change: ${widget.stat.change}'
              : null,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Card(
            elevation: _isHovered ? 8 : 2,
            shadowColor: widget.stat.color?.withOpacity(0.3),
            child: ResponsiveContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and trend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (widget.stat.color ?? colorScheme.primary)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.stat.icon,
                          size: 24,
                          color: widget.stat.color ?? colorScheme.primary,
                        ),
                      ),

                      // Trend indicator
                      if (widget.stat.change != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.stat
                                .getTrendColor(context)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.stat.trendIcon,
                                size: 16,
                                color: widget.stat.getTrendColor(context),
                              ),
                              const SizedBox(width: 4),
                              AccessibleText(
                                widget.stat.change!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: widget.stat.getTrendColor(context),
                                  fontWeight: FontWeight.w600,
                                ),
                                semanticsLabel: 'Change: ${widget.stat.change}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  ResponsiveSpacing(vertical: true),

                  // Value
                  AccessibleText(
                    widget.stat.value,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    semanticsLabel: 'Value: ${widget.stat.value}',
                  ),

                  ResponsiveSpacing(vertical: true, factor: 0.5),

                  // Title and subtitle
                  AccessibleText(
                    widget.stat.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    semanticsLabel: widget.stat.title,
                  ),

                  if (widget.stat.subtitle != null) ...[
                    ResponsiveSpacing(vertical: true, factor: 0.25),
                    AccessibleText(
                      widget.stat.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      semanticsLabel: widget.stat.subtitle,
                    ),
                  ],

                  // Progress indicator
                  if (widget.stat.progress != null) ...[
                    ResponsiveSpacing(vertical: true),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AccessibleText(
                                  'Progress',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                AccessibleText(
                                  '${(_progressAnimation.value * 100).toInt()}%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  semanticsLabel:
                                      'Progress: ${(_progressAnimation.value * 100).toInt()} percent',
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _progressAnimation.value,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.stat.color ?? colorScheme.primary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
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
