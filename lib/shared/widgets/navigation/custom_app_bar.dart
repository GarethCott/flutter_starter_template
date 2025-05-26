import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar component with Material 3 design
///
/// Features:
/// - Multiple variants (standard, large, medium, center-aligned)
/// - Custom styling and colors
/// - Action buttons and menu
/// - Search functionality
/// - Scroll behavior
/// - Accessibility support
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottom,
    this.variant = AppBarVariant.standard,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.titleTextStyle,
    this.toolbarTextStyle,
    this.systemOverlayStyle,
    this.automaticallyImplyLeading = true,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.scrolledUnderElevation,
    this.notificationPredicate,
    this.semanticLabel,
    this.showSearchButton = false,
    this.onSearchPressed,
    this.showMenuButton = false,
    this.onMenuPressed,
  });

  /// App bar title text
  final String? title;

  /// Custom title widget
  final Widget? titleWidget;

  /// App bar subtitle
  final String? subtitle;

  /// Leading widget
  final Widget? leading;

  /// Action widgets
  final List<Widget>? actions;

  /// Bottom widget
  final PreferredSizeWidget? bottom;

  /// App bar variant
  final AppBarVariant variant;

  /// Center title
  final bool? centerTitle;

  /// Background color
  final Color? backgroundColor;

  /// Foreground color
  final Color? foregroundColor;

  /// Elevation
  final double? elevation;

  /// Shadow color
  final Color? shadowColor;

  /// Surface tint color
  final Color? surfaceTintColor;

  /// Shape
  final ShapeBorder? shape;

  /// Icon theme
  final IconThemeData? iconTheme;

  /// Actions icon theme
  final IconThemeData? actionsIconTheme;

  /// Title text style
  final TextStyle? titleTextStyle;

  /// Toolbar text style
  final TextStyle? toolbarTextStyle;

  /// System overlay style
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Automatically imply leading
  final bool automaticallyImplyLeading;

  /// Exclude header semantics
  final bool excludeHeaderSemantics;

  /// Title spacing
  final double? titleSpacing;

  /// Toolbar opacity
  final double toolbarOpacity;

  /// Bottom opacity
  final double bottomOpacity;

  /// Toolbar height
  final double? toolbarHeight;

  /// Leading width
  final double? leadingWidth;

  /// Scrolled under elevation
  final double? scrolledUnderElevation;

  /// Notification predicate
  final ScrollNotificationPredicate? notificationPredicate;

  /// Semantic label
  final String? semanticLabel;

  /// Show search button
  final bool showSearchButton;

  /// Search button callback
  final VoidCallback? onSearchPressed;

  /// Show menu button
  final bool showMenuButton;

  /// Menu button callback
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build title widget
    Widget? titleContent = _buildTitle(theme);

    // Build actions
    List<Widget>? appBarActions = _buildActions();

    switch (variant) {
      case AppBarVariant.standard:
        return AppBar(
          title: titleContent,
          leading: leading,
          actions: appBarActions,
          bottom: bottom,
          centerTitle: centerTitle,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          shape: shape,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          titleTextStyle: titleTextStyle,
          toolbarTextStyle: toolbarTextStyle,
          systemOverlayStyle: systemOverlayStyle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
          toolbarHeight: toolbarHeight,
          leadingWidth: leadingWidth,
          scrolledUnderElevation: scrolledUnderElevation,
        );

      case AppBarVariant.centerAligned:
        return AppBar(
          title: titleContent,
          leading: leading,
          actions: appBarActions,
          bottom: bottom,
          centerTitle: true,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          shape: shape,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          titleTextStyle: titleTextStyle,
          toolbarTextStyle: toolbarTextStyle,
          systemOverlayStyle: systemOverlayStyle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
          toolbarHeight: toolbarHeight,
          leadingWidth: leadingWidth,
          scrolledUnderElevation: scrolledUnderElevation,
        );

      case AppBarVariant.large:
      case AppBarVariant.medium:
        // For large and medium variants, we'll use a custom implementation
        // since SliverAppBar.large/medium can't be used in PreferredSizeWidget
        return AppBar(
          title: titleContent,
          leading: leading,
          actions: appBarActions,
          bottom: bottom,
          centerTitle: centerTitle,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          shape: shape,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          titleTextStyle: titleTextStyle,
          toolbarTextStyle: toolbarTextStyle,
          systemOverlayStyle: systemOverlayStyle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
          toolbarHeight: toolbarHeight ?? _getVariantHeight(),
          leadingWidth: leadingWidth,
          scrolledUnderElevation: scrolledUnderElevation,
        );
    }
  }

  Widget? _buildTitle(ThemeData theme) {
    if (titleWidget != null) {
      return titleWidget;
    }

    if (title == null && subtitle == null) {
      return null;
    }

    if (subtitle == null) {
      return Text(title!);
    }

    // Build title with subtitle
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(
            title!,
            style: titleTextStyle ?? theme.appBarTheme.titleTextStyle,
          ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  List<Widget>? _buildActions() {
    final actionsList = <Widget>[];

    // Add search button if requested
    if (showSearchButton) {
      actionsList.add(
        IconButton(
          onPressed: onSearchPressed,
          icon: const Icon(Icons.search),
          tooltip: 'Search',
        ),
      );
    }

    // Add menu button if requested
    if (showMenuButton) {
      actionsList.add(
        IconButton(
          onPressed: onMenuPressed,
          icon: const Icon(Icons.more_vert),
          tooltip: 'Menu',
        ),
      );
    }

    // Add custom actions
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    return actionsList.isNotEmpty ? actionsList : null;
  }

  double _getVariantHeight() {
    switch (variant) {
      case AppBarVariant.standard:
      case AppBarVariant.centerAligned:
        return kToolbarHeight;
      case AppBarVariant.medium:
        return 112.0;
      case AppBarVariant.large:
        return 152.0;
    }
  }

  @override
  Size get preferredSize {
    double height = toolbarHeight ?? _getVariantHeight();

    // Add bottom widget height if present
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }

    return Size.fromHeight(height);
  }
}

/// App bar variants
enum AppBarVariant {
  /// Standard app bar
  standard,

  /// Large app bar
  large,

  /// Medium app bar
  medium,

  /// Center-aligned app bar
  centerAligned,
}
