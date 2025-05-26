import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators/form_validators.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/text_button.dart';
import '../../../../shared/widgets/forms/custom_text_field.dart';

enum AuthFormMode { signIn, signUp }

class AuthForm extends ConsumerStatefulWidget {
  final AuthFormMode mode;
  final VoidCallback? onToggleMode;
  final Function(String email, String password)? onSubmit;
  final Function(String email, String password, String name)? onSignUp;
  final bool isLoading;
  final String? errorMessage;

  const AuthForm({
    super.key,
    required this.mode,
    this.onToggleMode,
    this.onSubmit,
    this.onSignUp,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    if (widget.mode == AuthFormMode.signIn) {
      widget.onSubmit?.call(email, password);
    } else {
      widget.onSignUp?.call(email, password, name);
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (widget.mode == AuthFormMode.signIn) return null;

    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSignUp = widget.mode == AuthFormMode.signUp;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            isSignUp ? 'Create Account' : 'Welcome Back',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isSignUp
                ? 'Sign up to get started with your account'
                : 'Sign in to your account to continue',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Error Message
          if (widget.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.onErrorContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Name Field (Sign Up only)
          if (isSignUp) ...[
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: const Icon(Icons.person_outline),
              validator: FormValidators.validateFullName,
              enabled: !widget.isLoading,
            ),
            const SizedBox(height: 16),
          ],

          // Email Field
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email address',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),

          // Password Field
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            hint: isSignUp ? 'Create a strong password' : 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline),
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: isSignUp
                ? FormValidators.validatePassword
                : (value) =>
                    value?.isEmpty == true ? 'Password is required' : null,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),

          // Confirm Password Field (Sign Up only)
          if (isSignUp) ...[
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Confirm your password',
              prefixIcon: const Icon(Icons.lock_outline),
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              validator: _validateConfirmPassword,
              enabled: !widget.isLoading,
            ),
            const SizedBox(height: 24),
          ] else ...[
            const SizedBox(height: 8),
          ],

          // Forgot Password (Sign In only)
          if (!isSignUp) ...[
            Align(
              alignment: Alignment.centerRight,
              child: CustomTextButton(
                text: 'Forgot Password?',
                variant: TextButtonVariant.link,
                onPressed: widget.isLoading
                    ? null
                    : () {
                        // TODO: Implement forgot password
                      },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Submit Button
          PrimaryButton(
            onPressed: widget.isLoading ? null : _handleSubmit,
            isLoading: widget.isLoading,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isSignUp ? Icons.person_add : Icons.login),
                const SizedBox(width: 8),
                Text(isSignUp ? 'Create Account' : 'Sign In'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Toggle Mode
          if (widget.onToggleMode != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSignUp
                      ? 'Already have an account? '
                      : "Don't have an account? ",
                  style: theme.textTheme.bodyMedium,
                ),
                CustomTextButton(
                  text: isSignUp ? 'Sign In' : 'Sign Up',
                  variant: TextButtonVariant.link,
                  onPressed: widget.isLoading ? null : widget.onToggleMode,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
