import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Text button component with Material 3 design
///
/// Features:
/// - Multiple variants (standard, destructive, link)
/// - Loading states with spinner
/// - Icon support (leading/trailing)
/// - Size variants (small, medium, large)
/// - Disabled state handling
/// - Accessibility support
/// - Custom styling options
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.variant = TextButtonVariant.standard,
    this.size = TextButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.trailingIcon,
    this.color,
    this.backgroundColor,
    this.padding,
    this.textStyle,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.semanticLabel,
    this.underline = false,
  });

  /// Button press callback
  final VoidCallback? onPressed;

  /// Button text
  final String text;

  /// Button variant
  final TextButtonVariant variant;

  /// Button size
  final TextButtonSize size;

  /// Loading state
  final bool isLoading;

  /// Enabled state
  final bool isEnabled;

  /// Leading icon
  final IconData? leadingIcon;

  /// Trailing icon
  final IconData? trailingIcon;

  /// Custom text color
  final Color? color;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom text style
  final TextStyle? textStyle;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Focus node
  final FocusNode? focusNode;

  /// Auto focus
  final bool autofocus;

  /// Tooltip text
  final String? tooltip;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Show underline (for link variant)
  final bool underline;

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

    // Build text style with underline if needed
    final finalTextStyle = effectiveTextStyle.copyWith(
      color: color ?? colorConfig.textColor,
      decoration: (variant == TextButtonVariant.link && underline)
          ? TextDecoration.underline
          : TextDecoration.none,
    );

    Widget button = TextButton(
      onPressed: effectiveOnPressed,
      focusNode: focusNode,
      autofocus: autofocus,
      style: TextButton.styleFrom(
        foregroundColor: color ?? colorConfig.textColor,
        backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
        ),
        padding: effectivePadding,
        textStyle: finalTextStyle,
        elevation: 0,
      ),
      child: _buildButtonContent(iconSize, finalTextStyle),
    );

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

  Widget _buildButtonContent(double iconSize, TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Colors.grey,
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
          color: textStyle.color,
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
          color: textStyle.color,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  _TextButtonSizeConfig _getSizeConfig(TextButtonSize size) {
    switch (size) {
      case TextButtonSize.small:
        return _TextButtonSizeConfig(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingSm,
            vertical: UIConstants.spacingXs,
          ),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          iconSize: 16,
        );
      case TextButtonSize.medium:
        return _TextButtonSizeConfig(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingMd,
            vertical: UIConstants.spacingSm,
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          iconSize: 18,
        );
      case TextButtonSize.large:
        return _TextButtonSizeConfig(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingLg,
            vertical: UIConstants.spacingMd,
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          iconSize: 20,
        );
    }
  }

  _TextButtonColorConfig _getColorConfig(
    TextButtonVariant variant,
    ColorScheme colorScheme,
    bool isDisabled,
  ) {
    if (isDisabled) {
      return _TextButtonColorConfig(
        textColor: colorScheme.onSurface.withOpacity(0.38),
        backgroundColor: Colors.transparent,
      );
    }

    switch (variant) {
      case TextButtonVariant.standard:
        return _TextButtonColorConfig(
          textColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
        );
      case TextButtonVariant.destructive:
        return _TextButtonColorConfig(
          textColor: colorScheme.error,
          backgroundColor: Colors.transparent,
        );
      case TextButtonVariant.link:
        return _TextButtonColorConfig(
          textColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
        );
    }
  }
}

/// Text button variants
enum TextButtonVariant {
  /// Standard text button
  standard,

  /// Destructive action text button
  destructive,

  /// Link-style text button
  link,
}

/// Text button size variants
enum TextButtonSize {
  small,
  medium,
  large,
}

/// Internal size configuration
class _TextButtonSizeConfig {
  const _TextButtonSizeConfig({
    required this.padding,
    required this.textStyle,
    required this.iconSize,
  });

  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final double iconSize;
}

/// Internal color configuration
class _TextButtonColorConfig {
  const _TextButtonColorConfig({
    required this.textColor,
    required this.backgroundColor,
  });

  final Color textColor;
  final Color backgroundColor;
}
