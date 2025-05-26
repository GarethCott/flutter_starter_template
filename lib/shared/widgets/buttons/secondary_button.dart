import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Secondary button component with Material 3 design
///
/// Features:
/// - Multiple variants (outlined, filled tonal, text)
/// - Loading states with spinner
/// - Icon support (leading/trailing)
/// - Size variants (small, medium, large)
/// - Disabled state handling
/// - Accessibility support
/// - Custom styling options
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.variant = SecondaryButtonVariant.outlined,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.elevation,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.semanticLabel,
  });

  /// Button press callback
  final VoidCallback? onPressed;

  /// Button text
  final String text;

  /// Button variant
  final SecondaryButtonVariant variant;

  /// Button size
  final ButtonSize size;

  /// Loading state
  final bool isLoading;

  /// Enabled state
  final bool isEnabled;

  /// Leading icon
  final IconData? leadingIcon;

  /// Trailing icon
  final IconData? trailingIcon;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom foreground color
  final Color? foregroundColor;

  /// Custom border color
  final Color? borderColor;

  /// Custom border width
  final double? borderWidth;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom text style
  final TextStyle? textStyle;

  /// Custom elevation
  final double? elevation;

  /// Focus node
  final FocusNode? focusNode;

  /// Auto focus
  final bool autofocus;

  /// Tooltip text
  final String? tooltip;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDisabled = !isEnabled || isLoading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    // Size configuration
    final sizeConfig = _getSizeConfig(size);
    final effectivePadding = padding ?? sizeConfig.padding;
    final effectiveTextStyle = textStyle ?? sizeConfig.textStyle;
    final iconSize = sizeConfig.iconSize;

    // Color configuration based on variant
    final colorConfig = _getColorConfig(
      variant,
      colorScheme,
      isDisabled,
    );

    Widget button;

    switch (variant) {
      case SecondaryButtonVariant.outlined:
        button = _buildOutlinedButton(
          context,
          effectiveOnPressed,
          colorConfig,
          effectivePadding,
          effectiveTextStyle,
          iconSize,
        );
        break;
      case SecondaryButtonVariant.filledTonal:
        button = _buildFilledTonalButton(
          context,
          effectiveOnPressed,
          colorConfig,
          effectivePadding,
          effectiveTextStyle,
          iconSize,
        );
        break;
      case SecondaryButtonVariant.text:
        button = _buildTextButton(
          context,
          effectiveOnPressed,
          colorConfig,
          effectivePadding,
          effectiveTextStyle,
          iconSize,
        );
        break;
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

  Widget _buildOutlinedButton(
    BuildContext context,
    VoidCallback? onPressed,
    _ColorConfig colorConfig,
    EdgeInsetsGeometry padding,
    TextStyle textStyle,
    double iconSize,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      focusNode: focusNode,
      autofocus: autofocus,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? colorConfig.foregroundColor,
        backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
        side: BorderSide(
          color: borderColor ?? colorConfig.borderColor,
          width: borderWidth ?? 1.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
        ),
        padding: padding,
        textStyle: textStyle,
        elevation: elevation ?? 0,
      ),
      child: _buildButtonContent(iconSize, textStyle),
    );
  }

  Widget _buildFilledTonalButton(
    BuildContext context,
    VoidCallback? onPressed,
    _ColorConfig colorConfig,
    EdgeInsetsGeometry padding,
    TextStyle textStyle,
    double iconSize,
  ) {
    return FilledButton.tonal(
      onPressed: onPressed,
      focusNode: focusNode,
      autofocus: autofocus,
      style: FilledButton.styleFrom(
        foregroundColor: foregroundColor ?? colorConfig.foregroundColor,
        backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
        ),
        padding: padding,
        textStyle: textStyle,
        elevation: elevation ?? 1,
      ),
      child: _buildButtonContent(iconSize, textStyle),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    VoidCallback? onPressed,
    _ColorConfig colorConfig,
    EdgeInsetsGeometry padding,
    TextStyle textStyle,
    double iconSize,
  ) {
    return TextButton(
      onPressed: onPressed,
      focusNode: focusNode,
      autofocus: autofocus,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? colorConfig.foregroundColor,
        backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
        ),
        padding: padding,
        textStyle: textStyle,
        elevation: elevation ?? 0,
      ),
      child: _buildButtonContent(iconSize, textStyle),
    );
  }

  Widget _buildButtonContent(double iconSize, TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? Colors.grey,
          ),
        ),
      );
    }

    final children = <Widget>[];

    // Leading icon
    if (leadingIcon != null) {
      children.add(
        Icon(
          leadingIcon,
          size: iconSize,
        ),
      );
      children.add(const SizedBox(width: UIConstants.spacingXs));
    }

    // Text
    children.add(
      Text(
        text,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );

    // Trailing icon
    if (trailingIcon != null) {
      children.add(const SizedBox(width: UIConstants.spacingXs));
      children.add(
        Icon(
          trailingIcon,
          size: iconSize,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  _ButtonSizeConfig _getSizeConfig(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return _ButtonSizeConfig(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingSm,
            vertical: UIConstants.spacingXs,
          ),
          textStyle: const TextStyle(fontSize: 12),
          iconSize: 16,
        );
      case ButtonSize.medium:
        return _ButtonSizeConfig(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingMd,
            vertical: UIConstants.spacingSm,
          ),
          textStyle: const TextStyle(fontSize: 14),
          iconSize: 18,
        );
      case ButtonSize.large:
        return _ButtonSizeConfig(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingLg,
            vertical: UIConstants.spacingMd,
          ),
          textStyle: const TextStyle(fontSize: 16),
          iconSize: 20,
        );
    }
  }

  _ColorConfig _getColorConfig(
    SecondaryButtonVariant variant,
    ColorScheme colorScheme,
    bool isDisabled,
  ) {
    if (isDisabled) {
      return _ColorConfig(
        foregroundColor: colorScheme.onSurface.withOpacity(0.38),
        backgroundColor: Colors.transparent,
        borderColor: colorScheme.outline.withOpacity(0.12),
      );
    }

    switch (variant) {
      case SecondaryButtonVariant.outlined:
        return _ColorConfig(
          foregroundColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
          borderColor: colorScheme.outline,
        );
      case SecondaryButtonVariant.filledTonal:
        return _ColorConfig(
          foregroundColor: colorScheme.onSecondaryContainer,
          backgroundColor: colorScheme.secondaryContainer,
          borderColor: Colors.transparent,
        );
      case SecondaryButtonVariant.text:
        return _ColorConfig(
          foregroundColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
        );
    }
  }
}

/// Secondary button variants
enum SecondaryButtonVariant {
  /// Outlined button with border
  outlined,

  /// Filled tonal button with background
  filledTonal,

  /// Text-only button
  text,
}

/// Button size variants
enum ButtonSize {
  small,
  medium,
  large,
}

/// Internal size configuration
class _ButtonSizeConfig {
  const _ButtonSizeConfig({
    required this.padding,
    required this.textStyle,
    required this.iconSize,
  });

  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final double iconSize;
}

/// Internal color configuration
class _ColorConfig {
  const _ColorConfig({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
}
