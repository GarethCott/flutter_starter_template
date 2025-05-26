import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Information display card component with Material 3 design
///
/// Features:
/// - Multiple variants (elevated, filled, outlined)
/// - Icon and image support
/// - Action buttons
/// - Customizable layout
/// - Accessibility support
/// - Loading states
/// - Custom styling options
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.image,
    this.actions,
    this.onTap,
    this.variant = InfoCardVariant.elevated,
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
    this.child,
  });

  /// Card title
  final String? title;

  /// Card subtitle
  final String? subtitle;

  /// Card description
  final String? description;

  /// Leading icon
  final IconData? icon;

  /// Header image
  final Widget? image;

  /// Action buttons
  final List<Widget>? actions;

  /// Tap callback
  final VoidCallback? onTap;

  /// Card variant
  final InfoCardVariant variant;

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

  /// Custom child widget (overrides default content)
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Color configuration based on variant
    final colorConfig = _getColorConfig(variant, colorScheme);

    final effectivePadding = padding ?? UIConstants.paddingMd;
    final effectiveBorderRadius = borderRadius ?? UIConstants.borderRadiusMd;

    Widget cardContent = child ?? _buildDefaultContent(theme);

    if (isLoading) {
      cardContent = _buildLoadingContent();
    }

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
        child: card,
      );
    }

    return card;
  }

  Widget _buildCard(
    BuildContext context,
    Widget content,
    _InfoCardColorConfig colorConfig,
    EdgeInsetsGeometry padding,
    BorderRadius borderRadius,
  ) {
    switch (variant) {
      case InfoCardVariant.elevated:
        return Card(
          elevation: elevation ?? UIConstants.elevationMedium,
          color: backgroundColor ?? colorConfig.backgroundColor,
          shadowColor: shadowColor ?? colorConfig.shadowColor,
          surfaceTintColor: surfaceTintColor ?? colorConfig.surfaceTintColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          clipBehavior: clipBehavior,
          child: _buildCardContent(content, padding),
        );

      case InfoCardVariant.filled:
        return Card(
          elevation: elevation ?? UIConstants.elevationLow,
          color: backgroundColor ?? colorConfig.backgroundColor,
          shadowColor: shadowColor ?? colorConfig.shadowColor,
          surfaceTintColor: surfaceTintColor ?? colorConfig.surfaceTintColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          clipBehavior: clipBehavior,
          child: _buildCardContent(content, padding),
        );

      case InfoCardVariant.outlined:
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
          child: _buildCardContent(content, padding),
        );
    }
  }

  Widget _buildCardContent(Widget content, EdgeInsetsGeometry padding) {
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
        child: Padding(
          padding: padding,
          child: content,
        ),
      );
    }

    return Padding(
      padding: padding,
      child: content,
    );
  }

  Widget _buildDefaultContent(ThemeData theme) {
    final children = <Widget>[];

    // Add image if provided
    if (image != null) {
      children.add(
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              (borderRadius ?? UIConstants.borderRadiusMd).topLeft.x,
            ),
          ),
          child: image!,
        ),
      );
      children.add(const SizedBox(height: UIConstants.spacingMd));
    }

    // Add header (icon + title + subtitle)
    if (icon != null || title != null || subtitle != null) {
      children.add(_buildHeader(theme));
      if (description != null || actions != null) {
        children.add(const SizedBox(height: UIConstants.spacingMd));
      }
    }

    // Add description
    if (description != null) {
      children.add(_buildDescription(theme));
      if (actions != null) {
        children.add(const SizedBox(height: UIConstants.spacingMd));
      }
    }

    // Add actions
    if (actions != null && actions!.isNotEmpty) {
      children.add(_buildActions());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final children = <Widget>[];

    // Add icon
    if (icon != null) {
      children.add(
        Icon(
          icon,
          size: UIConstants.iconSizeMd,
          color: theme.colorScheme.primary,
        ),
      );
      if (title != null || subtitle != null) {
        children.add(const SizedBox(width: UIConstants.spacingMd));
      }
    }

    // Add title and subtitle
    if (title != null || subtitle != null) {
      final textChildren = <Widget>[];

      if (title != null) {
        textChildren.add(
          Text(
            title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }

      if (subtitle != null) {
        if (title != null) {
          textChildren.add(const SizedBox(height: UIConstants.spacingXs));
        }
        textChildren.add(
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }

      children.add(
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: textChildren,
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      description!,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions!
          .map((action) => Padding(
                padding: const EdgeInsets.only(left: UIConstants.spacingSm),
                child: action,
              ))
          .toList(),
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
                borderRadius: UIConstants.borderRadiusXs,
              ),
            ),
            const SizedBox(width: UIConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: UIConstants.borderRadiusXs,
                    ),
                  ),
                  const SizedBox(height: UIConstants.spacingXs),
                  Container(
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: UIConstants.borderRadiusXs,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: UIConstants.spacingMd),
        // Loading description
        ...List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index < 2 ? UIConstants.spacingXs : 0,
            ),
            child: Container(
              width: index == 2 ? 200 : double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: UIConstants.borderRadiusXs,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _InfoCardColorConfig _getColorConfig(
    InfoCardVariant variant,
    ColorScheme colorScheme,
  ) {
    switch (variant) {
      case InfoCardVariant.elevated:
        return _InfoCardColorConfig(
          backgroundColor: colorScheme.surface,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderColor: Colors.transparent,
        );
      case InfoCardVariant.filled:
        return _InfoCardColorConfig(
          backgroundColor: colorScheme.surfaceContainerHighest,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderColor: Colors.transparent,
        );
      case InfoCardVariant.outlined:
        return _InfoCardColorConfig(
          backgroundColor: colorScheme.surface,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          borderColor: colorScheme.outline,
        );
    }
  }
}

/// Info card variants
enum InfoCardVariant {
  /// Elevated card with shadow
  elevated,

  /// Filled card with background color
  filled,

  /// Outlined card with border
  outlined,
}

/// Internal color configuration
class _InfoCardColorConfig {
  const _InfoCardColorConfig({
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
