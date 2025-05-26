import 'package:flutter/material.dart';

/// Enhanced radio button widget with theming and custom styling
class CustomRadio<T> extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.activeColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.isError = false,
    this.errorText,
    this.helperText,
    this.contentPadding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.labelStyle,
    this.subtitleStyle,
    this.spacing = 8.0,
  });

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final String? label;
  final String? subtitle;
  final bool enabled;
  final Color? activeColor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isError;
  final String? errorText;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle? labelStyle;
  final TextStyle? subtitleStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget radio = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: enabled ? onChanged : null,
      activeColor: activeColor ?? (isError ? colorScheme.error : null),
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autofocus,
    );

    if (label == null && subtitle == null) {
      return radio;
    }

    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: enabled ? () => onChanged?.call(value) : null,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: crossAxisAlignment,
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  radio,
                  SizedBox(width: spacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (label != null)
                          Text(
                            label!,
                            style: labelStyle ??
                                theme.textTheme.bodyMedium?.copyWith(
                                  color: enabled
                                      ? (isError ? colorScheme.error : null)
                                      : colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle!,
                              style: subtitleStyle ??
                                  theme.textTheme.bodySmall?.copyWith(
                                    color: enabled
                                        ? colorScheme.onSurfaceVariant
                                        : colorScheme.onSurface
                                            .withOpacity(0.4),
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (errorText != null || helperText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 40),
              child: Text(
                errorText ?? helperText ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: errorText != null
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Radio list tile with enhanced styling
class CustomRadioListTile<T> extends StatelessWidget {
  const CustomRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.secondary,
    this.isThreeLine = false,
    this.dense,
    this.enabled = true,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.shape,
    this.selectedTileColor,
    this.activeColor,
    this.tileColor,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
    this.selected = false,
    this.isError = false,
    this.errorText,
    this.helperText,
  });

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool isThreeLine;
  final bool? dense;
  final bool enabled;
  final ListTileControlAffinity controlAffinity;
  final ShapeBorder? shape;
  final Color? selectedTileColor;
  final Color? activeColor;
  final Color? tileColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final bool selected;
  final bool isError;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<T>(
          value: value,
          groupValue: groupValue,
          onChanged: enabled ? onChanged : null,
          title: title,
          subtitle: subtitle,
          secondary: secondary,
          isThreeLine: isThreeLine,
          dense: dense,
          controlAffinity: controlAffinity,
          shape: shape,
          selectedTileColor: selectedTileColor,
          activeColor: activeColor ?? (isError ? colorScheme.error : null),
          tileColor: tileColor,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus,
          contentPadding: contentPadding,
          selected: selected,
        ),
        if (errorText != null || helperText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text(
              errorText ?? helperText ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: errorText != null
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

/// Radio group for single selection
class RadioGroup<T> extends StatelessWidget {
  const RadioGroup({
    super.key,
    required this.items,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.direction = Axis.vertical,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.enabled = true,
    this.itemBuilder,
    this.validator,
    this.errorText,
    this.helperText,
    this.contentPadding,
  });

  final List<T> items;
  final T? groupValue;
  final void Function(T?) onChanged;
  final String? title;
  final Axis direction;
  final double spacing;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final bool enabled;
  final Widget Function(BuildContext, T, bool)? itemBuilder;
  final String? Function(T?)? validator;
  final String? errorText;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: FormField<T>(
        initialValue: groupValue,
        validator: validator,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    title!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: field.hasError ? colorScheme.error : null,
                    ),
                  ),
                ),
              direction == Axis.vertical
                  ? Column(
                      children: items
                          .map((item) => _buildRadioItem(
                                context,
                                item,
                                field.hasError,
                              ))
                          .toList(),
                    )
                  : Wrap(
                      direction: direction,
                      spacing: spacing,
                      runSpacing: runSpacing,
                      crossAxisAlignment: crossAxisAlignment,
                      children: items
                          .map((item) => _buildRadioItem(
                                context,
                                item,
                                field.hasError,
                              ))
                          .toList(),
                    ),
              if (field.hasError || helperText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    field.errorText ?? helperText ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: field.hasError
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRadioItem(BuildContext context, T item, bool hasError) {
    final isSelected = groupValue == item;

    if (itemBuilder != null) {
      return GestureDetector(
        onTap: enabled ? () => onChanged(item) : null,
        child: itemBuilder!(context, item, isSelected),
      );
    }

    return CustomRadio<T>(
      value: item,
      groupValue: groupValue,
      onChanged: enabled ? onChanged : null,
      label: item.toString(),
      isError: hasError,
      enabled: enabled,
    );
  }
}

/// Radio button with custom styling options
class StyledRadio<T> extends StatelessWidget {
  const StyledRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = 24.0,
    this.innerSize = 12.0,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.disabledColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enabled = true,
  });

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final double size;
  final double innerSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? borderColor;
  final Color? disabledColor;
  final Duration animationDuration;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = groupValue == value;

    final effectiveActiveColor = activeColor ?? colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ?? Colors.transparent;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;
    final effectiveDisabledColor =
        disabledColor ?? colorScheme.onSurface.withOpacity(0.38);

    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(value) : null,
      child: AnimatedContainer(
        duration: animationDuration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled
              ? effectiveInactiveColor
              : effectiveDisabledColor.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? (isSelected ? effectiveActiveColor : effectiveBorderColor)
                : effectiveDisabledColor,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: AnimatedContainer(
                  duration: animationDuration,
                  width: innerSize,
                  height: innerSize,
                  decoration: BoxDecoration(
                    color:
                        enabled ? effectiveActiveColor : effectiveDisabledColor,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

/// Radio option model for complex objects
class RadioOption<T> {
  const RadioOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final Widget? icon;
  final bool enabled;
}

/// Radio group for complex objects with custom display
class ObjectRadioGroup<T> extends StatelessWidget {
  const ObjectRadioGroup({
    super.key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.direction = Axis.vertical,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.enabled = true,
    this.validator,
    this.errorText,
    this.helperText,
    this.contentPadding,
  });

  final List<RadioOption<T>> options;
  final T? groupValue;
  final void Function(T?) onChanged;
  final String? title;
  final Axis direction;
  final double spacing;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final bool enabled;
  final String? Function(T?)? validator;
  final String? errorText;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: FormField<T>(
        initialValue: groupValue,
        validator: validator,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    title!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: field.hasError ? colorScheme.error : null,
                    ),
                  ),
                ),
              direction == Axis.vertical
                  ? Column(
                      children: options
                          .map((option) => _buildRadioOption(
                                context,
                                option,
                                field.hasError,
                              ))
                          .toList(),
                    )
                  : Wrap(
                      direction: direction,
                      spacing: spacing,
                      runSpacing: runSpacing,
                      crossAxisAlignment: crossAxisAlignment,
                      children: options
                          .map((option) => _buildRadioOption(
                                context,
                                option,
                                field.hasError,
                              ))
                          .toList(),
                    ),
              if (field.hasError || helperText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    field.errorText ?? helperText ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: field.hasError
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRadioOption(
      BuildContext context, RadioOption<T> option, bool hasError) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = groupValue == option.value;

    return InkWell(
      onTap: enabled && option.enabled ? () => onChanged(option.value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Radio<T>(
              value: option.value,
              groupValue: groupValue,
              onChanged: enabled && option.enabled ? onChanged : null,
              activeColor: hasError ? colorScheme.error : null,
            ),
            const SizedBox(width: 8),
            if (option.icon != null) ...[
              option.icon!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: enabled && option.enabled
                          ? (hasError ? colorScheme.error : null)
                          : colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  if (option.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        option.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: enabled && option.enabled
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Segmented radio button group
class SegmentedRadioGroup<T> extends StatelessWidget {
  const SegmentedRadioGroup({
    super.key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.enabled = true,
    this.borderRadius = 8.0,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.borderColor,
    this.height = 48.0,
    this.validator,
    this.errorText,
    this.helperText,
    this.contentPadding,
  });

  final List<RadioOption<T>> options;
  final T? groupValue;
  final void Function(T?) onChanged;
  final bool enabled;
  final double borderRadius;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? borderColor;
  final double height;
  final String? Function(T?)? validator;
  final String? errorText;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveSelectedColor = selectedColor ?? colorScheme.primary;
    final effectiveUnselectedColor = unselectedColor ?? colorScheme.surface;
    final effectiveSelectedTextColor =
        selectedTextColor ?? colorScheme.onPrimary;
    final effectiveUnselectedTextColor =
        unselectedTextColor ?? colorScheme.onSurface;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;

    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: FormField<T>(
        initialValue: groupValue,
        validator: validator,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: field.hasError
                        ? colorScheme.error
                        : effectiveBorderColor,
                  ),
                ),
                child: Row(
                  children: options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = groupValue == option.value;
                    final isFirst = index == 0;
                    final isLast = index == options.length - 1;

                    return Expanded(
                      child: GestureDetector(
                        onTap: enabled && option.enabled
                            ? () => onChanged(option.value)
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? effectiveSelectedColor
                                : effectiveUnselectedColor,
                            borderRadius: BorderRadius.only(
                              topLeft: isFirst
                                  ? Radius.circular(borderRadius - 1)
                                  : Radius.zero,
                              bottomLeft: isFirst
                                  ? Radius.circular(borderRadius - 1)
                                  : Radius.zero,
                              topRight: isLast
                                  ? Radius.circular(borderRadius - 1)
                                  : Radius.zero,
                              bottomRight: isLast
                                  ? Radius.circular(borderRadius - 1)
                                  : Radius.zero,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (option.icon != null) ...[
                                  option.icon!,
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  option.label,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isSelected
                                        ? effectiveSelectedTextColor
                                        : effectiveUnselectedTextColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (field.hasError || helperText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    field.errorText ?? helperText ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: field.hasError
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
