import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Progress indicator component with Material 3 design
///
/// Features:
/// - Multiple variants (linear, circular, step, radial)
/// - Determinate and indeterminate modes
/// - Custom styling and colors
/// - Text labels and percentages
/// - Animation controls
/// - Accessibility support
class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({
    super.key,
    required this.value,
    this.variant = ProgressVariant.linear,
    this.size = ProgressSize.medium,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.showLabel = false,
    this.label,
    this.showPercentage = false,
    this.formatPercentage,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.semanticLabel,
    this.steps,
    this.currentStep,
  });

  /// Progress value (0.0 to 1.0, null for indeterminate)
  final double? value;

  /// Progress indicator variant
  final ProgressVariant variant;

  /// Progress indicator size
  final ProgressSize size;

  /// Custom color
  final Color? color;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom stroke width
  final double? strokeWidth;

  /// Show text label
  final bool showLabel;

  /// Custom label text
  final String? label;

  /// Show percentage
  final bool showPercentage;

  /// Custom percentage formatter
  final String Function(double)? formatPercentage;

  /// Text style for labels
  final TextStyle? textStyle;

  /// Animation duration
  final Duration animationDuration;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Number of steps (for step variant)
  final int? steps;

  /// Current step (for step variant)
  final int? currentStep;

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value ?? 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.value != null) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CustomProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value ?? 0.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      _controller.reset();
      if (widget.value != null) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget indicator = _buildIndicator(theme, colorScheme);

    // Wrap with semantics if provided
    if (widget.semanticLabel != null) {
      indicator = Semantics(
        label: widget.semanticLabel,
        value: widget.value != null
            ? '${(widget.value! * 100).round()}%'
            : 'Loading',
        child: indicator,
      );
    }

    return indicator;
  }

  Widget _buildIndicator(ThemeData theme, ColorScheme colorScheme) {
    switch (widget.variant) {
      case ProgressVariant.linear:
        return _buildLinearProgress(theme, colorScheme);
      case ProgressVariant.circular:
        return _buildCircularProgress(theme, colorScheme);
      case ProgressVariant.step:
        return _buildStepProgress(theme, colorScheme);
      case ProgressVariant.radial:
        return _buildRadialProgress(theme, colorScheme);
    }
  }

  Widget _buildLinearProgress(ThemeData theme, ColorScheme colorScheme) {
    final children = <Widget>[];

    // Add label if requested
    if (widget.showLabel || widget.showPercentage) {
      children.add(_buildLabels(theme));
      children.add(const SizedBox(height: UIConstants.spacingSm));
    }

    // Progress bar
    Widget progressBar;
    if (widget.value != null) {
      progressBar = AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _animation.value,
            color: widget.color ?? colorScheme.primary,
            backgroundColor:
                widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
            minHeight: _getLinearHeight(),
          );
        },
      );
    } else {
      progressBar = LinearProgressIndicator(
        color: widget.color ?? colorScheme.primary,
        backgroundColor:
            widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
        minHeight: _getLinearHeight(),
      );
    }

    children.add(progressBar);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildCircularProgress(ThemeData theme, ColorScheme colorScheme) {
    final size = _getCircularSize();
    final strokeWidth = widget.strokeWidth ?? _getCircularStrokeWidth();

    Widget progressIndicator;
    if (widget.value != null) {
      progressIndicator = AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: _animation.value,
              strokeWidth: strokeWidth,
              color: widget.color ?? colorScheme.primary,
              backgroundColor:
                  widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
            ),
          );
        },
      );
    } else {
      progressIndicator = SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: widget.color ?? colorScheme.primary,
          backgroundColor: widget.backgroundColor,
        ),
      );
    }

    // Add percentage in center if requested
    if (widget.showPercentage && widget.value != null) {
      progressIndicator = Stack(
        alignment: Alignment.center,
        children: [
          progressIndicator,
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final percentage = _animation.value * 100;
              return Text(
                widget.formatPercentage?.call(percentage) ??
                    '${percentage.round()}%',
                style: widget.textStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.color ?? colorScheme.primary,
                    ),
              );
            },
          ),
        ],
      );
    }

    return progressIndicator;
  }

  Widget _buildStepProgress(ThemeData theme, ColorScheme colorScheme) {
    final steps = widget.steps ?? 3;
    final currentStep = widget.currentStep ?? 0;
    final stepWidth = _getStepWidth();

    return Row(
      children: List.generate(steps, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;
        final isLast = index == steps - 1;

        return Expanded(
          child: Row(
            children: [
              // Step circle
              Container(
                width: stepWidth,
                height: stepWidth,
                decoration: BoxDecoration(
                  color: isCompleted || isCurrent
                      ? widget.color ?? colorScheme.primary
                      : widget.backgroundColor ??
                          colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: isCurrent && !isCompleted
                      ? Border.all(
                          color: widget.color ?? colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: stepWidth * 0.6,
                          color: colorScheme.onPrimary,
                        )
                      : Text(
                          '${index + 1}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isCompleted || isCurrent
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              // Connector line
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(
                        horizontal: UIConstants.spacingSm),
                    color: isCompleted
                        ? widget.color ?? colorScheme.primary
                        : widget.backgroundColor ??
                            colorScheme.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRadialProgress(ThemeData theme, ColorScheme colorScheme) {
    final size = _getCircularSize();
    final strokeWidth = widget.strokeWidth ?? _getCircularStrokeWidth();

    return CustomPaint(
      size: Size(size, size),
      painter: _RadialProgressPainter(
        progress: widget.value != null ? _animation : null,
        color: widget.color ?? colorScheme.primary,
        backgroundColor:
            widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
        strokeWidth: strokeWidth,
      ),
      child: widget.showPercentage && widget.value != null
          ? SizedBox(
              width: size,
              height: size,
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final percentage = _animation.value * 100;
                    return Text(
                      widget.formatPercentage?.call(percentage) ??
                          '${percentage.round()}%',
                      style: widget.textStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: widget.color ?? colorScheme.primary,
                          ),
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildLabels(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.showLabel && widget.label != null)
          Text(
            widget.label!,
            style: widget.textStyle ?? theme.textTheme.bodyMedium,
          ),
        if (widget.showPercentage && widget.value != null)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final percentage = _animation.value * 100;
              return Text(
                widget.formatPercentage?.call(percentage) ??
                    '${percentage.round()}%',
                style: widget.textStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              );
            },
          ),
      ],
    );
  }

  double _getLinearHeight() {
    switch (widget.size) {
      case ProgressSize.small:
        return 4.0;
      case ProgressSize.medium:
        return 6.0;
      case ProgressSize.large:
        return 8.0;
    }
  }

  double _getCircularSize() {
    switch (widget.size) {
      case ProgressSize.small:
        return 32.0;
      case ProgressSize.medium:
        return 48.0;
      case ProgressSize.large:
        return 64.0;
    }
  }

  double _getCircularStrokeWidth() {
    switch (widget.size) {
      case ProgressSize.small:
        return 3.0;
      case ProgressSize.medium:
        return 4.0;
      case ProgressSize.large:
        return 6.0;
    }
  }

  double _getStepWidth() {
    switch (widget.size) {
      case ProgressSize.small:
        return 24.0;
      case ProgressSize.medium:
        return 32.0;
      case ProgressSize.large:
        return 40.0;
    }
  }
}

/// Custom painter for radial progress
class _RadialProgressPainter extends CustomPainter {
  _RadialProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  }) : super(repaint: progress);

  final Animation<double>? progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress != null) {
      final progressPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * 3.14159 * progress!.value;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Progress indicator variants
enum ProgressVariant {
  /// Linear progress bar
  linear,

  /// Circular progress indicator
  circular,

  /// Step-by-step progress
  step,

  /// Radial progress with custom painting
  radial,
}

/// Progress indicator sizes
enum ProgressSize {
  small,
  medium,
  large,
}
