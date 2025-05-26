import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Floating Action Button component with Material 3 design
///
/// Features:
/// - Multiple variants (regular, small, large, extended)
/// - Loading states with spinner
/// - Icon and text support
/// - Disabled state handling
/// - Accessibility support
/// - Custom styling options
/// - Hero animation support
class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.text,
    this.variant = FABVariant.regular,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.shape,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.semanticLabel,
    this.heroTag,
    this.mini = false,
  })  : assert(
          icon != null || text != null,
          'Either icon or text must be provided',
        ),
        assert(
          variant != FABVariant.extended || text != null,
          'Extended FAB requires text',
        );

  /// Button press callback
  final VoidCallback? onPressed;

  /// Icon to display
  final IconData? icon;

  /// Text to display (required for extended variant)
  final String? text;

  /// Button variant
  final FABVariant variant;

  /// Loading state
  final bool isLoading;

  /// Enabled state
  final bool isEnabled;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom foreground color
  final Color? foregroundColor;

  /// Custom elevation
  final double? elevation;

  /// Custom focus elevation
  final double? focusElevation;

  /// Custom hover elevation
  final double? hoverElevation;

  /// Custom highlight elevation
  final double? highlightElevation;

  /// Custom disabled elevation
  final double? disabledElevation;

  /// Custom shape
  final ShapeBorder? shape;

  /// Focus node
  final FocusNode? focusNode;

  /// Auto focus
  final bool autofocus;

  /// Tooltip text
  final String? tooltip;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Hero tag for hero animations
  final Object? heroTag;

  /// Mini variant (for regular FAB only)
  final bool mini;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDisabled = !isEnabled || isLoading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    // Color configuration
    final colorConfig = _getColorConfig(colorScheme, isDisabled);

    Widget fab = _buildFAB(
      context,
      effectiveOnPressed,
      colorConfig,
    );

    // Wrap with tooltip if provided
    if (tooltip != null) {
      fab = Tooltip(
        message: tooltip!,
        child: fab,
      );
    }

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      fab = Semantics(
        label: semanticLabel,
        button: true,
        enabled: !isDisabled,
        child: fab,
      );
    }

    return fab;
  }

  Widget _buildFAB(
    BuildContext context,
    VoidCallback? onPressed,
    _FABColorConfig colorConfig,
  ) {
    final fabChild = _buildFABContent(colorConfig.foregroundColor);

    switch (variant) {
      case FABVariant.regular:
        return FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
          foregroundColor: foregroundColor ?? colorConfig.foregroundColor,
          elevation: elevation ?? UIConstants.elevationMedium,
          focusElevation: focusElevation ?? UIConstants.elevationHigh,
          hoverElevation: hoverElevation ?? UIConstants.elevationHigh,
          highlightElevation: highlightElevation ?? UIConstants.elevationHigh,
          disabledElevation: disabledElevation ?? UIConstants.elevationLow,
          shape: shape,
          focusNode: focusNode,
          autofocus: autofocus,
          heroTag: heroTag,
          mini: mini,
          child: fabChild,
        );

      case FABVariant.small:
        return FloatingActionButton.small(
          onPressed: onPressed,
          backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
          foregroundColor: foregroundColor ?? colorConfig.foregroundColor,
          elevation: elevation ?? UIConstants.elevationMedium,
          focusElevation: focusElevation ?? UIConstants.elevationHigh,
          hoverElevation: hoverElevation ?? UIConstants.elevationHigh,
          highlightElevation: highlightElevation ?? UIConstants.elevationHigh,
          disabledElevation: disabledElevation ?? UIConstants.elevationLow,
          shape: shape,
          focusNode: focusNode,
          autofocus: autofocus,
          heroTag: heroTag,
          child: fabChild,
        );

      case FABVariant.large:
        return FloatingActionButton.large(
          onPressed: onPressed,
          backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
          foregroundColor: foregroundColor ?? colorConfig.foregroundColor,
          elevation: elevation ?? UIConstants.elevationMedium,
          focusElevation: focusElevation ?? UIConstants.elevationHigh,
          hoverElevation: hoverElevation ?? UIConstants.elevationHigh,
          highlightElevation: highlightElevation ?? UIConstants.elevationHigh,
          disabledElevation: disabledElevation ?? UIConstants.elevationLow,
          shape: shape,
          focusNode: focusNode,
          autofocus: autofocus,
          heroTag: heroTag,
          child: fabChild,
        );

      case FABVariant.extended:
        return FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: backgroundColor ?? colorConfig.backgroundColor,
          foregroundColor: foregroundColor ?? colorConfig.foregroundColor,
          elevation: elevation ?? UIConstants.elevationMedium,
          focusElevation: focusElevation ?? UIConstants.elevationHigh,
          hoverElevation: hoverElevation ?? UIConstants.elevationHigh,
          highlightElevation: highlightElevation ?? UIConstants.elevationHigh,
          disabledElevation: disabledElevation ?? UIConstants.elevationLow,
          shape: shape,
          focusNode: focusNode,
          autofocus: autofocus,
          heroTag: heroTag,
          icon: icon != null ? _buildIcon(colorConfig.foregroundColor) : null,
          label: Text(
            text!,
            style: TextStyle(
              color: foregroundColor ?? colorConfig.foregroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
    }
  }

  Widget _buildFABContent(Color foregroundColor) {
    if (variant == FABVariant.extended) {
      // Extended FAB content is handled in _buildFAB
      return const SizedBox.shrink();
    }

    if (isLoading) {
      final size = _getLoadingSize();
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            this.foregroundColor ?? foregroundColor,
          ),
        ),
      );
    }

    if (icon != null) {
      return _buildIcon(foregroundColor);
    }

    if (text != null) {
      return Text(
        text!,
        style: TextStyle(
          color: this.foregroundColor ?? foregroundColor,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildIcon(Color foregroundColor) {
    if (isLoading && variant != FABVariant.extended) {
      final size = _getLoadingSize();
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            this.foregroundColor ?? foregroundColor,
          ),
        ),
      );
    }

    return Icon(
      icon,
      color: this.foregroundColor ?? foregroundColor,
      size: _getIconSize(),
    );
  }

  double _getIconSize() {
    switch (variant) {
      case FABVariant.small:
        return UIConstants.iconSizeSm;
      case FABVariant.regular:
        return UIConstants.iconSizeMd;
      case FABVariant.large:
        return UIConstants.iconSizeLg;
      case FABVariant.extended:
        return UIConstants.iconSizeMd;
    }
  }

  double _getLoadingSize() {
    switch (variant) {
      case FABVariant.small:
        return 16;
      case FABVariant.regular:
        return 20;
      case FABVariant.large:
        return 24;
      case FABVariant.extended:
        return 20;
    }
  }

  _FABColorConfig _getColorConfig(
    ColorScheme colorScheme,
    bool isDisabled,
  ) {
    if (isDisabled) {
      return _FABColorConfig(
        backgroundColor: colorScheme.onSurface.withOpacity(0.12),
        foregroundColor: colorScheme.onSurface.withOpacity(0.38),
      );
    }

    return _FABColorConfig(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
    );
  }
}

/// Floating Action Button variants
enum FABVariant {
  /// Regular sized FAB
  regular,

  /// Small sized FAB
  small,

  /// Large sized FAB
  large,

  /// Extended FAB with text
  extended,
}

/// Internal color configuration
class _FABColorConfig {
  const _FABColorConfig({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
}
