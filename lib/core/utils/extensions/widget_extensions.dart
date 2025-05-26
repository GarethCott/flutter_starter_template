import 'package:flutter/material.dart';

/// Widget extensions for common modifications and utilities
extension WidgetExtensions on Widget {
  /// Wraps the widget with padding
  Widget padding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  /// Wraps the widget with symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Wraps the widget with padding on all sides
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  /// Wraps the widget with horizontal padding
  Widget paddingHorizontal(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  /// Wraps the widget with vertical padding
  Widget paddingVertical(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  /// Wraps the widget with padding only on specific sides
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Wraps the widget with a margin (using Container)
  Widget margin(EdgeInsets margin) {
    return Container(
      margin: margin,
      child: this,
    );
  }

  /// Wraps the widget with symmetric margin
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Wraps the widget with margin on all sides
  Widget marginAll(double margin) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: this,
    );
  }

  /// Wraps the widget with horizontal margin
  Widget marginHorizontal(double margin) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: this,
    );
  }

  /// Wraps the widget with vertical margin
  Widget marginVertical(double margin) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      child: this,
    );
  }

  /// Wraps the widget with margin only on specific sides
  Widget marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Centers the widget
  Widget center() {
    return Center(child: this);
  }

  /// Aligns the widget
  Widget align(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  /// Expands the widget to fill available space
  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  /// Makes the widget flexible
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: this,
    );
  }

  /// Wraps the widget with a SizedBox for fixed dimensions
  Widget sized({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  /// Sets a fixed width for the widget
  Widget width(double width) {
    return SizedBox(
      width: width,
      child: this,
    );
  }

  /// Sets a fixed height for the widget
  Widget height(double height) {
    return SizedBox(
      height: height,
      child: this,
    );
  }

  /// Makes the widget take up the full width
  Widget fullWidth() {
    return SizedBox(
      width: double.infinity,
      child: this,
    );
  }

  /// Makes the widget take up the full height
  Widget fullHeight() {
    return SizedBox(
      height: double.infinity,
      child: this,
    );
  }

  /// Wraps the widget with a Container for styling
  Widget container({
    Color? color,
    Decoration? decoration,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      child: this,
    );
  }

  /// Wraps the widget with a Card
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsets? margin,
    Clip clipBehavior = Clip.none,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      margin: margin,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Wraps the widget with rounded corners
  Widget rounded({double radius = 8.0}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  /// Wraps the widget with custom border radius
  Widget borderRadius(BorderRadius borderRadius) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: this,
    );
  }

  /// Adds a background color to the widget
  Widget backgroundColor(Color color) {
    return Container(
      color: color,
      child: this,
    );
  }

  /// Wraps the widget with a Material for ink effects
  Widget material({
    Color? color,
    double elevation = 0.0,
    ShapeBorder? shape,
    Clip clipBehavior = Clip.none,
  }) {
    return Material(
      color: color,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Makes the widget tappable with InkWell
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
  }) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      child: this,
    );
  }

  /// Makes the widget tappable with GestureDetector
  Widget gestureDetector({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
  }) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: this,
    );
  }

  /// Wraps the widget with opacity
  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }

  /// Wraps the widget with visibility
  Widget visibility({
    bool visible = true,
    Widget replacement = const SizedBox.shrink(),
    bool maintainSize = false,
    bool maintainAnimation = false,
    bool maintainState = false,
  }) {
    return Visibility(
      visible: visible,
      replacement: replacement,
      maintainSize: maintainSize,
      maintainAnimation: maintainAnimation,
      maintainState: maintainState,
      child: this,
    );
  }

  /// Conditionally shows the widget
  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }

  /// Wraps the widget with a Hero for page transitions
  Widget hero(String tag) {
    return Hero(
      tag: tag,
      child: this,
    );
  }

  /// Wraps the widget with a SafeArea
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: this,
    );
  }

  /// Wraps the widget with a SingleChildScrollView
  Widget scrollable({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    EdgeInsets? padding,
    ScrollPhysics? physics,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      physics: physics,
      child: this,
    );
  }

  /// Wraps the widget with an AnimatedContainer for smooth transitions
  Widget animatedContainer({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Color? color,
    Decoration? decoration,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    AlignmentGeometry? alignment,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      child: this,
    );
  }

  /// Wraps the widget with a Transform for scaling
  Widget scale(double scale) {
    return Transform.scale(
      scale: scale,
      child: this,
    );
  }

  /// Wraps the widget with a Transform for rotation
  Widget rotate(double angle) {
    return Transform.rotate(
      angle: angle,
      child: this,
    );
  }

  /// Wraps the widget with a Transform for translation
  Widget translate({double x = 0, double y = 0}) {
    return Transform.translate(
      offset: Offset(x, y),
      child: this,
    );
  }
}
