import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/demo_data.dart';
import '../../../../shared/shared.dart';

/// Navigation cards widget for quick actions
class NavigationCards extends ConsumerWidget {
  const NavigationCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveGrid(
      spacing: 16,
      runSpacing: 16,
      minItemWidth: 160,
      children: DemoData.quickActions.map((action) {
        return _NavigationCard(
          action: action,
          onTap: () => _handleCardTap(context, action),
        );
      }).toList(),
    );
  }

  void _handleCardTap(BuildContext context, QuickAction action) {
    if (action.isAvailable && action.route != null) {
      context.push(action.route!);
    } else {
      _showComingSoonDialog(context, action);
    }
  }

  void _showComingSoonDialog(BuildContext context, QuickAction action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AccessibleText(
          'Coming Soon',
          semanticsLabel: 'Coming Soon dialog',
        ),
        content: AccessibleText(
          '${action.title} feature is coming soon! Stay tuned for updates.',
          semanticsLabel: '${action.title} feature is coming soon',
        ),
        actions: [
          AccessibleTapTarget(
            onTap: () => Navigator.of(context).pop(),
            semanticLabel: 'Close dialog',
            semanticHint: 'Closes the coming soon dialog',
            isButton: true,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const AccessibleText('Got it'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationCard extends StatefulWidget {
  final QuickAction action;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.action,
    required this.onTap,
  });

  @override
  State<_NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<_NavigationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AccessibleTapTarget(
            onTap: widget.onTap,
            semanticLabel: widget.action.title,
            semanticHint: widget.action.isAvailable
                ? 'Navigate to ${widget.action.title}'
                : '${widget.action.title} - Coming soon',
            isButton: true,
            child: MouseRegion(
              onEnter: (_) => _onHover(true),
              onExit: (_) => _onHover(false),
              child: Card(
                elevation: _isHovered ? 8 : 2,
                shadowColor: widget.action.color.withOpacity(0.3),
                child: InkWell(
                  onTap: widget.onTap,
                  onHover: _onHover,
                  borderRadius: BorderRadius.circular(12),
                  child: ResponsiveContainer(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon with background
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: widget.action.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            widget.action.icon,
                            size: 28,
                            color: widget.action.color,
                          ),
                        ),

                        ResponsiveSpacing(vertical: true),

                        // Title
                        AccessibleText(
                          widget.action.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          semanticsLabel: widget.action.title,
                        ),

                        ResponsiveSpacing(vertical: true, factor: 0.5),

                        // Description
                        AccessibleText(
                          widget.action.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          semanticsLabel: widget.action.description,
                        ),

                        // Coming soon badge
                        if (widget.action.isComingSoon) ...[
                          ResponsiveSpacing(vertical: true, factor: 0.5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: AccessibleText(
                              'Coming Soon',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                              semanticsLabel: 'Coming soon feature',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onHover(bool isHovered) {
    if (mounted) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
}
