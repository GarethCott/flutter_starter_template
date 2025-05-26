import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Skeleton loader component with Material 3 design
///
/// Features:
/// - Multiple preset layouts (text, card, list, profile)
/// - Custom skeleton shapes
/// - Shimmer animation
/// - Size and color customization
/// - Accessibility support
/// - Responsive design
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.preset,
    this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.enabled = true,
    this.semanticLabel,
  }) : assert(
          preset != null || child != null,
          'Either preset or child must be provided',
        );

  /// Preset skeleton layout
  final SkeletonPreset? preset;

  /// Custom skeleton child
  final Widget? child;

  /// Custom width
  final double? width;

  /// Custom height
  final double? height;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Base color for skeleton
  final Color? baseColor;

  /// Highlight color for shimmer
  final Color? highlightColor;

  /// Animation duration
  final Duration animationDuration;

  /// Enable/disable animation
  final bool enabled;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SkeletonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseColor = widget.baseColor ?? colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? colorScheme.surface;

    Widget skeleton;

    if (widget.preset != null) {
      skeleton = _buildPresetSkeleton(widget.preset!, theme);
    } else {
      skeleton = widget.child!;
    }

    if (!widget.enabled) {
      return skeleton;
    }

    Widget shimmerSkeleton = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: skeleton,
        );
      },
    );

    // Wrap with semantics if provided
    if (widget.semanticLabel != null) {
      shimmerSkeleton = Semantics(
        label: widget.semanticLabel,
        child: shimmerSkeleton,
      );
    }

    return shimmerSkeleton;
  }

  Widget _buildPresetSkeleton(SkeletonPreset preset, ThemeData theme) {
    switch (preset) {
      case SkeletonPreset.text:
        return _buildTextSkeleton();
      case SkeletonPreset.paragraph:
        return _buildParagraphSkeleton();
      case SkeletonPreset.card:
        return _buildCardSkeleton();
      case SkeletonPreset.listItem:
        return _buildListItemSkeleton();
      case SkeletonPreset.profile:
        return _buildProfileSkeleton();
      case SkeletonPreset.image:
        return _buildImageSkeleton();
      case SkeletonPreset.button:
        return _buildButtonSkeleton();
    }
  }

  Widget _buildTextSkeleton() {
    return _SkeletonBox(
      width: widget.width ?? 120,
      height: widget.height ?? 16,
      borderRadius: widget.borderRadius ?? UIConstants.borderRadiusXs,
    );
  }

  Widget _buildParagraphSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonBox(
          width: double.infinity,
          height: 16,
          borderRadius: UIConstants.borderRadiusXs,
        ),
        const SizedBox(height: UIConstants.spacingXs),
        _SkeletonBox(
          width: double.infinity,
          height: 16,
          borderRadius: UIConstants.borderRadiusXs,
        ),
        const SizedBox(height: UIConstants.spacingXs),
        _SkeletonBox(
          width: 200,
          height: 16,
          borderRadius: UIConstants.borderRadiusXs,
        ),
      ],
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      width: widget.width ?? double.infinity,
      padding: UIConstants.paddingMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: widget.borderRadius ?? UIConstants.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _SkeletonBox(
                width: UIConstants.iconSizeMd,
                height: UIConstants.iconSizeMd,
                borderRadius: UIConstants.borderRadiusSm,
              ),
              const SizedBox(width: UIConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(
                      width: double.infinity,
                      height: 16,
                      borderRadius: UIConstants.borderRadiusXs,
                    ),
                    const SizedBox(height: UIConstants.spacingXs),
                    _SkeletonBox(
                      width: 100,
                      height: 14,
                      borderRadius: UIConstants.borderRadiusXs,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.spacingMd),

          // Content
          _SkeletonBox(
            width: double.infinity,
            height: 14,
            borderRadius: UIConstants.borderRadiusXs,
          ),
          const SizedBox(height: UIConstants.spacingXs),
          _SkeletonBox(
            width: double.infinity,
            height: 14,
            borderRadius: UIConstants.borderRadiusXs,
          ),
          const SizedBox(height: UIConstants.spacingXs),
          _SkeletonBox(
            width: 150,
            height: 14,
            borderRadius: UIConstants.borderRadiusXs,
          ),
        ],
      ),
    );
  }

  Widget _buildListItemSkeleton() {
    return Container(
      width: widget.width ?? double.infinity,
      padding: UIConstants.paddingMd,
      child: Row(
        children: [
          // Leading
          _SkeletonBox(
            width: UIConstants.iconSizeLg,
            height: UIConstants.iconSizeLg,
            borderRadius: BorderRadius.circular(UIConstants.iconSizeLg / 2),
          ),
          const SizedBox(width: UIConstants.spacingMd),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(
                  width: double.infinity,
                  height: 16,
                  borderRadius: UIConstants.borderRadiusXs,
                ),
                const SizedBox(height: UIConstants.spacingXs),
                _SkeletonBox(
                  width: 120,
                  height: 14,
                  borderRadius: UIConstants.borderRadiusXs,
                ),
              ],
            ),
          ),

          // Trailing
          _SkeletonBox(
            width: UIConstants.iconSizeMd,
            height: UIConstants.iconSizeMd,
            borderRadius: UIConstants.borderRadiusXs,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSkeleton() {
    return Container(
      width: widget.width ?? double.infinity,
      padding: UIConstants.paddingMd,
      child: Column(
        children: [
          // Avatar
          _SkeletonBox(
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(40),
          ),
          const SizedBox(height: UIConstants.spacingMd),

          // Name
          _SkeletonBox(
            width: 150,
            height: 20,
            borderRadius: UIConstants.borderRadiusXs,
          ),
          const SizedBox(height: UIConstants.spacingSm),

          // Bio
          _SkeletonBox(
            width: 200,
            height: 16,
            borderRadius: UIConstants.borderRadiusXs,
          ),
          const SizedBox(height: UIConstants.spacingXs),
          _SkeletonBox(
            width: 180,
            height: 16,
            borderRadius: UIConstants.borderRadiusXs,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSkeleton() {
    return _SkeletonBox(
      width: widget.width ?? 200,
      height: widget.height ?? 150,
      borderRadius: widget.borderRadius ?? UIConstants.borderRadiusMd,
    );
  }

  Widget _buildButtonSkeleton() {
    return _SkeletonBox(
      width: widget.width ?? 120,
      height: widget.height ?? 40,
      borderRadius: widget.borderRadius ?? UIConstants.borderRadiusMd,
    );
  }
}

/// Individual skeleton box component
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? UIConstants.borderRadiusXs,
      ),
    );
  }
}

/// Custom skeleton shape component
class SkeletonShape extends StatelessWidget {
  const SkeletonShape({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  /// Child widget to apply skeleton effect to
  final Widget child;

  /// Base color for skeleton
  final Color? baseColor;

  /// Highlight color for shimmer
  final Color? highlightColor;

  /// Animation duration
  final Duration animationDuration;

  /// Enable/disable animation
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      baseColor: baseColor,
      highlightColor: highlightColor,
      animationDuration: animationDuration,
      enabled: enabled,
      child: child,
    );
  }
}

/// Skeleton preset layouts
enum SkeletonPreset {
  /// Single line of text
  text,

  /// Multiple lines of text
  paragraph,

  /// Card layout with header and content
  card,

  /// List item with avatar and text
  listItem,

  /// Profile layout with avatar and bio
  profile,

  /// Image placeholder
  image,

  /// Button placeholder
  button,
}
