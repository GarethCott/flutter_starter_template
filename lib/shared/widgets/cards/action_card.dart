import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Interactive action card component with Material 3 design
///
/// Features:
/// - Multiple variants (elevated, filled, outlined)
/// - Primary and secondary actions
/// - Icon and image support
/// - Hover and focus states
/// - Loading states
/// - Accessibility support
/// - Custom styling options
class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.image,
    this.primaryAction,
    this.secondaryAction,
    this.onTap,
    this.onLongPress,
    this.variant = ActionCardVariant.elevated,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.isLoading = false,
    this.isEnabled = true,
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

  /// Primary action button
  final Widget? primaryAction;

  /// Secondary action button
  final Widget? secondaryAction;

  /// Tap callback
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Card variant
  final ActionCardVariant variant;

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

  /// Enabled state
  final bool isEnabled;

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
    final colorConfig = _getColorConfig(variant, colorScheme, isEnabled);

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
        button: onTap != null,
        enabled: isEnabled,
        child: card,
      );
    }

    return card;
  }

  Widget _buildCard(
    BuildContext context,
    Widget content,
    _ActionCardColorConfig colorConfig,
    EdgeInsetsGeometry padding,
    BorderRadius borderRadius,
  ) {
    switch (variant) {
      case ActionCardVariant.elevated:
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

      case ActionCardVariant.filled:
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

      case ActionCardVariant.outlined:
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
    if (onTap != null || onLongPress != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          onLongPress: isEnabled ? onLongPress : null,
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
      if (description != null || _hasActions()) {
        children.add(const SizedBox(height: UIConstants.spacingMd));
      }
    }

    // Add description
    if (description != null) {
      children.add(_buildDescription(theme));
      if (_hasActions()) {
        children.add(const SizedBox(height: UIConstants.spacingLg));
      }
    }

    // Add actions
    if (_hasActions()) {
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
        Container(
          padding: const EdgeInsets.all(UIConstants.spacingSm),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: UIConstants.borderRadiusSm,
          ),
          child: Icon(
            icon,
            size: UIConstants.iconSizeMd,
            color: theme.colorScheme.onPrimaryContainer,
          ),
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
            style: theme.textTheme.titleLarge?.copyWith(
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
      style: theme.textTheme.bodyMedium?.copyWith(
        height: 1.5,
      ),
    );
  }

  Widget _buildActions() {
    final actions = <Widget>[];

    if (secondaryAction != null) {
      actions.add(secondaryAction!);
    }

    if (primaryAction != null) {
      if (actions.isNotEmpty) {
        actions.add(const SizedBox(width: UIConstants.spacingSm));
      }
      actions.add(primaryAction!);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
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
              width: UIConstants.iconSizeLg,
              height: UIConstants.iconSizeLg,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: UIConstants.borderRadiusSm,
              ),
            ),
            const SizedBox(width: UIConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: UIConstants.borderRadiusXs,
                    ),
                  ),
                  const SizedBox(height: UIConstants.spacingXs),
                  Container(
                    width: 150,
                    height: 16,
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
              width: index == 2 ? 250 : double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: UIConstants.borderRadiusXs,
              ),
            ),
          ),
        ),
        const SizedBox(height: UIConstants.spacingLg),
        // Loading actions
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 80,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: UIConstants.borderRadiusSm,
              ),
            ),
            const SizedBox(width: UIConstants.spacingSm),
            Container(
              width: 100,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: UIConstants.borderRadiusSm,
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _hasActions() {
    return primaryAction != null || secondaryAction != null;
  }

  _ActionCardColorConfig _getColorConfig(
    ActionCardVariant variant,
    ColorScheme colorScheme,
    bool isEnabled,
  ) {
    if (!isEnabled) {
      return _ActionCardColorConfig(
        backgroundColor: colorScheme.surface.withOpacity(0.38),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        borderColor: colorScheme.outline.withOpacity(0.12),
      );
    }

    switch (variant) {
      case ActionCardVariant.elevated:
        return _ActionCardColorConfig(
          backgroundColor: colorScheme.surface,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderColor: Colors.transparent,
        );
      case ActionCardVariant.filled:
        return _ActionCardColorConfig(
          backgroundColor: colorScheme.surfaceContainerHighest,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderColor: Colors.transparent,
        );
      case ActionCardVariant.outlined:
        return _ActionCardColorConfig(
          backgroundColor: colorScheme.surface,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          borderColor: colorScheme.outline,
        );
    }
  }
}

/// Action card variants
enum ActionCardVariant {
  /// Elevated card with shadow
  elevated,

  /// Filled card with background color
  filled,

  /// Outlined card with border
  outlined,
}

/// Internal color configuration
class _ActionCardColorConfig {
  const _ActionCardColorConfig({
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
