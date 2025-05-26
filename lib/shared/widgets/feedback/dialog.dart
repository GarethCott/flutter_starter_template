import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Custom dialog component with Material 3 design
///
/// Features:
/// - Multiple variants (alert, confirmation, info, custom)
/// - Action buttons
/// - Custom styling and colors
/// - Icon support
/// - Scrollable content
/// - Animation controls
/// - Accessibility support
class CustomDialog {
  /// Show an alert dialog
  static Future<T?> showAlert<T>(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    String? semanticLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomDialogWidget(
        title: title,
        content: Text(message),
        icon: icon,
        iconColor: iconColor,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
        backgroundColor: backgroundColor,
        elevation: elevation,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        semanticLabel: semanticLabel,
      ),
    );
  }

  /// Show a confirmation dialog
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    String? semanticLabel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomDialogWidget(
        title: title,
        content: Text(message),
        icon: icon,
        iconColor: iconColor,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
            child: Text(cancelText),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
        backgroundColor: backgroundColor,
        elevation: elevation,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        semanticLabel: semanticLabel,
      ),
    );
  }

  /// Show an info dialog
  static Future<T?> showInfo<T>(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Got it',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    String? semanticLabel,
  }) {
    return showAlert<T>(
      context,
      title: title,
      message: message,
      confirmText: confirmText,
      onConfirm: onConfirm,
      icon: Icons.info_outline,
      barrierDismissible: barrierDismissible,
      backgroundColor: backgroundColor,
      elevation: elevation,
      contentPadding: contentPadding,
      actionsPadding: actionsPadding,
      semanticLabel: semanticLabel,
    );
  }

  /// Show an error dialog
  static Future<T?> showError<T>(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    String? semanticLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return CustomDialogWidget(
          title: title,
          content: Text(message),
          icon: Icons.error_outline,
          iconColor: colorScheme.error,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: Text(confirmText),
            ),
          ],
          backgroundColor: backgroundColor,
          elevation: elevation,
          contentPadding: contentPadding,
          actionsPadding: actionsPadding,
          semanticLabel: semanticLabel,
        );
      },
    );
  }

  /// Show a success dialog
  static Future<T?> showSuccess<T>(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Great!',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    String? semanticLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return CustomDialogWidget(
          title: title,
          content: Text(message),
          icon: Icons.check_circle_outline,
          iconColor: colorScheme.primary,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              child: Text(confirmText),
            ),
          ],
          backgroundColor: backgroundColor,
          elevation: elevation,
          contentPadding: contentPadding,
          actionsPadding: actionsPadding,
          semanticLabel: semanticLabel,
        );
      },
    );
  }

  /// Show a custom dialog
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? content,
    List<Widget>? actions,
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    String? semanticLabel,
    bool scrollable = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomDialogWidget(
        title: title,
        content: content,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        elevation: elevation,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        semanticLabel: semanticLabel,
        scrollable: scrollable,
      ),
    );
  }

  /// Show a loading dialog
  static Future<T?> showLoading<T>(
    BuildContext context, {
    String? title,
    String? message,
    bool barrierDismissible = false,
    Color? backgroundColor,
    double? elevation,
    String? semanticLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomDialogWidget(
        title: title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: UIConstants.spacingMd),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        backgroundColor: backgroundColor,
        elevation: elevation,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

/// Custom dialog widget
class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.elevation,
    this.contentPadding,
    this.actionsPadding,
    this.semanticLabel,
    this.scrollable = false,
    this.shape,
    this.insetPadding,
  });

  /// Dialog title
  final String? title;

  /// Dialog content
  final Widget? content;

  /// Action buttons
  final List<Widget>? actions;

  /// Title icon
  final IconData? icon;

  /// Icon color
  final Color? iconColor;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom elevation
  final double? elevation;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  /// Actions padding
  final EdgeInsetsGeometry? actionsPadding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Enable scrollable content
  final bool scrollable;

  /// Custom shape
  final ShapeBorder? shape;

  /// Inset padding
  final EdgeInsets? insetPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget? titleWidget;
    if (title != null || icon != null) {
      titleWidget = _buildTitle(theme, colorScheme);
    }

    Widget dialog = AlertDialog(
      title: titleWidget,
      content: content,
      actions: actions,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      elevation: elevation ?? UIConstants.elevationHigh,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: UIConstants.borderRadiusLg,
          ),
      contentPadding:
          contentPadding ?? const EdgeInsets.fromLTRB(24, 20, 24, 24),
      actionsPadding:
          actionsPadding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
      scrollable: scrollable,
      insetPadding: insetPadding ??
          const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
    );

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      dialog = Semantics(
        label: semanticLabel,
        child: dialog,
      );
    }

    return dialog;
  }

  Widget _buildTitle(ThemeData theme, ColorScheme colorScheme) {
    final children = <Widget>[];

    // Add icon if provided
    if (icon != null) {
      children.add(
        Icon(
          icon,
          color: iconColor ?? colorScheme.primary,
          size: UIConstants.iconSizeLg,
        ),
      );
      if (title != null) {
        children.add(const SizedBox(width: UIConstants.spacingMd));
      }
    }

    // Add title if provided
    if (title != null) {
      children.add(
        Expanded(
          child: Text(
            title!,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(
      children: children,
    );
  }
}

/// Bottom sheet dialog for mobile-friendly dialogs
class CustomBottomSheetDialog {
  /// Show a bottom sheet dialog
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? content,
    List<Widget>? actions,
    IconData? icon,
    Color? iconColor,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    String? semanticLabel,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UIConstants.radiusLg),
        ),
      ),
      builder: (context) => CustomBottomSheetDialogWidget(
        title: title,
        content: content,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        semanticLabel: semanticLabel,
      ),
    );
  }

  /// Show a confirmation bottom sheet
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    String? semanticLabel,
  }) {
    return show<bool>(
      context,
      title: title,
      content: Text(message),
      icon: icon,
      iconColor: iconColor,
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        const SizedBox(width: UIConstants.spacingSm),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          child: Text(confirmText),
        ),
      ],
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      semanticLabel: semanticLabel,
    );
  }
}

/// Bottom sheet dialog widget
class CustomBottomSheetDialogWidget extends StatelessWidget {
  const CustomBottomSheetDialogWidget({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.contentPadding,
    this.actionsPadding,
    this.semanticLabel,
  });

  /// Dialog title
  final String? title;

  /// Dialog content
  final Widget? content;

  /// Action buttons
  final List<Widget>? actions;

  /// Title icon
  final IconData? icon;

  /// Icon color
  final Color? iconColor;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  /// Actions padding
  final EdgeInsetsGeometry? actionsPadding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final children = <Widget>[];

    // Drag handle
    children.add(
      Container(
        width: 32,
        height: 4,
        margin: const EdgeInsets.only(top: UIConstants.spacingSm),
        decoration: BoxDecoration(
          color: colorScheme.onSurfaceVariant.withOpacity(0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );

    children.add(const SizedBox(height: UIConstants.spacingMd));

    // Title
    if (title != null || icon != null) {
      children.add(
        Padding(
          padding: contentPadding ?? UIConstants.paddingMd,
          child: _buildTitle(theme, colorScheme),
        ),
      );
    }

    // Content
    if (content != null) {
      children.add(
        Padding(
          padding: contentPadding ?? UIConstants.paddingMd,
          child: content!,
        ),
      );
    }

    // Actions
    if (actions != null && actions!.isNotEmpty) {
      children.add(
        Padding(
          padding: actionsPadding ?? UIConstants.paddingMd,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!,
          ),
        ),
      );
    }

    // Bottom safe area
    children.add(
      SizedBox(height: MediaQuery.of(context).padding.bottom),
    );

    Widget bottomSheet = Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      bottomSheet = Semantics(
        label: semanticLabel,
        child: bottomSheet,
      );
    }

    return bottomSheet;
  }

  Widget _buildTitle(ThemeData theme, ColorScheme colorScheme) {
    final children = <Widget>[];

    // Add icon if provided
    if (icon != null) {
      children.add(
        Icon(
          icon,
          color: iconColor ?? colorScheme.primary,
          size: UIConstants.iconSizeLg,
        ),
      );
      if (title != null) {
        children.add(const SizedBox(width: UIConstants.spacingMd));
      }
    }

    // Add title if provided
    if (title != null) {
      children.add(
        Expanded(
          child: Text(
            title!,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(
      children: children,
    );
  }
}
