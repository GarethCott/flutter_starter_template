import 'package:flutter/material.dart';

/// Enhanced dropdown widget with search functionality and theming
class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
    this.required = false,
    this.validator,
    this.itemBuilder,
    this.displayStringForItem,
    this.searchable = false,
    this.searchHint = 'Search...',
    this.noItemsFoundText = 'No items found',
    this.maxHeight = 300,
    this.borderRadius,
    this.fillColor,
    this.contentPadding,
  });

  final List<T> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool enabled;
  final bool required;
  final String? Function(T?)? validator;
  final Widget Function(BuildContext, T)? itemBuilder;
  final String Function(T)? displayStringForItem;
  final bool searchable;
  final String searchHint;
  final String noItemsFoundText;
  final double maxHeight;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<T> _filteredItems = [];
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isOpen) {
      _closeDropdown();
    }
  }

  String _getDisplayString(T? item) {
    if (item == null) return '';
    if (widget.displayStringForItem != null) {
      return widget.displayStringForItem!(item);
    }
    return item.toString();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final displayString = _getDisplayString(item).toLowerCase();
          return displayString.contains(query.toLowerCase());
        }).toList();
      }
    });
    _updateOverlay();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;

    setState(() {
      _isOpen = true;
      _filteredItems = widget.items;
      _searchController.clear();
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _focusNode.requestFocus();
  }

  void _closeDropdown() {
    if (!_isOpen) return;

    setState(() {
      _isOpen = false;
    });

    _removeOverlay();
    _focusNode.unfocus();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _selectItem(T item) {
    widget.onChanged?.call(item);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 8,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            child: Container(
              constraints: BoxConstraints(maxHeight: widget.maxHeight),
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.searchable) _buildSearchField(),
                  Flexible(child: _buildItemsList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          isDense: true,
        ),
        onChanged: _filterItems,
      ),
    );
  }

  Widget _buildItemsList() {
    if (_filteredItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          widget.noItemsFoundText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = widget.value == item;

        return InkWell(
          onTap: () => _selectItem(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
            ),
            child: widget.itemBuilder?.call(context, item) ??
                Text(
                  _getDisplayString(item),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build label with required indicator
    Widget? label;
    if (widget.label != null) {
      label = widget.required
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.label!),
                Text(
                  ' *',
                  style: TextStyle(color: colorScheme.error),
                ),
              ],
            )
          : Text(widget.label!);
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: FormField<T>(
        initialValue: widget.value,
        validator: widget.validator,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: label,
                ),
              GestureDetector(
                onTap: widget.enabled ? _toggleDropdown : null,
                child: Container(
                  padding: widget.contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.fillColor ??
                        (widget.enabled
                            ? colorScheme.surfaceContainerHighest
                                .withOpacity(0.3)
                            : colorScheme.surfaceContainerHighest
                                .withOpacity(0.1)),
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(12),
                    border: Border.all(
                      color: field.hasError
                          ? colorScheme.error
                          : _isOpen
                              ? colorScheme.primary
                              : colorScheme.outline,
                      width: _isOpen ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefixIcon != null) ...[
                        widget.prefixIcon!,
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          widget.value != null
                              ? _getDisplayString(widget.value)
                              : widget.hint ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: widget.value != null
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Icon(
                        _isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: widget.enabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.helperText != null || field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 16),
                  child: Text(
                    field.errorText ?? widget.helperText ?? '',
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

/// Simple dropdown for string values
class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
    this.required = false,
    this.validator,
    this.searchable = false,
  });

  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool enabled;
  final bool required;
  final String? Function(String?)? validator;
  final bool searchable;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      items: items,
      value: value,
      onChanged: onChanged,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      enabled: enabled,
      required: required,
      validator: validator,
      searchable: searchable,
    );
  }
}

/// Dropdown for key-value pairs
class KeyValueDropdown<T> extends StatelessWidget {
  const KeyValueDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
    this.required = false,
    this.validator,
    this.searchable = false,
  });

  final Map<T, String> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool enabled;
  final bool required;
  final String? Function(T?)? validator;
  final bool searchable;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>(
      items: items.keys.toList(),
      value: value,
      onChanged: onChanged,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      enabled: enabled,
      required: required,
      validator: validator,
      searchable: searchable,
      displayStringForItem: (item) => items[item] ?? '',
    );
  }
}

/// Dropdown item model for complex objects
class DropdownItem<T> {
  const DropdownItem({
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

/// Dropdown for complex objects with custom display
class ObjectDropdown<T> extends StatelessWidget {
  const ObjectDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
    this.required = false,
    this.validator,
    this.searchable = false,
  });

  final List<DropdownItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool enabled;
  final bool required;
  final String? Function(T?)? validator;
  final bool searchable;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<DropdownItem<T>>(
      items: items,
      value: items.where((item) => item.value == value).firstOrNull,
      onChanged: (item) => onChanged?.call(item?.value),
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      enabled: enabled,
      required: required,
      validator: validator != null ? (item) => validator!(item?.value) : null,
      searchable: searchable,
      displayStringForItem: (item) => item.label,
      itemBuilder: (context, item) {
        return Row(
          children: [
            if (item.icon != null) ...[
              item.icon!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: item.enabled
                              ? null
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withOpacity(0.5),
                        ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
