/// Responsive breakpoint definitions and utilities for adaptive layouts
///
/// This file defines the breakpoint system used throughout the app for
/// responsive design. It includes predefined breakpoints, utility methods
/// for checking screen sizes, and responsive value selection.
library;

import 'package:flutter/material.dart';

/// Predefined breakpoint values following Material Design guidelines
/// and common responsive design patterns
class Breakpoints {
  // Private constructor to prevent instantiation
  Breakpoints._();

  /// Extra small screens (phones in portrait)
  static const double xs = 0;

  /// Small screens (phones in landscape, small tablets)
  static const double sm = 576;

  /// Medium screens (tablets)
  static const double md = 768;

  /// Large screens (small laptops, large tablets)
  static const double lg = 992;

  /// Extra large screens (laptops, desktops)
  static const double xl = 1200;

  /// Extra extra large screens (large desktops)
  static const double xxl = 1400;

  /// Compact width threshold for navigation rail vs drawer
  static const double compactWidth = 600;

  /// Medium width threshold for expanded navigation
  static const double mediumWidth = 840;

  /// Large width threshold for full desktop layout
  static const double largeWidth = 1200;
}

/// Screen size categories for responsive design
enum ScreenSize {
  /// Extra small screens (0-575px)
  xs,

  /// Small screens (576-767px)
  sm,

  /// Medium screens (768-991px)
  md,

  /// Large screens (992-1199px)
  lg,

  /// Extra large screens (1200-1399px)
  xl,

  /// Extra extra large screens (1400px+)
  xxl,
}

/// Device type categories for platform-specific adaptations
enum DeviceType {
  /// Mobile phones
  mobile,

  /// Tablets
  tablet,

  /// Desktop computers
  desktop,

  /// TV screens
  tv,
}

/// Responsive utilities for screen size detection and adaptive layouts
class ResponsiveUtils {
  // Private constructor to prevent instantiation
  ResponsiveUtils._();

  /// Get the current screen size category based on width
  static ScreenSize getScreenSize(double width) {
    if (width >= Breakpoints.xxl) return ScreenSize.xxl;
    if (width >= Breakpoints.xl) return ScreenSize.xl;
    if (width >= Breakpoints.lg) return ScreenSize.lg;
    if (width >= Breakpoints.md) return ScreenSize.md;
    if (width >= Breakpoints.sm) return ScreenSize.sm;
    return ScreenSize.xs;
  }

  /// Get the current screen size category from BuildContext
  static ScreenSize getScreenSizeFromContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getScreenSize(width);
  }

  /// Determine device type based on screen size and platform
  static DeviceType getDeviceType(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final diagonal = (width * width + height * height) / (160 * 160);

    // TV detection (large screens, typically landscape)
    if (diagonal > 100 && width > height) {
      return DeviceType.tv;
    }

    // Desktop detection (large screens or web platform)
    if (width >= Breakpoints.lg) {
      return DeviceType.desktop;
    }

    // Tablet detection (medium screens)
    if (width >= Breakpoints.md || diagonal > 50) {
      return DeviceType.tablet;
    }

    // Default to mobile
    return DeviceType.mobile;
  }

  /// Check if the current screen is mobile size
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Check if the current screen is tablet size
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Check if the current screen is desktop size
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// Check if the current screen is TV size
  static bool isTV(BuildContext context) {
    return getDeviceType(context) == DeviceType.tv;
  }

  /// Check if the screen width is at least the specified breakpoint
  static bool isAtLeast(BuildContext context, double breakpoint) {
    return MediaQuery.of(context).size.width >= breakpoint;
  }

  /// Check if the screen width is below the specified breakpoint
  static bool isBelow(BuildContext context, double breakpoint) {
    return MediaQuery.of(context).size.width < breakpoint;
  }

  /// Check if the screen is in compact mode (for navigation)
  static bool isCompact(BuildContext context) {
    return isBelow(context, Breakpoints.compactWidth);
  }

  /// Check if the screen is in medium mode (for navigation)
  static bool isMedium(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.compactWidth && width < Breakpoints.mediumWidth;
  }

  /// Check if the screen is in expanded mode (for navigation)
  static bool isExpanded(BuildContext context) {
    return isAtLeast(context, Breakpoints.mediumWidth);
  }

  /// Get responsive value based on screen size
  ///
  /// Example:
  /// ```dart
  /// final padding = ResponsiveUtils.getResponsiveValue(
  ///   context,
  ///   xs: 8.0,
  ///   sm: 12.0,
  ///   md: 16.0,
  ///   lg: 20.0,
  ///   xl: 24.0,
  ///   xxl: 32.0,
  /// );
  /// ```
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
    T? xxl,
  }) {
    final screenSize = getScreenSizeFromContext(context);

    switch (screenSize) {
      case ScreenSize.xxl:
        return xxl ?? xl ?? lg ?? md ?? sm ?? xs;
      case ScreenSize.xl:
        return xl ?? lg ?? md ?? sm ?? xs;
      case ScreenSize.lg:
        return lg ?? md ?? sm ?? xs;
      case ScreenSize.md:
        return md ?? sm ?? xs;
      case ScreenSize.sm:
        return sm ?? xs;
      case ScreenSize.xs:
        return xs;
    }
  }

  /// Get responsive value based on device type
  static T getDeviceValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? tv,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.tv:
        return tv ?? desktop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }

  /// Calculate responsive font size based on screen size
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize, {
    double scaleFactor = 0.1,
  }) {
    final screenSize = getScreenSizeFromContext(context);
    final multiplier = switch (screenSize) {
      ScreenSize.xs => 0.9,
      ScreenSize.sm => 1.0,
      ScreenSize.md => 1.1,
      ScreenSize.lg => 1.2,
      ScreenSize.xl => 1.3,
      ScreenSize.xxl => 1.4,
    };

    return baseFontSize * multiplier;
  }

  /// Calculate responsive spacing based on screen size
  static double getResponsiveSpacing(
    BuildContext context,
    double baseSpacing, {
    double scaleFactor = 0.2,
  }) {
    final screenSize = getScreenSizeFromContext(context);
    final multiplier = switch (screenSize) {
      ScreenSize.xs => 0.8,
      ScreenSize.sm => 1.0,
      ScreenSize.md => 1.2,
      ScreenSize.lg => 1.4,
      ScreenSize.xl => 1.6,
      ScreenSize.xxl => 1.8,
    };

    return baseSpacing * multiplier;
  }

  /// Get the number of columns for a responsive grid
  static int getGridColumns(BuildContext context) {
    return getResponsiveValue(
      context,
      xs: 1,
      sm: 2,
      md: 3,
      lg: 4,
      xl: 5,
      xxl: 6,
    );
  }

  /// Get responsive padding values
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final padding = getResponsiveValue(
      context,
      xs: 8.0,
      sm: 12.0,
      md: 16.0,
      lg: 20.0,
      xl: 24.0,
      xxl: 32.0,
    );

    return EdgeInsets.all(padding);
  }

  /// Get responsive margin values
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final margin = getResponsiveValue(
      context,
      xs: 4.0,
      sm: 6.0,
      md: 8.0,
      lg: 12.0,
      xl: 16.0,
      xxl: 20.0,
    );

    return EdgeInsets.all(margin);
  }
}

/// Extension on BuildContext for convenient responsive utilities
extension ResponsiveContext on BuildContext {
  /// Get the current screen size
  ScreenSize get screenSize => ResponsiveUtils.getScreenSizeFromContext(this);

  /// Get the current device type
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);

  /// Check if the screen is mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Check if the screen is tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Check if the screen is desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Check if the screen is TV
  bool get isTV => ResponsiveUtils.isTV(this);

  /// Check if the screen is compact
  bool get isCompact => ResponsiveUtils.isCompact(this);

  /// Check if the screen is medium
  bool get isMedium => ResponsiveUtils.isMedium(this);

  /// Check if the screen is expanded
  bool get isExpanded => ResponsiveUtils.isExpanded(this);

  /// Get responsive value
  T responsiveValue<T>({
    required T xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
    T? xxl,
  }) =>
      ResponsiveUtils.getResponsiveValue(
        this,
        xs: xs,
        sm: sm,
        md: md,
        lg: lg,
        xl: xl,
        xxl: xxl,
      );

  /// Get device-specific value
  T deviceValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? tv,
  }) =>
      ResponsiveUtils.getDeviceValue(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        tv: tv,
      );

  /// Get responsive padding
  EdgeInsets get responsivePadding =>
      ResponsiveUtils.getResponsivePadding(this);

  /// Get responsive margin
  EdgeInsets get responsiveMargin => ResponsiveUtils.getResponsiveMargin(this);

  /// Get grid columns
  int get gridColumns => ResponsiveUtils.getGridColumns(this);
}
