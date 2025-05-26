import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Custom snackbar component with Material 3 design
///
/// Features:
/// - Multiple variants (info, success, warning, error)
/// - Action buttons
/// - Custom styling and colors
/// - Icon support
/// - Dismissible behavior
/// - Animation controls
/// - Accessibility support
class CustomSnackbar {
  /// Show an info snackbar
  static void showInfo(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    bool showCloseIcon = false,
    Widget? closeIcon,
    Color? closeIconColor,
    String? semanticLabel,
  }) {
    _showSnackbar(
      context,
      message: message,
      variant: SnackbarVariant.info,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      behavior: behavior,
      margin: margin,
      padding: padding,
      elevation: elevation,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      showCloseIcon: showCloseIcon,
      closeIcon: closeIcon,
      closeIconColor: closeIconColor,
      semanticLabel: semanticLabel,
    );
  }

  /// Show a success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    bool showCloseIcon = false,
    Widget? closeIcon,
    Color? closeIconColor,
    String? semanticLabel,
  }) {
    _showSnackbar(
      context,
      message: message,
      variant: SnackbarVariant.success,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      behavior: behavior,
      margin: margin,
      padding: padding,
      elevation: elevation,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      showCloseIcon: showCloseIcon,
      closeIcon: closeIcon,
      closeIconColor: closeIconColor,
      semanticLabel: semanticLabel,
    );
  }

  /// Show a warning snackbar
  static void showWarning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    bool showCloseIcon = false,
    Widget? closeIcon,
    Color? closeIconColor,
    String? semanticLabel,
  }) {
    _showSnackbar(
      context,
      message: message,
      variant: SnackbarVariant.warning,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      behavior: behavior,
      margin: margin,
      padding: padding,
      elevation: elevation,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      showCloseIcon: showCloseIcon,
      closeIcon: closeIcon,
      closeIconColor: closeIconColor,
      semanticLabel: semanticLabel,
    );
  }

  /// Show an error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    bool showCloseIcon = false,
    Widget? closeIcon,
    Color? closeIconColor,
    String? semanticLabel,
  }) {
    _showSnackbar(
      context,
      message: message,
      variant: SnackbarVariant.error,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      behavior: behavior,
      margin: margin,
      padding: padding,
      elevation: elevation,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      showCloseIcon: showCloseIcon,
      closeIcon: closeIcon,
      closeIconColor: closeIconColor,
      semanticLabel: semanticLabel,
    );
  }

  /// Show a custom snackbar
  static void show(
    BuildContext context, {
    required String message,
    SnackbarVariant variant = SnackbarVariant.info,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    bool showCloseIcon = false,
    Widget? closeIcon,
    Color? closeIconColor,
    String? semanticLabel,
  }) {
    _showSnackbar(
      context,
      message: message,
      variant: variant,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      behavior: behavior,
      margin: margin,
      padding: padding,
      elevation: elevation,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      showCloseIcon: showCloseIcon,
      closeIcon: closeIcon,
      closeIconColor: closeIconColor,
      semanticLabel: semanticLabel,
    );
  }

  static void _showSnackbar(
    BuildContext context, {
    required String message,
    required SnackbarVariant variant,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    bool showCloseIcon = false,
    Widget? closeIcon,
    Color? closeIconColor,
    String? semanticLabel,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get variant configuration
    final variantConfig = _getVariantConfig(variant, colorScheme);

    // Build content
    final content = _SnackbarContent(
      message: message,
      variant: variant,
      variantConfig: variantConfig,
      textColor: textColor,
      textStyle: textStyle,
    );

    // Build action if provided
    SnackBarAction? action;
    if (actionLabel != null) {
      action = SnackBarAction(
        label: actionLabel,
        onPressed: onActionPressed ?? () {},
        textColor: variantConfig.actionColor,
      );
    }

    final snackBar = SnackBar(
      content: content,
      action: action,
      duration: duration,
      behavior: behavior ?? SnackBarBehavior.floating,
      margin: margin ?? UIConstants.paddingMd,
      padding: padding,
      elevation: elevation ?? UIConstants.elevationMedium,
      backgroundColor: backgroundColor ?? variantConfig.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: UIConstants.borderRadiusMd,
      ),
      showCloseIcon: showCloseIcon,
      closeIconColor: closeIconColor ?? variantConfig.iconColor,
    );

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static _SnackbarVariantConfig _getVariantConfig(
    SnackbarVariant variant,
    ColorScheme colorScheme,
  ) {
    switch (variant) {
      case SnackbarVariant.info:
        return _SnackbarVariantConfig(
          backgroundColor: colorScheme.inverseSurface,
          textColor: colorScheme.onInverseSurface,
          iconColor: colorScheme.primary,
          actionColor: colorScheme.primary,
          icon: Icons.info_outline,
        );
      case SnackbarVariant.success:
        return _SnackbarVariantConfig(
          backgroundColor: colorScheme.primaryContainer,
          textColor: colorScheme.onPrimaryContainer,
          iconColor: colorScheme.primary,
          actionColor: colorScheme.primary,
          icon: Icons.check_circle_outline,
        );
      case SnackbarVariant.warning:
        return _SnackbarVariantConfig(
          backgroundColor: colorScheme.tertiaryContainer,
          textColor: colorScheme.onTertiaryContainer,
          iconColor: colorScheme.tertiary,
          actionColor: colorScheme.tertiary,
          icon: Icons.warning_amber_outlined,
        );
      case SnackbarVariant.error:
        return _SnackbarVariantConfig(
          backgroundColor: colorScheme.errorContainer,
          textColor: colorScheme.onErrorContainer,
          iconColor: colorScheme.error,
          actionColor: colorScheme.error,
          icon: Icons.error_outline,
        );
    }
  }
}

/// Snackbar content widget
class _SnackbarContent extends StatelessWidget {
  const _SnackbarContent({
    required this.message,
    required this.variant,
    required this.variantConfig,
    this.textColor,
    this.textStyle,
  });

  final String message;
  final SnackbarVariant variant;
  final _SnackbarVariantConfig variantConfig;
  final Color? textColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Icon
        Icon(
          variantConfig.icon,
          color: variantConfig.iconColor,
          size: UIConstants.iconSizeMd,
        ),
        const SizedBox(width: UIConstants.spacingMd),

        // Message
        Expanded(
          child: Text(
            message,
            style: textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: textColor ?? variantConfig.textColor,
                ),
          ),
        ),
      ],
    );
  }
}

/// Snackbar variants
enum SnackbarVariant {
  /// Informational message
  info,

  /// Success message
  success,

  /// Warning message
  warning,

  /// Error message
  error,
}

/// Internal variant configuration
class _SnackbarVariantConfig {
  const _SnackbarVariantConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.actionColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color actionColor;
  final IconData icon;
}

/// Custom snackbar widget for more complex layouts
class CustomSnackbarWidget extends StatelessWidget {
  const CustomSnackbarWidget({
    super.key,
    required this.message,
    this.title,
    this.variant = SnackbarVariant.info,
    this.icon,
    this.actions,
    this.onDismiss,
    this.backgroundColor,
    this.textColor,
    this.titleStyle,
    this.messageStyle,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.semanticLabel,
  });

  /// Snackbar title
  final String? title;

  /// Snackbar message
  final String message;

  /// Snackbar variant
  final SnackbarVariant variant;

  /// Custom icon
  final IconData? icon;

  /// Action widgets
  final List<Widget>? actions;

  /// Dismiss callback
  final VoidCallback? onDismiss;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  /// Title text style
  final TextStyle? titleStyle;

  /// Message text style
  final TextStyle? messageStyle;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Custom elevation
  final double? elevation;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get variant configuration
    final variantConfig =
        CustomSnackbar._getVariantConfig(variant, colorScheme);

    Widget content = Container(
      padding: padding ?? UIConstants.paddingMd,
      decoration: BoxDecoration(
        color: backgroundColor ?? variantConfig.backgroundColor,
        borderRadius: borderRadius ?? UIConstants.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: elevation ?? UIConstants.elevationMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            icon ?? variantConfig.icon,
            color: variantConfig.iconColor,
            size: UIConstants.iconSizeMd,
          ),
          const SizedBox(width: UIConstants.spacingMd),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: titleStyle ??
                        theme.textTheme.titleSmall?.copyWith(
                          color: textColor ?? variantConfig.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: UIConstants.spacingXs),
                ],
                Text(
                  message,
                  style: messageStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: textColor ?? variantConfig.textColor,
                      ),
                ),
              ],
            ),
          ),

          // Actions
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: UIConstants.spacingMd),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ],

          // Dismiss button
          if (onDismiss != null) ...[
            const SizedBox(width: UIConstants.spacingSm),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                size: UIConstants.iconSizeSm,
                color: variantConfig.iconColor,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: UIConstants.iconSizeMd,
                minHeight: UIConstants.iconSizeMd,
              ),
            ),
          ],
        ],
      ),
    );

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      content = Semantics(
        label: semanticLabel,
        child: content,
      );
    }

    return content;
  }
}
