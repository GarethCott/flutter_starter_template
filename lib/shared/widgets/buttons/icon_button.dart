import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Icon button component with Material 3 design
///
/// Features:
/// - Multiple variants (standard, filled, outlined, tonal)
/// - Loading states with spinner
/// - Size variants (small, medium, large)
/// - Disabled state handling
/// - Accessibility support
/// - Custom styling options
/// - Badge support
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.variant = IconButtonVariant.standard,
    this.size = IconButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.semanticLabel,
    this.badge,
    this.badgeColor,
    this.elevation,
  });

  /// Button press callback
  final VoidCallback? onPressed;

  /// Icon to display
  final IconData icon;

  /// Button variant
  final IconButtonVariant variant;

  /// Button size
  final IconButtonSize size;

  /// Loading state
  final bool isLoading;

  /// Enabled state
  final bool isEnabled;

  /// Custom icon color
  final Color? color;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom border color
  final Color? borderColor;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Focus node
  final FocusNode? focusNode;

  /// Auto focus
  final bool autofocus;

  /// Tooltip text
  final String? tooltip;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Badge text or count
  final String? badge;

  /// Badge color
  final Color? badgeColor;

  /// Custom elevation
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDisabled = !isEnabled || isLoading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    // Size configuration
    final sizeConfig = _getSizeConfig(size);
    final effectivePadding = padding ?? sizeConfig.padding;
    final iconSize = sizeConfig.iconSize;

    // Color configuration based on variant
    final colorConfig = _getColorConfig(
      variant,
      colorScheme,
      isDisabled,
    );

    Widget button = _buildButton(
      context,
      effectiveOnPressed,
      colorConfig,
      effectivePadding,
      iconSize,
    );

    // Add badge if provided
    if (badge != null) {
      button = _buildWithBadge(button, colorScheme);
    }

    // Wrap with tooltip if provided
    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      button = Semantics(
        label: semanticLabel,
        button: true,
        enabled: !isDisabled,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton(
    BuildContext context,
    VoidCallback? onPressed,
    _IconButtonColorConfig colorConfig,
    EdgeInsetsGeometry padding,
    double iconSize,
  ) {
    final buttonChild = _buildButtonContent(iconSize, colorConfig.iconColor);

    switch (variant) {
      case IconButtonVariant.standard:
        return IconButton(
          onPressed: onPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          icon: buttonChild,
          iconSize: iconSize,
          color: color ?? colorConfig.iconColor,
          padding: padding,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
            ),
          ),
        );

      case IconButtonVariant.filled:
        return IconButton.filled(
          onPressed: onPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          icon: buttonChild,
          iconSize: iconSize,
          color: color ?? colorConfig.iconColor,
          padding: padding,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
            foregroundColor: color ?? colorConfig.iconColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
            ),
            elevation: elevation ?? 2,
          ),
        );

      case IconButtonVariant.outlined:
        return IconButton.outlined(
          onPressed: onPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          icon: buttonChild,
          iconSize: iconSize,
          color: color ?? colorConfig.iconColor,
          padding: padding,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
            foregroundColor: color ?? colorConfig.iconColor,
            side: BorderSide(
              color: borderColor ?? colorConfig.borderColor,
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
            ),
          ),
        );

      case IconButtonVariant.tonal:
        return IconButton.filledTonal(
          onPressed: onPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          icon: buttonChild,
          iconSize: iconSize,
          color: color ?? colorConfig.iconColor,
          padding: padding,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
            foregroundColor: color ?? colorConfig.iconColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
            ),
            elevation: elevation ?? 1,
          ),
        );
    }
  }

  Widget _buildButtonContent(double iconSize, Color iconColor) {
    if (isLoading) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? iconColor,
          ),
        ),
      );
    }

    return Icon(
      icon,
      size: iconSize,
      color: color ?? iconColor,
    );
  }

  Widget _buildWithBadge(Widget button, ColorScheme colorScheme) {
    return Badge(
      label: Text(
        badge!,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: badgeColor ?? colorScheme.error,
      textColor: colorScheme.onError,
      child: button,
    );
  }

  _IconButtonSizeConfig _getSizeConfig(IconButtonSize size) {
    switch (size) {
      case IconButtonSize.small:
        return _IconButtonSizeConfig(
          iconSize: UIConstants.iconSizeXs,
          padding: const EdgeInsets.all(UIConstants.spacingXs),
        );
      case IconButtonSize.medium:
        return _IconButtonSizeConfig(
          iconSize: UIConstants.iconSizeMd,
          padding: const EdgeInsets.all(UIConstants.spacingSm),
        );
      case IconButtonSize.large:
        return _IconButtonSizeConfig(
          iconSize: UIConstants.iconSizeLg,
          padding: const EdgeInsets.all(UIConstants.spacingMd),
        );
    }
  }

  _IconButtonColorConfig _getColorConfig(
    IconButtonVariant variant,
    ColorScheme colorScheme,
    bool isDisabled,
  ) {
    if (isDisabled) {
      return _IconButtonColorConfig(
        iconColor: colorScheme.onSurface.withOpacity(0.38),
        backgroundColor: Colors.transparent,
        borderColor: colorScheme.outline.withOpacity(0.12),
      );
    }

    switch (variant) {
      case IconButtonVariant.standard:
        return _IconButtonColorConfig(
          iconColor: colorScheme.onSurfaceVariant,
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
        );
      case IconButtonVariant.filled:
        return _IconButtonColorConfig(
          iconColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          borderColor: Colors.transparent,
        );
      case IconButtonVariant.outlined:
        return _IconButtonColorConfig(
          iconColor: colorScheme.onSurfaceVariant,
          backgroundColor: Colors.transparent,
          borderColor: colorScheme.outline,
        );
      case IconButtonVariant.tonal:
        return _IconButtonColorConfig(
          iconColor: colorScheme.onSecondaryContainer,
          backgroundColor: colorScheme.secondaryContainer,
          borderColor: Colors.transparent,
        );
    }
  }
}

/// Icon button variants
enum IconButtonVariant {
  /// Standard icon button
  standard,

  /// Filled icon button with background
  filled,

  /// Outlined icon button with border
  outlined,

  /// Tonal icon button with subtle background
  tonal,
}

/// Icon button size variants
enum IconButtonSize {
  small,
  medium,
  large,
}

/// Internal size configuration
class _IconButtonSizeConfig {
  const _IconButtonSizeConfig({
    required this.iconSize,
    required this.padding,
  });

  final double iconSize;
  final EdgeInsetsGeometry padding;
}

/// Internal color configuration
class _IconButtonColorConfig {
  const _IconButtonColorConfig({
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
}
