import 'package:flutter/material.dart';

/// UI constants for spacing, sizes, and animations
class UIConstants {
  // Private constructor to prevent instantiation
  UIConstants._();

  // Spacing Constants
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Padding Constants
  static const EdgeInsets paddingXs = EdgeInsets.all(spacingXs);
  static const EdgeInsets paddingSm = EdgeInsets.all(spacingSm);
  static const EdgeInsets paddingMd = EdgeInsets.all(spacingMd);
  static const EdgeInsets paddingLg = EdgeInsets.all(spacingLg);
  static const EdgeInsets paddingXl = EdgeInsets.all(spacingXl);

  // Horizontal Padding
  static const EdgeInsets paddingHorizontalXs =
      EdgeInsets.symmetric(horizontal: spacingXs);
  static const EdgeInsets paddingHorizontalSm =
      EdgeInsets.symmetric(horizontal: spacingSm);
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: spacingMd);
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: spacingLg);
  static const EdgeInsets paddingHorizontalXl =
      EdgeInsets.symmetric(horizontal: spacingXl);

  // Vertical Padding
  static const EdgeInsets paddingVerticalXs =
      EdgeInsets.symmetric(vertical: spacingXs);
  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: spacingSm);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: spacingMd);
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: spacingLg);
  static const EdgeInsets paddingVerticalXl =
      EdgeInsets.symmetric(vertical: spacingXl);

  // Border Radius Constants
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 50.0;

  // BorderRadius Objects
  static const BorderRadius borderRadiusXs =
      BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusRound =
      BorderRadius.all(Radius.circular(radiusRound));

  // Icon Sizes
  static const double iconSizeXs = 16.0;
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;
  static const double iconSizeXxl = 64.0;

  // Button Sizes
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  static const double buttonMinWidth = 88.0;

  // Input Field Sizes
  static const double inputHeightSm = 40.0;
  static const double inputHeightMd = 48.0;
  static const double inputHeightLg = 56.0;

  // Avatar Sizes
  static const double avatarSizeXs = 24.0;
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 48.0;
  static const double avatarSizeLg = 64.0;
  static const double avatarSizeXl = 96.0;
  static const double avatarSizeXxl = 128.0;

  // Card Sizes
  static const double cardElevation = 2.0;
  static const double cardMaxWidth = 400.0;
  static const double cardMinHeight = 120.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // Bottom Navigation
  static const double bottomNavHeight = 80.0;
  static const double bottomNavElevation = 8.0;

  // Drawer
  static const double drawerWidth = 280.0;

  // Dialog
  static const double dialogMaxWidth = 560.0;
  static const double dialogMinWidth = 280.0;

  // Snackbar
  static const double snackbarElevation = 6.0;
  static const EdgeInsets snackbarMargin = EdgeInsets.all(spacingMd);

  // Animation Durations
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Animation Curves
  static const Curve animationCurveDefault = Curves.easeInOut;
  static const Curve animationCurveEaseIn = Curves.easeIn;
  static const Curve animationCurveEaseOut = Curves.easeOut;
  static const Curve animationCurveBounce = Curves.bounceOut;

  // Opacity Values
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;

  // Z-Index / Elevation
  static const double elevationNone = 0.0;
  static const double elevationLow = 1.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationVeryHigh = 16.0;

  // Breakpoints for Responsive Design
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;

  // Grid Constants
  static const int gridColumnsPhone = 4;
  static const int gridColumnsTablet = 8;
  static const int gridColumnsDesktop = 12;

  // List Item Heights
  static const double listItemHeightSm = 48.0;
  static const double listItemHeightMd = 56.0;
  static const double listItemHeightLg = 72.0;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // Loading Indicator
  static const double loadingIndicatorSize = 24.0;
  static const double loadingIndicatorStrokeWidth = 2.0;
}
