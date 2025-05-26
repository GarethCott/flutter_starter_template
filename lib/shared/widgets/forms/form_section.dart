import 'package:flutter/material.dart';

/// Form section widget for organizing form fields with titles and spacing
class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    required this.children,
    this.spacing = 16.0,
    this.titleSpacing = 12.0,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.elevation = 0,
    this.showDivider = false,
    this.dividerColor,
    this.dividerThickness = 1.0,
    this.dividerIndent = 0.0,
    this.dividerEndIndent = 0.0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
    this.required = false,
    this.enabled = true,
    this.collapsible = false,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
  });

  final String? title;
  final String? subtitle;
  final Widget? icon;
  final List<Widget> children;
  final double spacing;
  final double titleSpacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final double elevation;
  final bool showDivider;
  final Color? dividerColor;
  final double dividerThickness;
  final double dividerIndent;
  final double dividerEndIndent;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool required;
  final bool enabled;
  final bool collapsible;
  final bool initiallyExpanded;
  final void Function(bool)? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content = Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (title != null || subtitle != null) _buildHeader(context),
        if (showDivider && (title != null || subtitle != null))
          Padding(
            padding: EdgeInsets.symmetric(vertical: titleSpacing / 2),
            child: Divider(
              color: dividerColor ?? colorScheme.outline.withOpacity(0.3),
              thickness: dividerThickness,
              indent: dividerIndent,
              endIndent: dividerEndIndent,
            ),
          ),
        ...children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < children.length - 1 ? spacing : 0,
            ),
            child: child,
          );
        }),
      ],
    );

    if (collapsible) {
      content = _buildCollapsibleContent(context, content);
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation,
                  offset: Offset(0, elevation / 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: content,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: titleSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title!,
                          style: titleStyle ??
                              theme.textTheme.titleMedium?.copyWith(
                                color: enabled
                                    ? null
                                    : colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (required)
                        Text(
                          ' *',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: titleStyle?.fontSize ??
                                theme.textTheme.titleMedium?.fontSize,
                          ),
                        ),
                    ],
                  ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: subtitleStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
                            color: enabled
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface.withOpacity(0.4),
                          ),
                    ),
                  ),
              ],
            ),
          ),
          if (collapsible)
            Icon(
              initiallyExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleContent(BuildContext context, Widget content) {
    return ExpansionTile(
      title: _buildHeader(context),
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      children: [content],
    );
  }
}

/// Card-based form section with Material Design styling
class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    required this.children,
    this.spacing = 16.0,
    this.titleSpacing = 12.0,
    this.padding,
    this.margin,
    this.elevation = 1,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.clipBehavior = Clip.none,
    this.borderOnForeground = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
    this.required = false,
    this.enabled = true,
  });

  final String? title;
  final String? subtitle;
  final Widget? icon;
  final List<Widget> children;
  final double spacing;
  final double titleSpacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Clip clipBehavior;
  final bool borderOnForeground;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      clipBehavior: clipBehavior,
      borderOnForeground: borderOnForeground,
      child: FormSection(
        title: title,
        subtitle: subtitle,
        icon: icon,
        spacing: spacing,
        titleSpacing: titleSpacing,
        padding: padding ?? const EdgeInsets.all(16),
        crossAxisAlignment: crossAxisAlignment,
        titleStyle: titleStyle,
        subtitleStyle: subtitleStyle,
        required: required,
        enabled: enabled,
        children: children,
      ),
    );
  }
}

/// Outlined form section with border styling
class OutlinedFormSection extends StatelessWidget {
  const OutlinedFormSection({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    required this.children,
    this.spacing = 16.0,
    this.titleSpacing = 12.0,
    this.padding,
    this.margin,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.backgroundColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
    this.required = false,
    this.enabled = true,
  });

  final String? title;
  final String? subtitle;
  final Widget? icon;
  final List<Widget> children;
  final double spacing;
  final double titleSpacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FormSection(
      title: title,
      subtitle: subtitle,
      icon: icon,
      spacing: spacing,
      titleSpacing: titleSpacing,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      border: Border.all(
        color: borderColor ?? colorScheme.outline,
        width: borderWidth,
      ),
      crossAxisAlignment: crossAxisAlignment,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      required: required,
      enabled: enabled,
      children: children,
    );
  }
}

/// Form section with step indicator
class StepFormSection extends StatelessWidget {
  const StepFormSection({
    super.key,
    required this.stepNumber,
    required this.title,
    this.subtitle,
    required this.children,
    this.spacing = 16.0,
    this.titleSpacing = 12.0,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation = 0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
    this.stepStyle,
    this.stepBackgroundColor,
    this.stepTextColor,
    this.stepSize = 32.0,
    this.required = false,
    this.enabled = true,
    this.completed = false,
    this.active = false,
  });

  final int stepNumber;
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final double spacing;
  final double titleSpacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? stepStyle;
  final Color? stepBackgroundColor;
  final Color? stepTextColor;
  final double stepSize;
  final bool required;
  final bool enabled;
  final bool completed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveStepBackgroundColor = stepBackgroundColor ??
        (completed
            ? colorScheme.primary
            : active
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest);

    final effectiveStepTextColor = stepTextColor ??
        (completed
            ? colorScheme.onPrimary
            : active
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant);

    return FormSection(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      elevation: elevation,
      crossAxisAlignment: crossAxisAlignment,
      spacing: spacing,
      titleSpacing: titleSpacing,
      enabled: enabled,
      icon: Container(
        width: stepSize,
        height: stepSize,
        decoration: BoxDecoration(
          color: effectiveStepBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: completed
              ? Icon(
                  Icons.check,
                  size: stepSize * 0.6,
                  color: effectiveStepTextColor,
                )
              : Text(
                  stepNumber.toString(),
                  style: stepStyle ??
                      theme.textTheme.labelLarge?.copyWith(
                        color: effectiveStepTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
        ),
      ),
      title: title,
      subtitle: subtitle,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      required: required,
      children: children,
    );
  }
}

/// Collapsible form section with expansion tile
class CollapsibleFormSection extends StatefulWidget {
  const CollapsibleFormSection({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.children,
    this.spacing = 16.0,
    this.titleSpacing = 12.0,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.elevation = 0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
    this.required = false,
    this.enabled = true,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
    this.expandedBackgroundColor,
    this.collapsedBackgroundColor,
    this.iconColor,
    this.textColor,
    this.collapsedTextColor,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final List<Widget> children;
  final double spacing;
  final double titleSpacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final double elevation;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool required;
  final bool enabled;
  final bool initiallyExpanded;
  final void Function(bool)? onExpansionChanged;
  final Color? expandedBackgroundColor;
  final Color? collapsedBackgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final Color? collapsedTextColor;

  @override
  State<CollapsibleFormSection> createState() => _CollapsibleFormSectionState();
}

class _CollapsibleFormSectionState extends State<CollapsibleFormSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _handleExpansionChanged(bool expanded) {
    setState(() {
      _isExpanded = expanded;
    });
    widget.onExpansionChanged?.call(expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (_isExpanded
                ? widget.expandedBackgroundColor
                : widget.collapsedBackgroundColor),
        borderRadius: widget.borderRadius,
        border: widget.border,
        boxShadow: widget.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: widget.elevation,
                  offset: Offset(0, widget.elevation / 2),
                ),
              ]
            : null,
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: widget.titleStyle ??
                              theme.textTheme.titleMedium?.copyWith(
                                color: _isExpanded
                                    ? widget.textColor
                                    : widget.collapsedTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (widget.required)
                        Text(
                          ' *',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: widget.titleStyle?.fontSize ??
                                theme.textTheme.titleMedium?.fontSize,
                          ),
                        ),
                    ],
                  ),
                  if (widget.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.subtitle!,
                        style: widget.subtitleStyle ??
                            theme.textTheme.bodyMedium?.copyWith(
                              color: _isExpanded
                                  ? widget.textColor?.withOpacity(0.7) ??
                                      colorScheme.onSurfaceVariant
                                  : widget.collapsedTextColor
                                          ?.withOpacity(0.7) ??
                                      colorScheme.onSurface.withOpacity(0.4),
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        initiallyExpanded: widget.initiallyExpanded,
        onExpansionChanged: _handleExpansionChanged,
        iconColor: widget.iconColor,
        collapsedIconColor: widget.iconColor,
        tilePadding: widget.padding ?? const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Column(
            crossAxisAlignment: widget.crossAxisAlignment,
            children: widget.children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index < widget.children.length - 1 ? widget.spacing : 0,
                ),
                child: child,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
