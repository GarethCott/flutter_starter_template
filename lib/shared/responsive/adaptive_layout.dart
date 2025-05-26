/// Adaptive layout widgets for responsive design
///
/// This file provides widgets that automatically adapt their layout
/// based on screen size, device type, and breakpoints.
library;

import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// A widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.tv,
  });

  /// Widget to display on mobile devices
  final Widget mobile;

  /// Widget to display on tablet devices (defaults to mobile if not provided)
  final Widget? tablet;

  /// Widget to display on desktop devices (defaults to tablet or mobile)
  final Widget? desktop;

  /// Widget to display on TV devices (defaults to desktop, tablet, or mobile)
  final Widget? tv;

  @override
  Widget build(BuildContext context) {
    return context.deviceValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      tv: tv,
    );
  }
}

/// A widget that builds different layouts based on breakpoints
class BreakpointBuilder extends StatelessWidget {
  const BreakpointBuilder({
    super.key,
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
  });

  /// Widget for extra small screens
  final Widget xs;

  /// Widget for small screens
  final Widget? sm;

  /// Widget for medium screens
  final Widget? md;

  /// Widget for large screens
  final Widget? lg;

  /// Widget for extra large screens
  final Widget? xl;

  /// Widget for extra extra large screens
  final Widget? xxl;

  @override
  Widget build(BuildContext context) {
    return context.responsiveValue(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
    );
  }
}

/// A container that adapts its properties based on screen size
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
    this.alignment,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? context.responsivePadding,
      margin: margin ?? context.responsiveMargin,
      width: width,
      height: height,
      decoration: decoration,
      alignment: alignment,
      constraints: constraints,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

/// A flexible grid that adapts the number of columns based on screen size
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.maxColumns,
    this.minItemWidth = 200.0,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Clip clipBehavior;
  final int? maxColumns;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - context.responsivePadding.horizontal;

    // Calculate optimal number of columns
    int columns = (availableWidth / (minItemWidth + spacing)).floor();
    if (maxColumns != null) {
      columns = columns.clamp(1, maxColumns!);
    }

    // Use responsive grid columns if no specific calculation
    if (columns <= 0) {
      columns = context.gridColumns;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          crossAxisAlignment: crossAxisAlignment,
          alignment: alignment,
          runAlignment: runAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          clipBehavior: clipBehavior,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// A widget that provides responsive navigation based on screen size
class ResponsiveNavigation extends StatelessWidget {
  const ResponsiveNavigation({
    super.key,
    required this.body,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.drawer,
    this.endDrawer,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset,
  });

  final Widget body;
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final Widget? drawer;
  final Widget? endDrawer;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    // Convert NavigationDestination to NavigationRailDestination
    final railDestinations = destinations.map((dest) {
      return NavigationRailDestination(
        icon: dest.icon,
        selectedIcon: dest.selectedIcon,
        label: Text(dest.label),
      );
    }).toList();

    if (context.isCompact) {
      // Mobile: Use bottom navigation bar
      return Scaffold(
        appBar: appBar,
        body: body,
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        backgroundColor: backgroundColor,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
        ),
      );
    } else if (context.isMedium) {
      // Tablet: Use navigation rail
      return Scaffold(
        appBar: appBar,
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        backgroundColor: backgroundColor,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: railDestinations,
              extended: false,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    } else {
      // Desktop: Use extended navigation rail
      return Scaffold(
        appBar: appBar,
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        backgroundColor: backgroundColor,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: railDestinations,
              extended: true,
              minExtendedWidth: 200,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
  }
}

/// A widget that adapts its layout orientation based on screen size
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.forceVertical = false,
    this.forceHorizontal = false,
  });

  final List<Widget> children;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool forceVertical;
  final bool forceHorizontal;

  @override
  Widget build(BuildContext context) {
    // Determine layout direction
    bool useVertical = forceVertical ||
        (!forceHorizontal && (context.isMobile || context.isCompact));

    if (useVertical) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacing(children, spacing, true),
      );
    } else {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacing(children, spacing, false),
      );
    }
  }

  List<Widget> _addSpacing(
      List<Widget> children, double spacing, bool vertical) {
    if (children.isEmpty) return children;

    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(
          vertical ? SizedBox(height: spacing) : SizedBox(width: spacing),
        );
      }
    }
    return spacedChildren;
  }
}

/// A widget that provides responsive spacing
class ResponsiveSpacing extends StatelessWidget {
  const ResponsiveSpacing({
    super.key,
    this.horizontal = false,
    this.vertical = false,
    this.factor = 1.0,
  });

  final bool horizontal;
  final bool vertical;
  final double factor;

  @override
  Widget build(BuildContext context) {
    final baseSpacing = 16.0 * factor;
    final spacing = ResponsiveUtils.getResponsiveSpacing(context, baseSpacing);

    return SizedBox(
      width: horizontal ? spacing : null,
      height: vertical ? spacing : null,
    );
  }
}

/// A widget that wraps content with responsive constraints
class ResponsiveConstraints extends StatelessWidget {
  const ResponsiveConstraints({
    super.key,
    required this.child,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
    this.centerContent = false,
  });

  final Widget child;
  final double? maxWidth;
  final double? maxHeight;
  final double? minWidth;
  final double? minHeight;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final responsiveMaxWidth = maxWidth ??
        context.responsiveValue(
          xs: double.infinity,
          sm: 600,
          md: 800,
          lg: 1000,
          xl: 1200,
          xxl: 1400,
        );

    Widget constrainedChild = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: responsiveMaxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
        minWidth: minWidth ?? 0.0,
        minHeight: minHeight ?? 0.0,
      ),
      child: child,
    );

    if (centerContent) {
      constrainedChild = Center(child: constrainedChild);
    }

    return constrainedChild;
  }
}

/// A widget that provides responsive text scaling
class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.responsiveScale = true,
  });

  final String text;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool responsiveScale;

  @override
  Widget build(BuildContext context) {
    TextStyle? effectiveStyle = style;

    if (responsiveScale && effectiveStyle?.fontSize != null) {
      final baseFontSize = effectiveStyle!.fontSize!;
      final responsiveFontSize = ResponsiveUtils.getResponsiveFontSize(
        context,
        baseFontSize,
      );
      effectiveStyle = effectiveStyle.copyWith(fontSize: responsiveFontSize);
    }

    return Text(
      text,
      style: effectiveStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
