import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/ui_constants.dart';

/// Custom bottom navigation bar with Material 3 design and enhanced functionality
class CustomBottomNavBar extends StatelessWidget {
  /// Navigation items for the bottom bar
  final List<CustomBottomNavItem> items;

  /// Currently selected index
  final int currentIndex;

  /// Callback when an item is tapped
  final ValueChanged<int>? onTap;

  /// Navigation bar type
  final CustomBottomNavType type;

  /// Background color override
  final Color? backgroundColor;

  /// Selected item color override
  final Color? selectedItemColor;

  /// Unselected item color override
  final Color? unselectedItemColor;

  /// Whether to show labels
  final bool showLabels;

  /// Whether to show unselected labels
  final bool showUnselectedLabels;

  /// Icon size
  final double iconSize;

  /// Selected icon size
  final double? selectedIconSize;

  /// Label text style
  final TextStyle? labelStyle;

  /// Selected label text style
  final TextStyle? selectedLabelStyle;

  /// Elevation
  final double elevation;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  /// Animation duration
  final Duration animationDuration;

  /// Custom height
  final double? height;

  /// Margin around the navigation bar
  final EdgeInsetsGeometry? margin;

  /// Border radius for floating type
  final BorderRadius? borderRadius;

  /// Whether to use safe area
  final bool useSafeArea;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.type = CustomBottomNavType.fixed,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showLabels = true,
    this.showUnselectedLabels = true,
    this.iconSize = 24.0,
    this.selectedIconSize,
    this.labelStyle,
    this.selectedLabelStyle,
    this.elevation = 8.0,
    this.enableHapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.height,
    this.margin,
    this.borderRadius,
    this.useSafeArea = true,
  }) : assert(items.length >= 2 && items.length <= 5,
            'Bottom navigation must have between 2 and 5 items');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ??
        (type == CustomBottomNavType.floating
            ? colorScheme.surfaceContainer
            : colorScheme.surface);

    final effectiveSelectedColor = selectedItemColor ?? colorScheme.primary;
    final effectiveUnselectedColor =
        unselectedItemColor ?? colorScheme.onSurfaceVariant;

    Widget navBar = _buildNavigationBar(
      context,
      theme,
      effectiveBackgroundColor,
      effectiveSelectedColor,
      effectiveUnselectedColor,
    );

    if (type == CustomBottomNavType.floating) {
      navBar = Container(
        margin: margin ?? const EdgeInsets.all(UIConstants.spacingMd),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius:
              borderRadius ?? BorderRadius.circular(UIConstants.radiusLg),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: elevation,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              borderRadius ?? BorderRadius.circular(UIConstants.radiusLg),
          child: navBar,
        ),
      );
    }

    if (useSafeArea) {
      navBar = SafeArea(child: navBar);
    }

    return navBar;
  }

  Widget _buildNavigationBar(
    BuildContext context,
    ThemeData theme,
    Color backgroundColor,
    Color selectedColor,
    Color unselectedColor,
  ) {
    switch (type) {
      case CustomBottomNavType.fixed:
      case CustomBottomNavType.floating:
        return _buildFixedNavBar(
          context,
          theme,
          backgroundColor,
          selectedColor,
          unselectedColor,
        );
      case CustomBottomNavType.shifting:
        return _buildShiftingNavBar(
          context,
          theme,
          backgroundColor,
          selectedColor,
          unselectedColor,
        );
    }
  }

  Widget _buildFixedNavBar(
    BuildContext context,
    ThemeData theme,
    Color backgroundColor,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return Container(
      height: height ?? (showLabels ? 80.0 : 60.0),
      color: type == CustomBottomNavType.floating ? null : backgroundColor,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;

          return Expanded(
            child: _buildNavItem(
              context,
              item,
              isSelected,
              selectedColor,
              unselectedColor,
              index,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShiftingNavBar(
    BuildContext context,
    ThemeData theme,
    Color backgroundColor,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return Container(
      height: height ?? 80.0,
      color: backgroundColor,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;

          return Expanded(
            flex: isSelected ? 2 : 1,
            child: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeInOut,
              child: _buildNavItem(
                context,
                item,
                isSelected,
                selectedColor,
                unselectedColor,
                index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    CustomBottomNavItem item,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    int index,
  ) {
    final effectiveIconSize =
        isSelected ? (selectedIconSize ?? iconSize) : iconSize;

    final itemColor = isSelected ? selectedColor : unselectedColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (enableHapticFeedback) {
            HapticFeedback.selectionClick();
          }
          onTap?.call(index);
        },
        borderRadius: BorderRadius.circular(UIConstants.radiusMd),
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingSm,
            vertical: UIConstants.spacingXs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(UIConstants.spacingXs),
                    decoration:
                        isSelected && type == CustomBottomNavType.shifting
                            ? BoxDecoration(
                                color: selectedColor.withOpacity(0.12),
                                borderRadius:
                                    BorderRadius.circular(UIConstants.radiusSm),
                              )
                            : null,
                    child: Icon(
                      isSelected ? item.selectedIcon ?? item.icon : item.icon,
                      size: effectiveIconSize,
                      color: itemColor,
                    ),
                  ),
                  // Badge
                  if (item.badge != null)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: item.badge!,
                    ),
                ],
              ),

              // Label
              if (showLabels && (showUnselectedLabels || isSelected))
                AnimatedContainer(
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(top: UIConstants.spacingXs),
                  child: Text(
                    item.label,
                    style: (isSelected ? selectedLabelStyle : labelStyle) ??
                        Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: itemColor,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation item for custom bottom navigation bar
class CustomBottomNavItem {
  /// Icon for the navigation item
  final IconData icon;

  /// Selected icon (optional, uses icon if not provided)
  final IconData? selectedIcon;

  /// Label text
  final String label;

  /// Badge widget (optional)
  final Widget? badge;

  /// Tooltip text (optional)
  final String? tooltip;

  const CustomBottomNavItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badge,
    this.tooltip,
  });
}

/// Badge widget for navigation items
class NavBadge extends StatelessWidget {
  /// Badge text or count
  final String? text;

  /// Badge color
  final Color? color;

  /// Text color
  final Color? textColor;

  /// Whether to show as a dot (no text)
  final bool isDot;

  /// Custom size
  final double? size;

  const NavBadge({
    super.key,
    this.text,
    this.color,
    this.textColor,
    this.isDot = false,
    this.size,
  });

  /// Creates a dot badge
  const NavBadge.dot({
    super.key,
    this.color,
    this.size,
  })  : text = null,
        textColor = null,
        isDot = true;

  /// Creates a count badge
  const NavBadge.count({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.size,
  }) : isDot = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final badgeColor = color ?? colorScheme.error;
    final badgeTextColor = textColor ?? colorScheme.onError;
    final badgeSize = size ?? (isDot ? 8.0 : 16.0);

    if (isDot) {
      return Container(
        width: badgeSize,
        height: badgeSize,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        minWidth: badgeSize,
        minHeight: badgeSize,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingXs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(badgeSize / 2),
      ),
      child: Text(
        text ?? '',
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeTextColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Types of bottom navigation bar
enum CustomBottomNavType {
  /// Fixed navigation bar with equal spacing
  fixed,

  /// Shifting navigation bar with animated sizing
  shifting,

  /// Floating navigation bar with rounded corners
  floating,
}
