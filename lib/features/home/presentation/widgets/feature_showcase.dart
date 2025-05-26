import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/demo_data.dart';
import '../../../../shared/shared.dart';

/// Feature showcase widget highlighting template capabilities
class FeatureShowcase extends ConsumerWidget {
  const FeatureShowcase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: ResponsiveContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                AccessibleText(
                  'Template Features',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: 'Template Features section',
                ),
              ],
            ),

            ResponsiveSpacing(vertical: true, factor: 0.5),

            AccessibleText(
              'Discover what makes this starter template powerful and production-ready',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              semanticsLabel: 'Template features description',
            ),

            ResponsiveSpacing(vertical: true, factor: 1.5),

            // Features grid
            ResponsiveGrid(
              spacing: 16,
              runSpacing: 16,
              minItemWidth: 280,
              children: DemoData.featuresShowcase.map((feature) {
                return _FeatureCard(feature: feature);
              }).toList(),
            ),

            ResponsiveSpacing(vertical: true, factor: 1.5),

            // Call to action
            Center(
              child: AccessibleTapTarget(
                onTap: () => _showFeatureDetails(context),
                semanticLabel: 'Learn more about features',
                semanticHint:
                    'Shows detailed information about all template features',
                isButton: true,
                child: ElevatedButton.icon(
                  onPressed: () => _showFeatureDetails(context),
                  icon: const Icon(Icons.info_outline),
                  label: const AccessibleText('Learn More'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _FeatureDetailsDialog(),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final FeatureItem feature;

  const _FeatureCard({required this.feature});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
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
            semanticLabel:
                '${widget.feature.title}: ${widget.feature.description}',
            child: MouseRegion(
              onEnter: (_) => _onHover(true),
              onExit: (_) => _onHover(false),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
                      : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovered
                        ? widget.feature.color.withOpacity(0.3)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.feature.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.feature.icon,
                        size: 24,
                        color: widget.feature.color,
                      ),
                    ),

                    ResponsiveSpacing(vertical: true),

                    // Title
                    AccessibleText(
                      widget.feature.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      semanticsLabel: widget.feature.title,
                    ),

                    ResponsiveSpacing(vertical: true, factor: 0.5),

                    // Description
                    AccessibleText(
                      widget.feature.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      semanticsLabel: widget.feature.description,
                    ),
                  ],
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

class _FeatureDetailsDialog extends StatelessWidget {
  const _FeatureDetailsDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.star,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const AccessibleText(
            'Template Features',
            semanticsLabel: 'Template Features dialog',
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccessibleText(
              'This Flutter starter template includes:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: DemoData.featuresShowcase.map((feature) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            feature.icon,
                            size: 20,
                            color: feature.color,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AccessibleText(
                                  feature.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  semanticsLabel: feature.title,
                                ),
                                const SizedBox(height: 2),
                                AccessibleText(
                                  feature.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  semanticsLabel: feature.description,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        AccessibleTapTarget(
          onTap: () => Navigator.of(context).pop(),
          semanticLabel: 'Close dialog',
          semanticHint: 'Closes the features dialog',
          isButton: true,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const AccessibleText('Got it'),
          ),
        ),
      ],
    );
  }
}
