import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced text input field with validation and theming
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.style,
    this.decoration,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.isDense,
    this.showCounter = false,
    this.required = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool expands;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextStyle? style;
  final InputDecoration? decoration;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool? isDense;
  final bool showCounter;
  final bool required;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build suffix icon with password toggle if needed
    Widget? suffixIcon = widget.suffixIcon;
    if (widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color:
              _isFocused ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        onPressed: _toggleObscureText,
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      );
    }

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

    // Build decoration
    final decoration = widget.decoration ??
        InputDecoration(
          labelText: widget.label,
          label: label,
          hintText: widget.hint,
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: widget.fillColor ??
              (widget.enabled
                  ? colorScheme.surfaceContainerHighest.withOpacity(0.3)
                  : colorScheme.surfaceContainerHighest.withOpacity(0.1)),
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          isDense: widget.isDense,
          border: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
          ),
          counterText: widget.showCounter ? null : '',
        );

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      expands: widget.expands,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      style: widget.style,
      decoration: decoration,
    );
  }
}

/// Specialized text field for email input
class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    this.controller,
    this.label = 'Email',
    this.hint = 'Enter your email address',
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.required = true,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      enableSuggestions: false,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: validator ?? _defaultEmailValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      required: required,
    );
  }

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return required ? 'Email is required' : null;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }
}

/// Specialized text field for password input
class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.required = true,
    this.showStrengthIndicator = false,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final bool required;
  final bool showStrengthIndicator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: controller,
          label: label,
          hint: hint,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          enableSuggestions: false,
          prefixIcon: const Icon(Icons.lock_outlined),
          validator: validator ?? _defaultPasswordValidator,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enabled: enabled,
          required: required,
        ),
        if (showStrengthIndicator && controller != null)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller!,
            builder: (context, value, child) {
              return _PasswordStrengthIndicator(password: value.text);
            },
          ),
      ],
    );
  }

  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return required ? 'Password is required' : null;
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }
}

/// Password strength indicator widget
class _PasswordStrengthIndicator extends StatelessWidget {
  const _PasswordStrengthIndicator({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength(password);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color strengthColor;
    String strengthText;

    switch (strength) {
      case 0:
        strengthColor = colorScheme.error;
        strengthText = 'Very Weak';
        break;
      case 1:
        strengthColor = colorScheme.error;
        strengthText = 'Weak';
        break;
      case 2:
        strengthColor = Colors.orange;
        strengthText = 'Fair';
        break;
      case 3:
        strengthColor = Colors.yellow.shade700;
        strengthText = 'Good';
        break;
      case 4:
        strengthColor = Colors.green;
        strengthText = 'Strong';
        break;
      default:
        strengthColor = colorScheme.outline;
        strengthText = '';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: strength / 4,
                  backgroundColor: colorScheme.outline.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                strengthText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: strengthColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return (strength / 6 * 4).round().clamp(0, 4);
  }
}

/// Specialized text field for phone number input
class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    this.controller,
    this.label = 'Phone Number',
    this.hint = 'Enter your phone number',
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.required = true,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.phone_outlined),
      validator: validator ?? _defaultPhoneValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      required: required,
    );
  }

  String? _defaultPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return required ? 'Phone number is required' : null;
    }

    // Basic phone number validation (can be customized for specific formats)
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
