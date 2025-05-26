import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// List item card component with Material 3 design
///
/// Features:
/// - Multiple variants (elevated, filled, outlined)
/// - Leading and trailing widgets
/// - Avatar and icon support
/// - Subtitle and metadata
/// - Interactive states
/// - Accessibility support
/// - Custom styling options
class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.metadata,
    this.leading,
    this.trailing,
    this.avatar,
    this.icon,
    this.onTap,
    this.onLongPress,
    this.variant = ListCardVariant.elevated,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.isEnabled = true,
    this.isSelected = false,
    this.semanticLabel,
    this.clipBehavior = Clip.none,
    this.dense = false,
  });

  /// Card title (required)
  final String title;

  /// Card subtitle
  final String? subtitle;

  /// Metadata text (e.g., timestamp, status)
  final String? metadata;

  /// Leading widget (overrides avatar and icon)
  final Widget? leading;

  /// Trailing widget
  final Widget? trailing;

  /// Avatar widget
  final Widget? avatar;

  /// Leading icon
  final IconData? icon;

  /// Tap callback
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Card variant
  final ListCardVariant variant;

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

  /// Enabled state
  final bool isEnabled;

  /// Selected state
  final bool isSelected;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Clip behavior
  final Clip clipBehavior;

  /// Dense layout
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Color configuration based on variant and state
    final colorConfig =
        _getColorConfig(variant, colorScheme, isEnabled, isSelected);

    final effectivePadding =
        padding ?? (dense ? UIConstants.paddingSm : UIConstants.paddingMd);
    final effectiveBorderRadius = borderRadius ?? UIConstants.borderRadiusMd;

    Widget cardContent = _buildContent(theme);

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
        selected: isSelected,
        child: card,
      );
    }

    return card;
  }

  Widget _buildCard(
    BuildContext context,
    Widget content,
    _ListCardColorConfig colorConfig,
    EdgeInsetsGeometry padding,
    BorderRadius borderRadius,
  ) {
    switch (variant) {
      case ListCardVariant.elevated:
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

      case ListCardVariant.filled:
        return Card(
          elevation: elevation ?? UIConstants.elevationNone,
          color: backgroundColor ?? colorConfig.backgroundColor,
          shadowColor: shadowColor ?? colorConfig.shadowColor,
          surfaceTintColor: surfaceTintColor ?? colorConfig.surfaceTintColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          clipBehavior: clipBehavior,
          child: _buildCardContent(content, padding, borderRadius),
        );

      case ListCardVariant.outlined:
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

  Widget _buildContent(ThemeData theme) {
    final children = <Widget>[];

    // Leading widget
    final leadingWidget = _buildLeading(theme);
    if (leadingWidget != null) {
      children.add(leadingWidget);
      children.add(SizedBox(
          width: dense ? UIConstants.spacingSm : UIConstants.spacingMd));
    }

    // Content (title, subtitle, metadata)
    children.add(
      Expanded(
        child: _buildTextContent(theme),
      ),
    );

    // Trailing widget
    if (trailing != null) {
      children.add(SizedBox(
          width: dense ? UIConstants.spacingSm : UIConstants.spacingMd));
      children.add(trailing!);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget? _buildLeading(ThemeData theme) {
    if (leading != null) {
      return leading;
    }

    if (avatar != null) {
      return avatar;
    }

    if (icon != null) {
      return Container(
        width: dense ? UIConstants.iconSizeMd : UIConstants.iconSizeLg,
        height: dense ? UIConstants.iconSizeMd : UIConstants.iconSizeLg,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(
            dense ? UIConstants.radiusSm : UIConstants.radiusMd,
          ),
        ),
        child: Icon(
          icon,
          size: dense ? UIConstants.iconSizeSm : UIConstants.iconSizeMd,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      );
    }

    return null;
  }

  Widget _buildTextContent(ThemeData theme) {
    final children = <Widget>[];

    // Title and metadata row
    final titleRow = <Widget>[];
    titleRow.add(
      Expanded(
        child: Text(
          title,
          style:
              (dense ? theme.textTheme.bodyMedium : theme.textTheme.titleMedium)
                  ?.copyWith(
            fontWeight: FontWeight.w600,
            color: isEnabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withOpacity(0.38),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    if (metadata != null) {
      titleRow.add(
        Text(
          metadata!,
          style:
              (dense ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
                  ?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    children.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: titleRow,
      ),
    );

    // Subtitle
    if (subtitle != null) {
      children.add(SizedBox(
          height: dense ? UIConstants.spacingXs : UIConstants.spacingXs));
      children.add(
        Text(
          subtitle!,
          style:
              (dense ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
                  ?.copyWith(
            color: isEnabled
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onSurfaceVariant.withOpacity(0.38),
          ),
          maxLines: dense ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  _ListCardColorConfig _getColorConfig(
    ListCardVariant variant,
    ColorScheme colorScheme,
    bool isEnabled,
    bool isSelected,
  ) {
    if (!isEnabled) {
      return _ListCardColorConfig(
        backgroundColor: colorScheme.surface.withOpacity(0.38),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        borderColor: colorScheme.outline.withOpacity(0.12),
      );
    }

    if (isSelected) {
      switch (variant) {
        case ListCardVariant.elevated:
          return _ListCardColorConfig(
            backgroundColor: colorScheme.secondaryContainer,
            shadowColor: colorScheme.shadow,
            surfaceTintColor: colorScheme.surfaceTint,
            borderColor: Colors.transparent,
          );
        case ListCardVariant.filled:
          return _ListCardColorConfig(
            backgroundColor: colorScheme.secondaryContainer,
            shadowColor: colorScheme.shadow,
            surfaceTintColor: colorScheme.surfaceTint,
            borderColor: Colors.transparent,
          );
        case ListCardVariant.outlined:
          return _ListCardColorConfig(
            backgroundColor: colorScheme.secondaryContainer,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            borderColor: colorScheme.secondary,
          );
      }
    }

    switch (variant) {
      case ListCardVariant.elevated:
        return _ListCardColorConfig(
          backgroundColor: colorScheme.surface,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderColor: Colors.transparent,
        );
      case ListCardVariant.filled:
        return _ListCardColorConfig(
          backgroundColor: colorScheme.surfaceContainerHighest,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: colorScheme.surfaceTint,
          borderColor: Colors.transparent,
        );
      case ListCardVariant.outlined:
        return _ListCardColorConfig(
          backgroundColor: colorScheme.surface,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          borderColor: colorScheme.outline,
        );
    }
  }
}

/// List card variants
enum ListCardVariant {
  /// Elevated card with shadow
  elevated,

  /// Filled card with background color
  filled,

  /// Outlined card with border
  outlined,
}

/// Internal color configuration
class _ListCardColorConfig {
  const _ListCardColorConfig({
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
