import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Custom loading indicator component with Material 3 design
///
/// Features:
/// - Multiple variants (circular, linear, dots, pulse)
/// - Size variants (small, medium, large)
/// - Color customization
/// - Animation controls
/// - Overlay support
/// - Accessibility support
/// - Custom styling options
class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({
    super.key,
    this.variant = LoadingVariant.circular,
    this.size = LoadingSize.medium,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.value,
    this.semanticLabel,
    this.showOverlay = false,
    this.overlayColor,
    this.text,
    this.textStyle,
  });

  /// Loading indicator variant
  final LoadingVariant variant;

  /// Loading indicator size
  final LoadingSize size;

  /// Custom color
  final Color? color;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom stroke width (for circular variant)
  final double? strokeWidth;

  /// Progress value (0.0 to 1.0, null for indeterminate)
  final double? value;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Show overlay background
  final bool showOverlay;

  /// Overlay color
  final Color? overlayColor;

  /// Loading text
  final String? text;

  /// Text style
  final TextStyle? textStyle;

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.variant == LoadingVariant.dots ||
        widget.variant == LoadingVariant.pulse) {
      _controller.repeat();
    }

    if (widget.variant == LoadingVariant.pulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget indicator = _buildIndicator(theme, colorScheme);

    // Add text if provided
    if (widget.text != null) {
      indicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: UIConstants.spacingMd),
          Text(
            widget.text!,
            style: widget.textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: widget.color ?? colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Add overlay if requested
    if (widget.showOverlay) {
      indicator = Container(
        color: widget.overlayColor ?? colorScheme.surface.withOpacity(0.8),
        child: Center(child: indicator),
      );
    }

    // Wrap with semantics if provided
    if (widget.semanticLabel != null) {
      indicator = Semantics(
        label: widget.semanticLabel,
        child: indicator,
      );
    }

    return indicator;
  }

  Widget _buildIndicator(ThemeData theme, ColorScheme colorScheme) {
    switch (widget.variant) {
      case LoadingVariant.circular:
        return _buildCircularIndicator(colorScheme);
      case LoadingVariant.linear:
        return _buildLinearIndicator(colorScheme);
      case LoadingVariant.dots:
        return _buildDotsIndicator(colorScheme);
      case LoadingVariant.pulse:
        return _buildPulseIndicator(colorScheme);
    }
  }

  Widget _buildCircularIndicator(ColorScheme colorScheme) {
    final size = _getSize();
    final strokeWidth = widget.strokeWidth ?? _getStrokeWidth();

    if (widget.value != null) {
      // Determinate progress
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          value: widget.value,
          strokeWidth: strokeWidth,
          color: widget.color ?? colorScheme.primary,
          backgroundColor:
              widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
        ),
      );
    }

    // Indeterminate progress
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: widget.color ?? colorScheme.primary,
        backgroundColor: widget.backgroundColor,
      ),
    );
  }

  Widget _buildLinearIndicator(ColorScheme colorScheme) {
    final width = _getLinearWidth();

    if (widget.value != null) {
      // Determinate progress
      return SizedBox(
        width: width,
        child: LinearProgressIndicator(
          value: widget.value,
          color: widget.color ?? colorScheme.primary,
          backgroundColor:
              widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
        ),
      );
    }

    // Indeterminate progress
    return SizedBox(
      width: width,
      child: LinearProgressIndicator(
        color: widget.color ?? colorScheme.primary,
        backgroundColor:
            widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildDotsIndicator(ColorScheme colorScheme) {
    final dotSize = _getDotSize();
    final spacing = _getDotSpacing();
    final color = widget.color ?? colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = Curves.easeInOut.transform(
              (animationValue * 2).clamp(0.0, 1.0),
            );
            final opacity = scale > 0.5 ? 2 - (scale * 2) : scale * 2;

            return Padding(
              padding: EdgeInsets.only(
                right: index < 2 ? spacing : 0,
              ),
              child: Transform.scale(
                scale: 0.5 + (scale * 0.5),
                child: Opacity(
                  opacity: 0.3 + (opacity * 0.7),
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPulseIndicator(ColorScheme colorScheme) {
    final size = _getSize();
    final color = widget.color ?? colorScheme.primary;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _getSize() {
    switch (widget.size) {
      case LoadingSize.small:
        return 20.0;
      case LoadingSize.medium:
        return 32.0;
      case LoadingSize.large:
        return 48.0;
    }
  }

  double _getStrokeWidth() {
    switch (widget.size) {
      case LoadingSize.small:
        return 2.0;
      case LoadingSize.medium:
        return 3.0;
      case LoadingSize.large:
        return 4.0;
    }
  }

  double _getLinearWidth() {
    switch (widget.size) {
      case LoadingSize.small:
        return 100.0;
      case LoadingSize.medium:
        return 200.0;
      case LoadingSize.large:
        return 300.0;
    }
  }

  double _getDotSize() {
    switch (widget.size) {
      case LoadingSize.small:
        return 6.0;
      case LoadingSize.medium:
        return 8.0;
      case LoadingSize.large:
        return 12.0;
    }
  }

  double _getDotSpacing() {
    switch (widget.size) {
      case LoadingSize.small:
        return 4.0;
      case LoadingSize.medium:
        return 6.0;
      case LoadingSize.large:
        return 8.0;
    }
  }
}

/// Loading indicator variants
enum LoadingVariant {
  /// Circular progress indicator
  circular,

  /// Linear progress indicator
  linear,

  /// Animated dots
  dots,

  /// Pulsing circle
  pulse,
}

/// Loading indicator sizes
enum LoadingSize {
  small,
  medium,
  large,
}
