import 'package:flutter/material.dart';

import '../../../../shared/widgets/buttons/secondary_button.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;
  final bool showDivider;

  const SocialAuthButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.isLoading = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Divider
        if (showDivider) ...[
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or continue with',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],

        // Social buttons
        Column(
          children: [
            // Google Sign In
            if (onGooglePressed != null) ...[
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  onPressed: isLoading ? null : onGooglePressed,
                  text: 'Continue with Google',
                  leadingIcon: Icons.g_mobiledata,
                  variant: SecondaryButtonVariant.outlined,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Apple Sign In
            if (onApplePressed != null) ...[
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  onPressed: isLoading ? null : onApplePressed,
                  text: 'Continue with Apple',
                  leadingIcon: Icons.apple,
                  variant: SecondaryButtonVariant.filledTonal,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Facebook Sign In
            if (onFacebookPressed != null) ...[
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  onPressed: isLoading ? null : onFacebookPressed,
                  text: 'Continue with Facebook',
                  leadingIcon: Icons.facebook,
                  variant: SecondaryButtonVariant.filledTonal,
                  backgroundColor: const Color(0xFF1877F2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Simplified social auth buttons for compact layouts
class CompactSocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;

  const CompactSocialAuthButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttons = <Widget>[];

    // Google
    if (onGooglePressed != null) {
      buttons.add(
        Expanded(
          child: SecondaryButton(
            onPressed: isLoading ? null : onGooglePressed,
            text: 'Google',
            leadingIcon: Icons.g_mobiledata,
            variant: SecondaryButtonVariant.outlined,
          ),
        ),
      );
    }

    // Apple
    if (onApplePressed != null) {
      if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 12));
      buttons.add(
        Expanded(
          child: SecondaryButton(
            onPressed: isLoading ? null : onApplePressed,
            text: 'Apple',
            leadingIcon: Icons.apple,
            variant: SecondaryButtonVariant.filledTonal,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
      );
    }

    // Facebook
    if (onFacebookPressed != null) {
      if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 12));
      buttons.add(
        Expanded(
          child: SecondaryButton(
            onPressed: isLoading ? null : onFacebookPressed,
            text: 'Facebook',
            leadingIcon: Icons.facebook,
            variant: SecondaryButtonVariant.filledTonal,
            backgroundColor: const Color(0xFF1877F2),
            foregroundColor: Colors.white,
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(children: buttons),
      ],
    );
  }
}
