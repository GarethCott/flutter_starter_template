import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Statistics display card component with Material 3 design
///
/// Features:
/// - Multiple variants (elevated, filled, outlined)
/// - Value and trend display
/// - Icon and color indicators
/// - Progress indicators
/// - Comparison values
/// - Loading states
/// - Accessibility support
/// - Custom styling options
class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.previousValue,
    this.trend,
    this.trendDirection,
    this.progress,
    this.icon,
    this.color,
    this.onTap,
    this.variant = StatsCardVariant.elevated,
    this.layout = StatsCardLayout.vertical,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.isLoading = false,
    this.semanticLabel,
    this.clipBehavior = Clip.none,
  });

  /// Card title
  final String title;

  /// Main value to display
  final String value;

  /// Card subtitle
  final String? subtitle;

  /// Previous value for comparison
  final String? previousValue;

  /// Trend percentage (e.g., "+12.5%")
  final String? trend;

  /// Trend direction
  final TrendDirection? trendDirection;

  /// Progress value (0.0 to 1.0)
  final double? progress;

  /// Leading icon
  final IconData? icon;

  /// Accent color
  final Color? color;

  /// Tap callback
  final VoidCallback? onTap;

  /// Card variant
  final StatsCardVariant variant;

  /// Card layout
  final StatsCardLayout layout;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom margin
  final EdgeInsetsGeometry? margin;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom border color
  final Color? borderColor;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Custom elevation
  final double? elevation;

  /// Custom shadow color
  final Color? shadowColor;

  /// Custom surface tint color
  final Color? surfaceTintColor;

  /// Loading state
  final bool isLoading;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Clip behavior
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Color configuration based on variant
    final colorConfig = _getColorConfig(variant, colorScheme);

    final effectivePadding = padding ?? UIConstants.paddingMd;
    final effectiveBorderRadius = borderRadius ?? UIConstants.borderRadiusMd;

    Widget cardContent =
        isLoading ? _buildLoadingContent() : _buildContent(theme);

    Widget card = _buildCard(
      context,
      cardContent,
      colorConfig,
      effectivePadding,
      effectiveBorderRadius,
    );

    // Add margin if provided
    if (margin != null) {
      card = Padding(
        padding: margin!,
        child: card,
      );
    }

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      card = Semantics(
        label: semanticLabel,
        button: onTap != null,
        child: card,
      );
    }

    return card;
  }

  Widget _buildCard(
    BuildContext context,
    Widget content,
    _StatsCardColorConfig colorConfig,
    EdgeInsetsGeometry padding,
    BorderRadius borderRadius,
  ) {
    switch (variant) {
      case StatsCardVariant.elevated:
        return Card(
          elevation: elevation ?? UIConstants.elevationMedium,
          color: backgroundColor ?? colorConfig.backgroundColor,
          shadowColor: shadowColor ?? colorConfig.shadowColor,
          surfaceTintColor: surfaceTintColor ?? colorConfig.surfaceTintColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          clipBehavior: clipBehavior,
          child: _buildCardContent(content, padding, borderRadius),
        );

      case StatsCardVariant.filled:
        return Card(
          elevation: elevation ?? UIConstants.elevationLow,
          color: backgroundColor ?? colorConfig.backgroundColor,
          shadowColor: shadowColor ?? colorConfig.shadowColor,
          surfaceTintColor: surfaceTintColor ?? colorConfig.surfaceTintColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          clipBehavior: clipBehavior,
          child: _buildCardContent(content, padding, borderRadius),
        );

      case StatsCardVariant.outlined:
        return Card(
          elevation: elevation ?? UIConstants.elevationNone,
          color: backgroundColor ?? colorConfig.backgroundColor,
          shadowColor: shadowColor ?? colorConfig.shadowColor,
          surfaceTintColor: surfaceTintColor ?? colorConfig.surfaceTintColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(
              color: borderColor ?? colorConfig.borderColor,
              width: 1.0,
            ),
          ),
          clipBehavior: clipBehavior,
          child: _buildCardContent(content, padding, borderRadius),
        );
    }
  }

  Widget _buildCardContent(
    Widget content,
    EdgeInsetsGeometry padding,
    BorderRadius borderRadius,
  ) {
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: padding,
            child: content,
          ),
        ),
      );
    }

    return Padding(
      padding: padding,
      child: content,
    );
  }

  Widget _buildContent(ThemeData theme) {
    switch (layout) {
      case StatsCardLayout.vertical:
        return _buildVerticalLayout(theme);
      case StatsCardLayout.horizontal:
        return _buildHorizontalLayout(theme);
      case StatsCardLayout.compact:
        return _buildCompactLayout(theme);
    }
  }

  Widget _buildVerticalLayout(ThemeData theme) {
    final children = <Widget>[];

    // Header (icon + title)
    children.add(_buildHeader(theme));
    children.add(const SizedBox(height: UIConstants.spacingMd));

    // Value
    children.add(_buildValue(theme));

    // Trend and subtitle
    if (trend != null || subtitle != null) {
      children.add(const SizedBox(height: UIConstants.spacingSm));
      children.add(_buildTrendAndSubtitle(theme));
    }

    // Progress indicator
    if (progress != null) {
      children.add(const SizedBox(height: UIConstants.spacingMd));
      children.add(_buildProgress(theme));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildHorizontalLayout(ThemeData theme) {
    return Row(
      children: [
        // Icon
        if (icon != null) ...[
          _buildIcon(theme),
          const SizedBox(width: UIConstants.spacingMd),
        ],

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: UIConstants.spacingXs),

              // Value and trend
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color ?? theme.colorScheme.onSurface,
                    ),
                  ),
                  if (trend != null) ...[
                    const SizedBox(width: UIConstants.spacingSm),
                    _buildTrendIndicator(theme),
                  ],
                ],
              ),

              // Subtitle
              if (subtitle != null) ...[
                const SizedBox(height: UIConstants.spacingXs),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout(ThemeData theme) {
    return Row(
      children: [
        // Icon
        if (icon != null) ...[
          _buildIcon(theme, size: UIConstants.iconSizeSm),
          const SizedBox(width: UIConstants.spacingSm),
        ],

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color ?? theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Trend
        if (trend != null) _buildTrendIndicator(theme),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        if (icon != null) ...[
          _buildIcon(theme),
          const SizedBox(width: UIConstants.spacingSm),
        ],
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(ThemeData theme, {double? size}) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spacingSm),
      decoration: BoxDecoration(
        color: (color ?? theme.colorScheme.primary).withOpacity(0.1),
        borderRadius: UIConstants.borderRadiusSm,
      ),
      child: Icon(
        icon,
        size: size ?? UIConstants.iconSizeMd,
        color: color ?? theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildValue(ThemeData theme) {
    return Text(
      value,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: color ?? theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTrendAndSubtitle(ThemeData theme) {
    final children = <Widget>[];

    if (trend != null) {
      children.add(_buildTrendIndicator(theme));
    }

    if (subtitle != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(width: UIConstants.spacingSm));
      }
      children.add(
        Expanded(
          child: Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Row(
      children: children,
    );
  }

  Widget _buildTrendIndicator(ThemeData theme) {
    final trendColor = _getTrendColor(theme.colorScheme);
    final trendIcon = _getTrendIcon();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingSm,
        vertical: UIConstants.spacingXs,
      ),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: UIConstants.borderRadiusXs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trendIcon != null) ...[
            Icon(
              trendIcon,
              size: UIConstants.iconSizeXs,
              color: trendColor,
            ),
            const SizedBox(width: UIConstants.spacingXs),
          ],
          Text(
            trend!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${(progress! * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: UIConstants.spacingXs),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Loading header
        Row(
          children: [
            Container(
              width: UIConstants.iconSizeMd,
              height: UIConstants.iconSizeMd,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: UIConstants.borderRadiusSm,
              ),
            ),
            const SizedBox(width: UIConstants.spacingSm),
            Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: UIConstants.borderRadiusXs,
              ),
            ),
          ],
        ),
        const SizedBox(height: UIConstants.spacingMd),

        // Loading value
        Container(
          width: 120,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: UIConstants.borderRadiusXs,
          ),
        ),
        const SizedBox(height: UIConstants.spacingSm),

        // Loading trend
        Container(
          width: 60,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: UIConstants.borderRadiusXs,
          ),
        ),
      ],
    );
  }

  Color _getTrendColor(ColorScheme colorScheme) {
    switch (trendDirection) {
      case TrendDirection.up:
        return colorScheme.primary;
      case TrendDirection.down:
        return colorScheme.error;
      case TrendDirection.neutral:
      case null:
        return colorScheme.onSurfaceVariant;
    }
  }

  IconData? _getTrendIcon() {
    switch (trendDirection) {
      case TrendDirection.up:
        return Icons.trending_up;
      case TrendDirection.down:
        return Icons.trending_down;
      case TrendDirection.neutral:
        return Icons.trending_flat;
      case null:
        return null;
    }
  }

  _StatsCardColorConfig _getColorConfig(
    StatsCardVariant variant,
    ColorScheme colorScheme,
  ) {
    switch (variant) {
      case StatsCardVariant.elevated:
        return _StatsCardColorConfig(
          backgroundColor: colorScheme.surface,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderColor: Colors.transparent,
        );
      case StatsCardVariant.filled:
        return _StatsCardColorConfig(
          backgroundColor: colorScheme.surfaceContainerHighest,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderColor: Colors.transparent,
        );
      case StatsCardVariant.outlined:
        return _StatsCardColorConfig(
          backgroundColor: colorScheme.surface,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          borderColor: colorScheme.outline,
        );
    }
  }
}

/// Stats card variants
enum StatsCardVariant {
  /// Elevated card with shadow
  elevated,

  /// Filled card with background color
  filled,

  /// Outlined card with border
  outlined,
}

/// Stats card layout options
enum StatsCardLayout {
  /// Vertical layout with stacked elements
  vertical,

  /// Horizontal layout with side-by-side elements
  horizontal,

  /// Compact layout for dense displays
  compact,
}

/// Trend direction indicators
enum TrendDirection {
  /// Upward trend (positive)
  up,

  /// Downward trend (negative)
  down,

  /// Neutral trend (no change)
  neutral,
}

/// Internal color configuration
class _StatsCardColorConfig {
  const _StatsCardColorConfig({
    required this.backgroundColor,
    required this.shadowColor,
    required this.surfaceTintColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color shadowColor;
  final Color surfaceTintColor;
  final Color borderColor;
}
