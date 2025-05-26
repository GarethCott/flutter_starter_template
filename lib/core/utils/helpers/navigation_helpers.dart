import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation utilities for common navigation patterns and helpers
class NavigationHelpers {
  // Private constructor to prevent instantiation
  NavigationHelpers._();

  // Basic Navigation

  /// Navigates to a named route
  static void pushNamed(
    BuildContext context,
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    context.pushNamed(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Replaces the current route with a named route
  static void pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    context.pushReplacementNamed(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Navigates to a route and clears the stack
  static void goNamed(
    BuildContext context,
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    context.goNamed(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Pops the current route
  static void pop(BuildContext context, [Object? result]) {
    if (context.canPop()) {
      context.pop(result);
    }
  }

  /// Pops until a specific route
  static void popUntil(BuildContext context, String routeName) {
    while (context.canPop()) {
      final route = ModalRoute.of(context);
      if (route?.settings.name == routeName) break;
      context.pop();
    }
  }

  /// Checks if the navigator can pop
  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  // Advanced Navigation Patterns

  /// Navigates with a slide transition
  static Future<T?> pushWithSlideTransition<T>(
    BuildContext context,
    Widget page, {
    SlideDirection direction = SlideDirection.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin;
          switch (direction) {
            case SlideDirection.rightToLeft:
              begin = const Offset(1.0, 0.0);
              break;
            case SlideDirection.leftToRight:
              begin = const Offset(-1.0, 0.0);
              break;
            case SlideDirection.topToBottom:
              begin = const Offset(0.0, -1.0);
              break;
            case SlideDirection.bottomToTop:
              begin = const Offset(0.0, 1.0);
              break;
          }

          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  /// Navigates with a fade transition
  static Future<T?> pushWithFadeTransition<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Navigates with a scale transition
  static Future<T?> pushWithScaleTransition<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }

  // Modal Navigation

  /// Shows a modal bottom sheet
  static Future<T?> showCustomModalBottomSheet<T>(
    BuildContext context,
    Widget child, {
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      builder: (context) => child,
    );
  }

  /// Shows a custom dialog
  static Future<T?> showCustomDialog<T>(
    BuildContext context,
    Widget dialog, {
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      builder: (context) => dialog,
    );
  }

  /// Shows an alert dialog
  static Future<bool?> showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                onCancel?.call();
                Navigator.of(context).pop(false);
              },
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showAlertDialog(
      context,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  // Snackbar Helpers

  /// Shows a snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textColor != null ? TextStyle(color: textColor) : null,
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Shows a success snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Shows an error snackbar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Shows a warning snackbar
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Shows an info snackbar
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  // Route Information

  /// Gets the current route name
  static String? getCurrentRouteName(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }

  /// Gets the current route arguments
  static Object? getCurrentRouteArguments(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments;
  }

  /// Checks if the current route is the given route name
  static bool isCurrentRoute(BuildContext context, String routeName) {
    return getCurrentRouteName(context) == routeName;
  }

  // Focus Management

  /// Unfocuses the current focus node (hides keyboard)
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Requests focus for a specific focus node
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  // Utility Methods

  /// Delays execution for the specified duration
  static Future<void> delay(Duration duration) {
    return Future.delayed(duration);
  }

  /// Executes a callback after the current frame
  static void postFrame(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }

  /// Executes a callback after navigation completes
  static void afterNavigation(VoidCallback callback) {
    postFrame(callback);
  }
}

/// Enum for slide transition directions
enum SlideDirection {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
}
