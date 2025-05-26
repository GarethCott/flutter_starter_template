import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/ui_constants.dart';

/// Custom tab bar with Material 3 design and enhanced functionality
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tabs
  final List<CustomTab> tabs;

  /// Tab controller
  final TabController? controller;

  /// Tab bar type
  final CustomTabBarType type;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Tab alignment for scrollable tabs
  final TabAlignment? tabAlignment;

  /// Indicator color
  final Color? indicatorColor;

  /// Indicator weight/thickness
  final double indicatorWeight;

  /// Indicator padding
  final EdgeInsetsGeometry indicatorPadding;

  /// Indicator size
  final TabBarIndicatorSize? indicatorSize;

  /// Custom indicator decoration
  final Decoration? indicator;

  /// Label color
  final Color? labelColor;

  /// Unselected label color
  final Color? unselectedLabelColor;

  /// Label style
  final TextStyle? labelStyle;

  /// Unselected label style
  final TextStyle? unselectedLabelStyle;

  /// Label padding
  final EdgeInsetsGeometry? labelPadding;

  /// Tab padding
  final EdgeInsetsGeometry? padding;

  /// Background color
  final Color? backgroundColor;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  /// Animation duration
  final Duration? animationDuration;

  /// Custom height
  final double? height;

  /// Divider color
  final Color? dividerColor;

  /// Divider height
  final double? dividerHeight;

  /// Tab spacing for scrollable tabs
  final double? tabSpacing;

  /// Minimum tab width
  final double? minTabWidth;

  /// Maximum tab width
  final double? maxTabWidth;

  /// Callback when tab is tapped
  final ValueChanged<int>? onTap;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.type = CustomTabBarType.primary,
    this.isScrollable = false,
    this.tabAlignment,
    this.indicatorColor,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicatorSize,
    this.indicator,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.padding,
    this.backgroundColor,
    this.enableHapticFeedback = true,
    this.animationDuration,
    this.height,
    this.dividerColor,
    this.dividerHeight,
    this.tabSpacing,
    this.minTabWidth,
    this.maxTabWidth,
    this.onTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? _getDefaultHeight());

  double _getDefaultHeight() {
    switch (type) {
      case CustomTabBarType.primary:
        return 48.0;
      case CustomTabBarType.secondary:
        return 40.0;
      case CustomTabBarType.segmented:
        return 40.0;
      case CustomTabBarType.pills:
        return 36.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (type) {
      case CustomTabBarType.primary:
        return _buildPrimaryTabBar(context, theme, colorScheme);
      case CustomTabBarType.secondary:
        return _buildSecondaryTabBar(context, theme, colorScheme);
      case CustomTabBarType.segmented:
        return _buildSegmentedTabBar(context, theme, colorScheme);
      case CustomTabBarType.pills:
        return _buildPillsTabBar(context, theme, colorScheme);
    }
  }

  Widget _buildPrimaryTabBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      color: backgroundColor ?? colorScheme.surface,
      child: Column(
        children: [
          Expanded(
            child: TabBar(
              controller: controller,
              tabs: tabs.map((tab) => _buildTab(tab, context)).toList(),
              isScrollable: isScrollable,
              tabAlignment: tabAlignment,
              indicatorColor: indicatorColor ?? colorScheme.primary,
              indicatorWeight: indicatorWeight,
              indicatorPadding: indicatorPadding,
              indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
              indicator: indicator,
              labelColor: labelColor ?? colorScheme.primary,
              unselectedLabelColor:
                  unselectedLabelColor ?? colorScheme.onSurfaceVariant,
              labelStyle: labelStyle ??
                  theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              unselectedLabelStyle:
                  unselectedLabelStyle ?? theme.textTheme.titleSmall,
              labelPadding: labelPadding,
              padding: padding,
              onTap: (index) {
                if (enableHapticFeedback) {
                  HapticFeedback.selectionClick();
                }
                onTap?.call(index);
              },
            ),
          ),
          if (dividerHeight != null && dividerHeight! > 0)
            Container(
              height: dividerHeight,
              color: dividerColor ?? colorScheme.outlineVariant,
            ),
        ],
      ),
    );
  }

  Widget _buildSecondaryTabBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      color: backgroundColor ?? colorScheme.surface,
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: UIConstants.spacingMd),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => _buildTab(tab, context)).toList(),
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicatorWeight: indicatorWeight,
        indicatorPadding: indicatorPadding,
        indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,
        indicator: indicator ??
            UnderlineTabIndicator(
              borderSide: BorderSide(
                color: indicatorColor ?? colorScheme.primary,
                width: indicatorWeight,
              ),
              borderRadius: BorderRadius.circular(UIConstants.radiusSm),
            ),
        labelColor: labelColor ?? colorScheme.onSurface,
        unselectedLabelColor:
            unselectedLabelColor ?? colorScheme.onSurfaceVariant,
        labelStyle: labelStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
        unselectedLabelStyle:
            unselectedLabelStyle ?? theme.textTheme.bodyMedium,
        labelPadding: labelPadding ??
            const EdgeInsets.symmetric(horizontal: UIConstants.spacingSm),
        onTap: (index) {
          if (enableHapticFeedback) {
            HapticFeedback.selectionClick();
          }
          onTap?.call(index);
        },
      ),
    );
  }

  Widget _buildSegmentedTabBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      color: backgroundColor ?? colorScheme.surface,
      padding: padding ?? const EdgeInsets.all(UIConstants.spacingMd),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(UIConstants.radiusLg),
        ),
        child: TabBar(
          controller: controller,
          tabs: tabs.map((tab) => _buildSegmentedTab(tab, context)).toList(),
          isScrollable: isScrollable,
          tabAlignment: tabAlignment,
          indicator: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(UIConstants.radiusMd),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          indicatorPadding: const EdgeInsets.all(UIConstants.spacingXs),
          labelColor: labelColor ?? colorScheme.onSurface,
          unselectedLabelColor:
              unselectedLabelColor ?? colorScheme.onSurfaceVariant,
          labelStyle: labelStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          unselectedLabelStyle:
              unselectedLabelStyle ?? theme.textTheme.bodyMedium,
          labelPadding: labelPadding,
          dividerColor: Colors.transparent,
          onTap: (index) {
            if (enableHapticFeedback) {
              HapticFeedback.selectionClick();
            }
            onTap?.call(index);
          },
        ),
      ),
    );
  }

  Widget _buildPillsTabBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      color: backgroundColor ?? colorScheme.surface,
      padding: padding ?? const EdgeInsets.all(UIConstants.spacingMd),
      height: height ?? _getDefaultHeight(),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => SizedBox(
          width: tabSpacing ?? UIConstants.spacingSm,
        ),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = controller?.index == index;

          return _buildPillTab(
            tab,
            context,
            theme,
            colorScheme,
            isSelected,
            index,
          );
        },
      ),
    );
  }

  Widget _buildTab(CustomTab tab, BuildContext context) {
    return Tab(
      text: tab.text,
      icon: tab.icon != null ? Icon(tab.icon) : null,
      iconMargin: tab.iconMargin,
      height: tab.height,
      child: tab.child,
    );
  }

  Widget _buildSegmentedTab(CustomTab tab, BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: minTabWidth ?? 0,
        maxWidth: maxTabWidth ?? double.infinity,
      ),
      child: Tab(
        text: tab.text,
        icon: tab.icon != null ? Icon(tab.icon) : null,
        iconMargin: tab.iconMargin ?? const EdgeInsets.only(bottom: 2),
        height: tab.height,
        child: tab.child,
      ),
    );
  }

  Widget _buildPillTab(
    CustomTab tab,
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isSelected,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        if (enableHapticFeedback) {
          HapticFeedback.selectionClick();
        }
        controller?.animateTo(index);
        onTap?.call(index);
      },
      child: AnimatedContainer(
        duration: animationDuration ?? const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        constraints: BoxConstraints(
          minWidth: minTabWidth ?? 60,
          maxWidth: maxTabWidth ?? 120,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.spacingMd,
          vertical: UIConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (indicatorColor ?? colorScheme.primary)
              : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(UIConstants.radiusLg),
          border: isSelected
              ? null
              : Border.all(
                  color: colorScheme.outline.withOpacity(0.5),
                  width: 1,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                size: 16,
                color: isSelected
                    ? (labelColor ?? colorScheme.onPrimary)
                    : (unselectedLabelColor ?? colorScheme.onSurfaceVariant),
              ),
              if (tab.text != null)
                const SizedBox(width: UIConstants.spacingXs),
            ],
            if (tab.text != null)
              Flexible(
                child: Text(
                  tab.text!,
                  style: (isSelected ? labelStyle : unselectedLabelStyle) ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? (labelColor ?? colorScheme.onPrimary)
                            : (unselectedLabelColor ??
                                colorScheme.onSurfaceVariant),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (tab.badge != null) ...[
              const SizedBox(width: UIConstants.spacingXs),
              tab.badge!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom tab item
class CustomTab {
  /// Tab text
  final String? text;

  /// Tab icon
  final IconData? icon;

  /// Icon margin
  final EdgeInsetsGeometry? iconMargin;

  /// Tab height
  final double? height;

  /// Custom child widget
  final Widget? child;

  /// Badge widget
  final Widget? badge;

  const CustomTab({
    this.text,
    this.icon,
    this.iconMargin,
    this.height,
    this.child,
    this.badge,
  }) : assert(
          text != null || icon != null || child != null,
          'Tab must have text, icon, or child',
        );

  /// Creates a text-only tab
  const CustomTab.text(
    this.text, {
    this.height,
    this.badge,
  })  : icon = null,
        iconMargin = null,
        child = null;

  /// Creates an icon-only tab
  const CustomTab.icon(
    this.icon, {
    this.iconMargin,
    this.height,
    this.badge,
  })  : text = null,
        child = null;

  /// Creates a tab with both text and icon
  const CustomTab.textIcon({
    required this.text,
    required this.icon,
    this.iconMargin,
    this.height,
    this.badge,
  }) : child = null;

  /// Creates a custom tab with a widget
  const CustomTab.custom(
    this.child, {
    this.height,
    this.badge,
  })  : text = null,
        icon = null,
        iconMargin = null;
}

/// Badge widget for tabs
class TabBadge extends StatelessWidget {
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

  const TabBadge({
    super.key,
    this.text,
    this.color,
    this.textColor,
    this.isDot = false,
    this.size,
  });

  /// Creates a dot badge
  const TabBadge.dot({
    super.key,
    this.color,
    this.size,
  })  : text = null,
        textColor = null,
        isDot = true;

  /// Creates a count badge
  const TabBadge.count({
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
    final badgeSize = size ?? (isDot ? 6.0 : 14.0);

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
        horizontal: 4,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(badgeSize / 2),
      ),
      child: Text(
        text ?? '',
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeTextColor,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Types of tab bar
enum CustomTabBarType {
  /// Primary tab bar with underline indicator
  primary,

  /// Secondary tab bar with minimal styling
  secondary,

  /// Segmented tab bar with background indicator
  segmented,

  /// Pills tab bar with individual pill-shaped tabs
  pills,
}
