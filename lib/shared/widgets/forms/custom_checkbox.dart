import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Enhanced checkbox widget with theming and custom styling
class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.tristate = false,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
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

  final bool? value;
  final void Function(bool?)? onChanged;
  final String? label;
  final String? subtitle;
  final bool enabled;
  final bool tristate;
  final Color? activeColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;
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

    Widget checkbox = Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      tristate: tristate,
      activeColor: activeColor ?? (isError ? colorScheme.error : null),
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autofocus,
      shape: shape,
      side: side ?? (isError ? BorderSide(color: colorScheme.error) : null),
    );

    if (label == null && subtitle == null) {
      return checkbox;
    }

    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: enabled ? () => onChanged?.call(!(value ?? false)) : null,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: crossAxisAlignment,
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  checkbox,
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

/// Checkbox list tile with enhanced styling
class CustomCheckboxListTile extends StatelessWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.secondary,
    this.isThreeLine = false,
    this.dense,
    this.enabled = true,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.tristate = false,
    this.shape,
    this.selectedTileColor,
    this.checkColor,
    this.activeColor,
    this.tileColor,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
    this.selected = false,
    this.checkboxShape,
    this.side,
    this.isError = false,
    this.errorText,
    this.helperText,
  });

  final bool? value;
  final void Function(bool?)? onChanged;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool isThreeLine;
  final bool? dense;
  final bool enabled;
  final ListTileControlAffinity controlAffinity;
  final bool tristate;
  final ShapeBorder? shape;
  final Color? selectedTileColor;
  final Color? checkColor;
  final Color? activeColor;
  final Color? tileColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final bool selected;
  final OutlinedBorder? checkboxShape;
  final BorderSide? side;
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
        CheckboxListTile(
          value: value,
          onChanged: enabled ? onChanged : null,
          title: title,
          subtitle: subtitle,
          secondary: secondary,
          isThreeLine: isThreeLine,
          dense: dense,
          controlAffinity: controlAffinity,
          tristate: tristate,
          shape: shape,
          selectedTileColor: selectedTileColor,
          checkColor: checkColor,
          activeColor: activeColor ?? (isError ? colorScheme.error : null),
          tileColor: tileColor,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus,
          contentPadding: contentPadding,
          selected: selected,
          checkboxShape: checkboxShape,
          side: side ?? (isError ? BorderSide(color: colorScheme.error) : null),
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

/// Checkbox group for multiple selections
class CheckboxGroup<T> extends StatelessWidget {
  const CheckboxGroup({
    super.key,
    required this.items,
    required this.selectedValues,
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
  final List<T> selectedValues;
  final void Function(List<T>) onChanged;
  final String? title;
  final Axis direction;
  final double spacing;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final bool enabled;
  final Widget Function(BuildContext, T, bool)? itemBuilder;
  final String? Function(List<T>?)? validator;
  final String? errorText;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: FormField<List<T>>(
        initialValue: selectedValues,
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
                          .map((item) => _buildCheckboxItem(
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
                          .map((item) => _buildCheckboxItem(
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

  Widget _buildCheckboxItem(BuildContext context, T item, bool hasError) {
    final isSelected = selectedValues.contains(item);

    if (itemBuilder != null) {
      return GestureDetector(
        onTap: enabled ? () => _toggleItem(item) : null,
        child: itemBuilder!(context, item, isSelected),
      );
    }

    return CustomCheckbox(
      value: isSelected,
      onChanged: enabled ? (_) => _toggleItem(item) : null,
      label: item.toString(),
      isError: hasError,
      enabled: enabled,
    );
  }

  void _toggleItem(T item) {
    final newValues = List<T>.from(selectedValues);
    if (newValues.contains(item)) {
      newValues.remove(item);
    } else {
      newValues.add(item);
    }
    onChanged(newValues);
  }
}

/// Checkbox with custom styling options
class StyledCheckbox extends StatelessWidget {
  const StyledCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24.0,
    this.borderRadius = 4.0,
    this.borderWidth = 2.0,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.borderColor,
    this.disabledColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enabled = true,
  });

  final bool value;
  final void Function(bool)? onChanged;
  final double size;
  final double borderRadius;
  final double borderWidth;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? checkColor;
  final Color? borderColor;
  final Color? disabledColor;
  final Duration animationDuration;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveActiveColor = activeColor ?? colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ?? Colors.transparent;
    final effectiveCheckColor = checkColor ?? colorScheme.onPrimary;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;
    final effectiveDisabledColor =
        disabledColor ?? colorScheme.onSurface.withOpacity(0.38);

    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      child: AnimatedContainer(
        duration: animationDuration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled
              ? (value ? effectiveActiveColor : effectiveInactiveColor)
              : effectiveDisabledColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: enabled
                ? (value ? effectiveActiveColor : effectiveBorderColor)
                : effectiveDisabledColor,
            width: borderWidth,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                size: size * 0.7,
                color: enabled ? effectiveCheckColor : Colors.white,
              )
            : null,
      ),
    );
  }
}

/// Agreement checkbox with rich text support
class AgreementCheckbox extends StatelessWidget {
  const AgreementCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.agreementText,
    this.linkTexts = const [],
    this.onLinkTap,
    this.enabled = true,
    this.required = true,
    this.validator,
    this.errorText,
    this.linkStyle,
    this.textStyle,
    this.spacing = 8.0,
  });

  final bool value;
  final void Function(bool) onChanged;
  final String agreementText;
  final List<String> linkTexts;
  final void Function(String)? onLinkTap;
  final bool enabled;
  final bool required;
  final String? Function(bool?)? validator;
  final String? errorText;
  final TextStyle? linkStyle;
  final TextStyle? textStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FormField<bool>(
      initialValue: value,
      validator: validator ?? (required ? _defaultValidator : null),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckbox(
                  value: value,
                  onChanged: enabled ? (val) => onChanged(val ?? false) : null,
                  isError: field.hasError,
                  enabled: enabled,
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: _buildRichText(context, field.hasError),
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 40),
                child: Text(
                  field.errorText ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRichText(BuildContext context, bool hasError) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (linkTexts.isEmpty) {
      return Text(
        agreementText,
        style: textStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: hasError ? colorScheme.error : null,
            ),
      );
    }

    final spans = <TextSpan>[];
    String remainingText = agreementText;

    for (final linkText in linkTexts) {
      final index = remainingText.indexOf(linkText);
      if (index != -1) {
        // Add text before link
        if (index > 0) {
          spans.add(TextSpan(
            text: remainingText.substring(0, index),
            style: textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: hasError ? colorScheme.error : null,
                ),
          ));
        }

        // Add link
        spans.add(TextSpan(
          text: linkText,
          style: linkStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
          recognizer: onLinkTap != null
              ? (TapGestureRecognizer()..onTap = () => onLinkTap!(linkText))
              : null,
        ));

        remainingText = remainingText.substring(index + linkText.length);
      }
    }

    // Add remaining text
    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(
        text: remainingText,
        style: textStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: hasError ? colorScheme.error : null,
            ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  String? _defaultValidator(bool? value) {
    if (value != true) {
      return 'You must agree to continue';
    }
    return null;
  }
}
