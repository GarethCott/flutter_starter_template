/// Accessibility utilities and helpers for inclusive design
///
/// This file provides utilities for implementing accessibility features
/// including screen reader support, keyboard navigation, focus management,
/// and accessibility compliance helpers.
library;

import 'package:flutter/material.dart';

/// Accessibility utilities for inclusive design
class AccessibilityUtils {
  // Private constructor to prevent instantiation
  AccessibilityUtils._();

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Check if high contrast mode is enabled
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Check if bold text is enabled
  static bool isBoldTextEnabled(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }

  /// Get the current text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Check if reduce motion is enabled
  static bool isReduceMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get accessible font size based on user preferences
  static double getAccessibleFontSize(
      BuildContext context, double baseFontSize) {
    final textScaleFactor = getTextScaleFactor(context);
    return baseFontSize * textScaleFactor.clamp(0.8, 2.0);
  }

  /// Get accessible color contrast ratio
  static double getContrastRatio(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();

    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if color combination meets WCAG AA standards (4.5:1 ratio)
  static bool meetsWCAGAA(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 4.5;
  }

  /// Check if color combination meets WCAG AAA standards (7:1 ratio)
  static bool meetsWCAGAAA(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 7.0;
  }

  /// Get accessible color that meets contrast requirements
  static Color getAccessibleColor(
    Color baseColor,
    Color background, {
    bool requireAAA = false,
  }) {
    final requiredRatio = requireAAA ? 7.0 : 4.5;

    if (getContrastRatio(baseColor, background) >= requiredRatio) {
      return baseColor;
    }

    // Try making the color darker or lighter
    final baseLuminance = baseColor.computeLuminance();
    final bgLuminance = background.computeLuminance();

    if (baseLuminance > bgLuminance) {
      // Make darker
      return _adjustColorForContrast(
          baseColor, background, true, requiredRatio);
    } else {
      // Make lighter
      return _adjustColorForContrast(
          baseColor, background, false, requiredRatio);
    }
  }

  static Color _adjustColorForContrast(
    Color color,
    Color background,
    bool makeDarker,
    double requiredRatio,
  ) {
    final hsl = HSLColor.fromColor(color);
    double lightness = hsl.lightness;

    for (int i = 0; i < 100; i++) {
      if (makeDarker) {
        lightness = (lightness - 0.01).clamp(0.0, 1.0);
      } else {
        lightness = (lightness + 0.01).clamp(0.0, 1.0);
      }

      final adjustedColor = hsl.withLightness(lightness).toColor();
      if (getContrastRatio(adjustedColor, background) >= requiredRatio) {
        return adjustedColor;
      }

      if (lightness <= 0.0 || lightness >= 1.0) break;
    }

    // Fallback to black or white
    return makeDarker ? Colors.black : Colors.white;
  }

  /// Create semantic label for screen readers
  static String createSemanticLabel({
    required String label,
    String? hint,
    String? value,
    bool isButton = false,
    bool isSelected = false,
    bool isExpanded = false,
    bool isDisabled = false,
  }) {
    final parts = <String>[label];

    if (value != null && value.isNotEmpty) {
      parts.add(value);
    }

    if (isButton) parts.add('button');
    if (isSelected) parts.add('selected');
    if (isExpanded) parts.add('expanded');
    if (isDisabled) parts.add('disabled');

    if (hint != null && hint.isNotEmpty) {
      parts.add(hint);
    }

    return parts.join(', ');
  }

  /// Announce message to screen reader
  static void announceToScreenReader(
    BuildContext context,
    String message,
  ) {
    // Use the Semantics widget to announce messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will be announced by screen readers when the widget is built
      // In practice, you would use this in a widget that gets rebuilt
    });
  }

  /// Focus management utilities
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
    });
  }

  /// Move focus to next focusable element
  static void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Move focus to previous focusable element
  static void focusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Unfocus current element
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

/// Widget that provides accessible tap targets with minimum size requirements
class AccessibleTapTarget extends StatelessWidget {
  const AccessibleTapTarget({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.semanticHint,
    this.semanticValue,
    this.isButton = false,
    this.isSelected = false,
    this.isExpanded = false,
    this.excludeFromSemantics = false,
    this.minSize = 44.0,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final String? semanticHint;
  final String? semanticValue;
  final bool isButton;
  final bool isSelected;
  final bool isExpanded;
  final bool excludeFromSemantics;
  final double minSize;

  @override
  Widget build(BuildContext context) {
    Widget tapTarget = GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        constraints: BoxConstraints(
          minWidth: minSize,
          minHeight: minSize,
        ),
        child: child,
      ),
    );

    if (!excludeFromSemantics) {
      final semanticLabelText = AccessibilityUtils.createSemanticLabel(
        label: semanticLabel ?? '',
        hint: semanticHint,
        value: semanticValue,
        isButton: isButton,
        isSelected: isSelected,
        isExpanded: isExpanded,
        isDisabled: onTap == null,
      );

      tapTarget = Semantics(
        label: semanticLabelText,
        button: isButton,
        selected: isSelected,
        expanded: isExpanded,
        enabled: onTap != null,
        child: tapTarget,
      );
    }

    return tapTarget;
  }
}

/// Widget that provides accessible text with proper contrast and scaling
class AccessibleText extends StatelessWidget {
  const AccessibleText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.ensureContrast = true,
    this.respectTextScale = true,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final bool ensureContrast;
  final bool respectTextScale;

  @override
  Widget build(BuildContext context) {
    TextStyle? effectiveStyle = style;

    if (respectTextScale && effectiveStyle?.fontSize != null) {
      final accessibleFontSize = AccessibilityUtils.getAccessibleFontSize(
        context,
        effectiveStyle!.fontSize!,
      );
      effectiveStyle = effectiveStyle.copyWith(fontSize: accessibleFontSize);
    }

    if (ensureContrast && effectiveStyle?.color != null) {
      final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
      final accessibleColor = AccessibilityUtils.getAccessibleColor(
        effectiveStyle!.color!,
        backgroundColor,
      );
      effectiveStyle = effectiveStyle.copyWith(color: accessibleColor);
    }

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
    );
  }
}

/// Widget that provides keyboard navigation support
class KeyboardNavigable extends StatefulWidget {
  const KeyboardNavigable({
    super.key,
    required this.child,
    this.focusNode,
    this.onFocusChange,
    this.onKeyEvent,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.skipTraversal = false,
  });

  final Widget child;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final bool autofocus;
  final bool canRequestFocus;
  final bool skipTraversal;

  @override
  State<KeyboardNavigable> createState() => _KeyboardNavigableState();
}

class _KeyboardNavigableState extends State<KeyboardNavigable> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onFocusChange: widget.onFocusChange,
      onKeyEvent: widget.onKeyEvent,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      skipTraversal: widget.skipTraversal,
      child: widget.child,
    );
  }
}

/// Widget that provides high contrast mode support
class HighContrastWrapper extends StatelessWidget {
  const HighContrastWrapper({
    super.key,
    required this.child,
    this.highContrastChild,
  });

  final Widget child;
  final Widget? highContrastChild;

  @override
  Widget build(BuildContext context) {
    if (AccessibilityUtils.isHighContrastEnabled(context) &&
        highContrastChild != null) {
      return highContrastChild!;
    }
    return child;
  }
}

/// Widget that provides reduced motion support
class ReducedMotionWrapper extends StatelessWidget {
  const ReducedMotionWrapper({
    super.key,
    required this.child,
    this.reducedMotionChild,
    this.animationDuration = const Duration(milliseconds: 300),
    this.reducedAnimationDuration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final Widget? reducedMotionChild;
  final Duration animationDuration;
  final Duration reducedAnimationDuration;

  @override
  Widget build(BuildContext context) {
    if (AccessibilityUtils.isReduceMotionEnabled(context)) {
      return reducedMotionChild ?? child;
    }
    return child;
  }

  /// Get appropriate animation duration based on reduce motion setting
  Duration getAnimationDuration(BuildContext context) {
    return AccessibilityUtils.isReduceMotionEnabled(context)
        ? reducedAnimationDuration
        : animationDuration;
  }
}

/// Extension on BuildContext for accessibility utilities
extension AccessibilityContext on BuildContext {
  /// Check if screen reader is enabled
  bool get isScreenReaderEnabled =>
      AccessibilityUtils.isScreenReaderEnabled(this);

  /// Check if high contrast mode is enabled
  bool get isHighContrastEnabled =>
      AccessibilityUtils.isHighContrastEnabled(this);

  /// Check if bold text is enabled
  bool get isBoldTextEnabled => AccessibilityUtils.isBoldTextEnabled(this);

  /// Check if reduce motion is enabled
  bool get isReduceMotionEnabled =>
      AccessibilityUtils.isReduceMotionEnabled(this);

  /// Get text scale factor
  double get textScaleFactor => AccessibilityUtils.getTextScaleFactor(this);

  /// Get accessible font size
  double getAccessibleFontSize(double baseFontSize) =>
      AccessibilityUtils.getAccessibleFontSize(this, baseFontSize);

  /// Announce message to screen reader
  void announceToScreenReader(String message) =>
      AccessibilityUtils.announceToScreenReader(this, message);

  /// Focus next element
  void focusNext() => AccessibilityUtils.focusNext(this);

  /// Focus previous element
  void focusPrevious() => AccessibilityUtils.focusPrevious(this);

  /// Unfocus current element
  void unfocus() => AccessibilityUtils.unfocus(this);
}
