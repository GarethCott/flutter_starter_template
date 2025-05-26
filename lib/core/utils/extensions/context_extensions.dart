import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// BuildContext extensions for easy access to theme, media query, and navigation
extension ContextExtensions on BuildContext {
  // Theme Extensions

  /// Gets the current theme data
  ThemeData get theme => Theme.of(this);

  /// Gets the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Gets the current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Checks if the current theme is dark
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Checks if the current theme is light
  bool get isLightMode => theme.brightness == Brightness.light;

  // Media Query Extensions

  /// Gets the media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Gets the screen size
  Size get screenSize => mediaQuery.size;

  /// Gets the screen width
  double get screenWidth => screenSize.width;

  /// Gets the screen height
  double get screenHeight => screenSize.height;

  /// Gets the device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Gets the text scale factor
  double get textScaleFactor => mediaQuery.textScaleFactor;

  /// Gets the padding (safe area)
  EdgeInsets get padding => mediaQuery.padding;

  /// Gets the view insets (keyboard, etc.)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Gets the view padding
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// Gets the status bar height
  double get statusBarHeight => padding.top;

  /// Gets the bottom safe area height
  double get bottomSafeArea => padding.bottom;

  /// Checks if the keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  // Responsive Design Extensions

  /// Checks if the screen is mobile size
  bool get isMobile => screenWidth < 600;

  /// Checks if the screen is tablet size
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Checks if the screen is desktop size
  bool get isDesktop => screenWidth >= 900;

  /// Checks if the device is in landscape orientation
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Checks if the device is in portrait orientation
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  // Navigation Extensions

  /// Navigates to a named route
  void pushNamed(String routeName, {Object? extra}) {
    GoRouter.of(this).pushNamed(routeName, extra: extra);
  }

  /// Replaces the current route with a named route
  void pushReplacementNamed(String routeName, {Object? extra}) {
    GoRouter.of(this).pushReplacementNamed(routeName, extra: extra);
  }

  /// Navigates to a route and clears the stack
  void goNamed(String routeName, {Object? extra}) {
    GoRouter.of(this).goNamed(routeName, extra: extra);
  }

  /// Pops the current route
  void pop([Object? result]) {
    GoRouter.of(this).pop(result);
  }

  /// Checks if the navigator can pop
  bool get canPop => GoRouter.of(this).canPop();

  // Snackbar Extensions

  /// Shows a snackbar with the given message
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Shows a success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.primary,
    );
  }

  /// Shows an error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
    );
  }

  /// Shows a warning snackbar
  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
    );
  }

  // Dialog Extensions

  /// Shows a simple alert dialog
  Future<bool?> showAlertDialog({
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog
  Future<bool?> showConfirmationDialog({
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showAlertDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }

  // Focus Extensions

  /// Unfocuses the current focus node (hides keyboard)
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Requests focus for the given focus node
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }

  // Utility Extensions

  /// Gets the app bar height
  double get appBarHeight => AppBar().preferredSize.height;

  /// Gets the bottom navigation bar height
  double get bottomNavigationBarHeight => kBottomNavigationBarHeight;

  /// Gets the available height (screen height minus system UI)
  double get availableHeight => screenHeight - statusBarHeight - bottomSafeArea;

  /// Gets the available width
  double get availableWidth => screenWidth;

  /// Calculates responsive width based on percentage
  double widthPercent(double percent) => screenWidth * (percent / 100);

  /// Calculates responsive height based on percentage
  double heightPercent(double percent) => screenHeight * (percent / 100);

  /// Gets a responsive value based on screen size
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
