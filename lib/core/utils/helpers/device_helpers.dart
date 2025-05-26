import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Device information and capabilities helper functions
class DeviceHelpers {
  // Private constructor to prevent instantiation
  DeviceHelpers._();

  // Platform Detection

  /// Checks if the current platform is iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Checks if the current platform is Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Checks if the current platform is Web
  static bool get isWeb => kIsWeb;

  /// Checks if the current platform is macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Checks if the current platform is Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Checks if the current platform is Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Checks if the current platform is mobile (iOS or Android)
  static bool get isMobile => isIOS || isAndroid;

  /// Checks if the current platform is desktop (macOS, Windows, or Linux)
  static bool get isDesktop => isMacOS || isWindows || isLinux;

  // Build Mode Detection

  /// Checks if the app is running in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Checks if the app is running in profile mode
  static bool get isProfileMode => kProfileMode;

  /// Checks if the app is running in release mode
  static bool get isReleaseMode => kReleaseMode;

  // Device Capabilities

  /// Checks if the device supports haptic feedback
  static bool get supportsHapticFeedback => isMobile;

  /// Triggers light haptic feedback
  static Future<void> lightHapticFeedback() async {
    if (supportsHapticFeedback) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Triggers medium haptic feedback
  static Future<void> mediumHapticFeedback() async {
    if (supportsHapticFeedback) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Triggers heavy haptic feedback
  static Future<void> heavyHapticFeedback() async {
    if (supportsHapticFeedback) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Triggers selection haptic feedback
  static Future<void> selectionHapticFeedback() async {
    if (supportsHapticFeedback) {
      await HapticFeedback.selectionClick();
    }
  }

  // Screen and Display

  /// Gets the device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Gets the screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Gets the screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Gets the screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Checks if the device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Checks if the device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Gets the status bar height
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Gets the bottom safe area height
  static double getBottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Checks if the keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  // Device Type Detection

  /// Determines if the device is a tablet based on screen size
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = (size.width * size.width + size.height * size.height);
    return diagonal > 1100000; // Roughly 7 inches diagonal
  }

  /// Determines if the device is a phone
  static bool isPhone(BuildContext context) {
    return !isTablet(context);
  }

  /// Gets a responsive value based on device type
  static T responsive<T>(
    BuildContext context, {
    required T phone,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? phone;
    if (isTablet(context)) return tablet ?? phone;
    return phone;
  }

  // System UI

  /// Sets the system UI overlay style (status bar, navigation bar)
  static void setSystemUIOverlayStyle({
    Color? statusBarColor,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
    Color? systemNavigationBarColor,
    Brightness? systemNavigationBarIconBrightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
        systemNavigationBarColor: systemNavigationBarColor,
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
      ),
    );
  }

  /// Sets the preferred orientations
  static Future<void> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  /// Locks the device to portrait orientation
  static Future<void> lockPortrait() async {
    await setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Locks the device to landscape orientation
  static Future<void> lockLandscape() async {
    await setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Unlocks device orientation (allows all orientations)
  static Future<void> unlockOrientation() async {
    await setPreferredOrientations(DeviceOrientation.values);
  }

  // Clipboard

  /// Copies text to clipboard
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Gets text from clipboard
  static Future<String?> getFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Checks if clipboard has data
  static Future<bool> hasClipboardData() async {
    return await Clipboard.hasStrings();
  }

  // Keyboard

  /// Hides the keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Shows the keyboard for a specific focus node
  static void showKeyboard(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  // App Lifecycle

  /// Minimizes the app (Android only)
  static Future<void> minimizeApp() async {
    if (isAndroid) {
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  // Utility Methods

  /// Gets the platform name as a string
  static String getPlatformName() {
    if (isWeb) return 'Web';
    if (isIOS) return 'iOS';
    if (isAndroid) return 'Android';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Gets the build mode as a string
  static String getBuildMode() {
    if (isDebugMode) return 'Debug';
    if (isProfileMode) return 'Profile';
    if (isReleaseMode) return 'Release';
    return 'Unknown';
  }

  /// Checks if the device supports a specific feature
  static bool supportsFeature(String feature) {
    switch (feature.toLowerCase()) {
      case 'haptic':
      case 'haptics':
        return supportsHapticFeedback;
      case 'camera':
        return isMobile;
      case 'location':
        return isMobile || isWeb;
      case 'biometrics':
        return isMobile;
      case 'push_notifications':
        return isMobile || isWeb;
      default:
        return false;
    }
  }

  /// Gets device information as a map
  static Map<String, dynamic> getDeviceInfo(BuildContext context) {
    return {
      'platform': getPlatformName(),
      'buildMode': getBuildMode(),
      'isWeb': isWeb,
      'isMobile': isMobile,
      'isDesktop': isDesktop,
      'isTablet': isTablet(context),
      'isPhone': isPhone(context),
      'screenWidth': getScreenWidth(context),
      'screenHeight': getScreenHeight(context),
      'devicePixelRatio': getDevicePixelRatio(context),
      'isLandscape': isLandscape(context),
      'isPortrait': isPortrait(context),
      'statusBarHeight': getStatusBarHeight(context),
      'bottomSafeArea': getBottomSafeArea(context),
      'isKeyboardVisible': isKeyboardVisible(context),
    };
  }
}
