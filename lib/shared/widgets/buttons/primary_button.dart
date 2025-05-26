import 'package:flutter/material.dart';

/// Primary action button with enhanced styling and functionality
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.isLoading = false,
    this.loadingWidget,
    this.disabled = false,
    this.fullWidth = false,
    this.height,
    this.minWidth,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.textStyle,
    this.iconSize,
    this.iconSpacing = 8.0,
    this.animationDuration,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final bool isLoading;
  final Widget? loadingWidget;
  final bool disabled;
  final bool fullWidth;
  final double? height;
  final double? minWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final TextStyle? textStyle;
  final double? iconSize;
  final double iconSpacing;
  final Duration? animationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = disabled || isLoading ? null : onPressed;

    Widget buttonChild = child;

    // Handle loading state
    if (isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget ??
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? colorScheme.onPrimary,
                  ),
                ),
              ),
          SizedBox(width: iconSpacing),
          child,
        ],
      );
    }

    // Create button style
    final buttonStyle = style ??
        ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: foregroundColor ?? colorScheme.onPrimary,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: Size(minWidth ?? 0, height ?? 48),
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(12),
                side: side ?? BorderSide.none,
              ),
          textStyle: textStyle,
          animationDuration: animationDuration,
        ).copyWith(
          overlayColor: overlayColor,
        );

    Widget button = ElevatedButton(
      onPressed: effectiveOnPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: buttonStyle,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      child: buttonChild,
    );

    // Handle full width
    if (fullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    // Handle margin
    if (margin != null) {
      button = Padding(
        padding: margin!,
        child: button,
      );
    }

    return button;
  }
}

/// Primary button with icon
class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.isLoading = false,
    this.loadingWidget,
    this.disabled = false,
    this.fullWidth = false,
    this.height,
    this.minWidth,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.textStyle,
    this.iconSize,
    this.iconSpacing = 8.0,
    this.animationDuration,
    this.iconPosition = IconPosition.leading,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final bool isLoading;
  final Widget? loadingWidget;
  final bool disabled;
  final bool fullWidth;
  final double? height;
  final double? minWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final TextStyle? textStyle;
  final double? iconSize;
  final double iconSpacing;
  final Duration? animationDuration;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (iconPosition) {
      case IconPosition.leading:
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(width: iconSpacing),
            label,
          ],
        );
        break;
      case IconPosition.trailing:
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(width: iconSpacing),
            icon,
          ],
        );
        break;
      case IconPosition.top:
        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: iconSpacing),
            label,
          ],
        );
        break;
      case IconPosition.bottom:
        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(height: iconSpacing),
            icon,
          ],
        );
        break;
    }

    return PrimaryButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      isLoading: isLoading,
      loadingWidget: loadingWidget,
      disabled: disabled,
      fullWidth: fullWidth,
      height: height,
      minWidth: minWidth,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      overlayColor: overlayColor,
      side: side,
      shape: shape,
      textStyle: textStyle,
      iconSize: iconSize,
      iconSpacing: iconSpacing,
      animationDuration: animationDuration,
      child: child,
    );
  }
}

/// Primary button with gradient background
class GradientPrimaryButton extends StatelessWidget {
  const GradientPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.isLoading = false,
    this.loadingWidget,
    this.disabled = false,
    this.fullWidth = false,
    this.height,
    this.minWidth,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.foregroundColor,
    this.side,
    this.textStyle,
    this.iconSpacing = 8.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient? gradient;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isLoading;
  final Widget? loadingWidget;
  final bool disabled;
  final bool fullWidth;
  final double? height;
  final double? minWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final Color? foregroundColor;
  final BorderSide? side;
  final TextStyle? textStyle;
  final double iconSpacing;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = disabled || isLoading ? null : onPressed;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final effectiveGradient = gradient ??
        LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    Widget buttonChild = child;

    // Handle loading state
    if (isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget ??
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? colorScheme.onPrimary,
                  ),
                ),
              ),
          SizedBox(width: iconSpacing),
          child,
        ],
      );
    }

    Widget button = Material(
      elevation: elevation ?? 2,
      shadowColor: shadowColor,
      borderRadius: effectiveBorderRadius,
      child: Container(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          minHeight: height ?? 48,
        ),
        decoration: BoxDecoration(
          gradient: effectiveOnPressed != null ? effectiveGradient : null,
          color: effectiveOnPressed == null
              ? colorScheme.onSurface.withOpacity(0.12)
              : null,
          borderRadius: effectiveBorderRadius,
          border: side != null ? Border.fromBorderSide(side!) : null,
        ),
        child: InkWell(
          onTap: effectiveOnPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          focusNode: focusNode,
          autofocus: autofocus,
          borderRadius: effectiveBorderRadius,
          child: Container(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: DefaultTextStyle(
                style: textStyle ??
                    theme.textTheme.labelLarge!.copyWith(
                      color: effectiveOnPressed != null
                          ? (foregroundColor ?? colorScheme.onPrimary)
                          : colorScheme.onSurface.withOpacity(0.38),
                    ),
                child: buttonChild,
              ),
            ),
          ),
        ),
      ),
    );

    // Handle full width
    if (fullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    // Handle margin
    if (margin != null) {
      button = Padding(
        padding: margin!,
        child: button,
      );
    }

    return button;
  }
}

/// Animated primary button with scale effect
class AnimatedPrimaryButton extends StatefulWidget {
  const AnimatedPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.isLoading = false,
    this.loadingWidget,
    this.disabled = false,
    this.fullWidth = false,
    this.height,
    this.minWidth,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.foregroundColor,
    this.side,
    this.textStyle,
    this.iconSpacing = 8.0,
    this.animationDuration = const Duration(milliseconds: 150),
    this.scaleValue = 0.95,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isLoading;
  final Widget? loadingWidget;
  final bool disabled;
  final bool fullWidth;
  final double? height;
  final double? minWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? side;
  final TextStyle? textStyle;
  final double iconSpacing;
  final Duration animationDuration;
  final double scaleValue;

  @override
  State<AnimatedPrimaryButton> createState() => _AnimatedPrimaryButtonState();
}

class _AnimatedPrimaryButtonState extends State<AnimatedPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.disabled || widget.isLoading ? null : _handleTapDown,
      onTapUp: widget.disabled || widget.isLoading ? null : _handleTapUp,
      onTapCancel:
          widget.disabled || widget.isLoading ? null : _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: PrimaryButton(
              onPressed: widget.onPressed,
              onLongPress: widget.onLongPress,
              style: widget.style,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              isLoading: widget.isLoading,
              loadingWidget: widget.loadingWidget,
              disabled: widget.disabled,
              fullWidth: widget.fullWidth,
              height: widget.height,
              minWidth: widget.minWidth,
              padding: widget.padding,
              margin: widget.margin,
              borderRadius: widget.borderRadius,
              elevation: widget.elevation,
              shadowColor: widget.shadowColor,
              surfaceTintColor: widget.surfaceTintColor,
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              side: widget.side,
              textStyle: widget.textStyle,
              iconSpacing: widget.iconSpacing,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Icon position enum for icon buttons
enum IconPosition {
  leading,
  trailing,
  top,
  bottom,
}

/// Primary button size variants
enum ButtonSize {
  small,
  medium,
  large,
}

/// Primary button with size variants
class SizedPrimaryButton extends StatelessWidget {
  const SizedPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = ButtonSize.medium,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.isLoading = false,
    this.loadingWidget,
    this.disabled = false,
    this.fullWidth = false,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.foregroundColor,
    this.side,
    this.iconSpacing = 8.0,
    this.animationDuration,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonSize size;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isLoading;
  final Widget? loadingWidget;
  final bool disabled;
  final bool fullWidth;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? side;
  final double iconSpacing;
  final Duration? animationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define size-specific properties
    late double height;
    late EdgeInsetsGeometry padding;
    late TextStyle textStyle;

    switch (size) {
      case ButtonSize.small:
        height = 36;
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        textStyle = theme.textTheme.labelMedium!;
        break;
      case ButtonSize.medium:
        height = 48;
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
        textStyle = theme.textTheme.labelLarge!;
        break;
      case ButtonSize.large:
        height = 56;
        padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
        textStyle = theme.textTheme.titleMedium!;
        break;
    }

    return PrimaryButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      isLoading: isLoading,
      loadingWidget: loadingWidget,
      disabled: disabled,
      fullWidth: fullWidth,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      side: side,
      textStyle: textStyle,
      iconSpacing: iconSpacing,
      animationDuration: animationDuration,
      child: child,
    );
  }
}
