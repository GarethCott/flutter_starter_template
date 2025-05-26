import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// Custom drawer component with Material 3 design
///
/// Features:
/// - Multiple variants (standard, modal, rail)
/// - Header customization
/// - Navigation items with icons and badges
/// - Dividers and sections
/// - User profile integration
/// - Custom styling and colors
/// - Accessibility support
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    this.header,
    this.items = const [],
    this.footer,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.width,
    this.semanticLabel,
    this.child,
  });

  /// Drawer header widget
  final Widget? header;

  /// Navigation items
  final List<DrawerItem> items;

  /// Drawer footer widget
  final Widget? footer;

  /// Background color
  final Color? backgroundColor;

  /// Elevation
  final double? elevation;

  /// Shape
  final ShapeBorder? shape;

  /// Drawer width
  final double? width;

  /// Semantic label
  final String? semanticLabel;

  /// Custom child widget (overrides items)
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget drawerContent;

    if (child != null) {
      drawerContent = child!;
    } else {
      drawerContent = _buildContent(theme, colorScheme);
    }

    Widget drawer = Drawer(
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      width: width,
      child: drawerContent,
    );

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      drawer = Semantics(
        label: semanticLabel,
        child: drawer,
      );
    }

    return drawer;
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    final children = <Widget>[];

    // Add header if provided
    if (header != null) {
      children.add(header!);
    }

    // Add navigation items
    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      if (item is DrawerDivider) {
        children.add(_buildDivider(theme));
      } else if (item is DrawerSection) {
        children.add(_buildSection(item, theme));
      } else if (item is DrawerNavigationItem) {
        children.add(_buildNavigationItem(item, theme, colorScheme));
      }
    }

    // Add footer if provided
    if (footer != null) {
      children.add(const Spacer());
      children.add(footer!);
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return const Divider(
      height: UIConstants.spacingMd,
      thickness: 1,
      indent: UIConstants.spacingMd,
      endIndent: UIConstants.spacingMd,
    );
  }

  Widget _buildSection(DrawerSection section, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        UIConstants.spacingMd,
        UIConstants.spacingMd,
        UIConstants.spacingMd,
        UIConstants.spacingSm,
      ),
      child: Text(
        section.title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    DrawerNavigationItem item,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      leading: item.icon != null
          ? Icon(
              item.icon,
              color: item.isSelected
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurfaceVariant,
            )
          : null,
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: item.badge != null
          ? _buildBadge(item.badge!, colorScheme)
          : item.trailing,
      selected: item.isSelected,
      onTap: item.onTap,
      enabled: item.isEnabled,
      dense: item.isDense,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingMd,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: UIConstants.borderRadiusMd,
      ),
      selectedTileColor: colorScheme.secondaryContainer,
      selectedColor: colorScheme.onSecondaryContainer,
    );
  }

  Widget _buildBadge(DrawerBadge badge, ColorScheme colorScheme) {
    if (badge.count != null && badge.count! > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.spacingSm,
          vertical: UIConstants.spacingXs,
        ),
        decoration: BoxDecoration(
          color: badge.color ?? colorScheme.error,
          borderRadius: UIConstants.borderRadiusXs,
        ),
        constraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        child: Text(
          badge.count! > 99 ? '99+' : badge.count.toString(),
          style: TextStyle(
            color: badge.textColor ?? colorScheme.onError,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (badge.showDot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: badge.color ?? colorScheme.error,
          shape: BoxShape.circle,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Drawer header with user profile
class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    super.key,
    this.accountName,
    this.accountEmail,
    this.currentAccountPicture,
    this.otherAccountsPictures,
    this.onDetailsPressed,
    this.backgroundColor,
    this.decoration,
    this.margin = const EdgeInsets.only(bottom: 8.0),
    this.padding = const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.fastOutSlowIn,
    this.arrowColor,
    this.semanticLabel,
  });

  /// Account name
  final Widget? accountName;

  /// Account email
  final Widget? accountEmail;

  /// Current account picture
  final Widget? currentAccountPicture;

  /// Other accounts pictures
  final List<Widget>? otherAccountsPictures;

  /// Details pressed callback
  final VoidCallback? onDetailsPressed;

  /// Background color
  final Color? backgroundColor;

  /// Decoration
  final Decoration? decoration;

  /// Margin
  final EdgeInsetsGeometry margin;

  /// Padding
  final EdgeInsetsGeometry padding;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Arrow color
  final Color? arrowColor;

  /// Semantic label
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget header = UserAccountsDrawerHeader(
      accountName: accountName,
      accountEmail: accountEmail,
      currentAccountPicture: currentAccountPicture,
      otherAccountsPictures: otherAccountsPictures,
      onDetailsPressed: onDetailsPressed,
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor ?? colorScheme.primaryContainer,
          ),
      margin: margin,
      arrowColor: arrowColor ?? colorScheme.onPrimaryContainer,
    );

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      header = Semantics(
        label: semanticLabel,
        child: header,
      );
    }

    return header;
  }
}

/// Simple drawer header
class SimpleDrawerHeader extends StatelessWidget {
  const SimpleDrawerHeader({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(UIConstants.spacingMd),
    this.height = 120.0,
    this.semanticLabel,
  });

  /// Header title
  final String? title;

  /// Header subtitle
  final String? subtitle;

  /// Leading widget
  final Widget? leading;

  /// Trailing widget
  final Widget? trailing;

  /// Background color
  final Color? backgroundColor;

  /// Padding
  final EdgeInsetsGeometry padding;

  /// Header height
  final double height;

  /// Semantic label
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget header = Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: UIConstants.spacingMd),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: UIConstants.spacingXs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      header = Semantics(
        label: semanticLabel,
        child: header,
      );
    }

    return header;
  }
}

/// Base class for drawer items
abstract class DrawerItem {
  const DrawerItem();
}

/// Navigation item for drawer
class DrawerNavigationItem extends DrawerItem {
  const DrawerNavigationItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.badge,
    this.onTap,
    this.isSelected = false,
    this.isEnabled = true,
    this.isDense = false,
  });

  /// Item title
  final String title;

  /// Item subtitle
  final String? subtitle;

  /// Item icon
  final IconData? icon;

  /// Trailing widget
  final Widget? trailing;

  /// Badge
  final DrawerBadge? badge;

  /// Tap callback
  final VoidCallback? onTap;

  /// Selected state
  final bool isSelected;

  /// Enabled state
  final bool isEnabled;

  /// Dense layout
  final bool isDense;
}

/// Section header for drawer
class DrawerSection extends DrawerItem {
  const DrawerSection({
    required this.title,
  });

  /// Section title
  final String title;
}

/// Divider for drawer
class DrawerDivider extends DrawerItem {
  const DrawerDivider();
}

/// Badge for drawer items
class DrawerBadge {
  const DrawerBadge({
    this.count,
    this.showDot = false,
    this.color,
    this.textColor,
  });

  /// Badge count
  final int? count;

  /// Show dot indicator
  final bool showDot;

  /// Badge color
  final Color? color;

  /// Text color
  final Color? textColor;
}

/// Navigation rail for larger screens
class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.extended = false,
    this.leading,
    this.trailing,
    this.labelType,
    this.groupAlignment = -1.0,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedLabelTextStyle,
    this.unselectedLabelTextStyle,
    this.useIndicator = true,
    this.indicatorColor,
    this.indicatorShape,
    this.minWidth = 72.0,
    this.minExtendedWidth = 256.0,
    this.semanticLabel,
  });

  /// Navigation destinations
  final List<NavigationRailDestination> destinations;

  /// Selected index
  final int selectedIndex;

  /// Destination selected callback
  final ValueChanged<int>? onDestinationSelected;

  /// Background color
  final Color? backgroundColor;

  /// Elevation
  final double? elevation;

  /// Extended state
  final bool extended;

  /// Leading widget
  final Widget? leading;

  /// Trailing widget
  final Widget? trailing;

  /// Label type
  final NavigationRailLabelType? labelType;

  /// Group alignment
  final double groupAlignment;

  /// Selected icon theme
  final IconThemeData? selectedIconTheme;

  /// Unselected icon theme
  final IconThemeData? unselectedIconTheme;

  /// Selected label text style
  final TextStyle? selectedLabelTextStyle;

  /// Unselected label text style
  final TextStyle? unselectedLabelTextStyle;

  /// Use indicator
  final bool useIndicator;

  /// Indicator color
  final Color? indicatorColor;

  /// Indicator shape
  final ShapeBorder? indicatorShape;

  /// Minimum width
  final double minWidth;

  /// Minimum extended width
  final double minExtendedWidth;

  /// Semantic label
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget rail = NavigationRail(
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor,
      elevation: elevation,
      extended: extended,
      leading: leading,
      trailing: trailing,
      labelType: labelType,
      groupAlignment: groupAlignment,
      selectedIconTheme: selectedIconTheme,
      unselectedIconTheme: unselectedIconTheme,
      selectedLabelTextStyle: selectedLabelTextStyle,
      unselectedLabelTextStyle: unselectedLabelTextStyle,
      useIndicator: useIndicator,
      indicatorColor: indicatorColor,
      indicatorShape: indicatorShape,
      minWidth: minWidth,
      minExtendedWidth: minExtendedWidth,
    );

    // Wrap with semantics if provided
    if (semanticLabel != null) {
      rail = Semantics(
        label: semanticLabel,
        child: rail,
      );
    }

    return rail;
  }
}
