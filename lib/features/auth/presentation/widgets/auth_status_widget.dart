import 'package:flutter/material.dart';

import '../../../../shared/widgets/cards/info_card.dart';
import '../../../../shared/widgets/loading/custom_loading_indicator.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthStatusWidget extends StatelessWidget {
  final AuthStatus status;
  final String? errorMessage;
  final String? userName;
  final String? userEmail;
  final VoidCallback? onRetry;
  final VoidCallback? onSignOut;
  final Widget? child;

  const AuthStatusWidget({
    super.key,
    required this.status,
    this.errorMessage,
    this.userName,
    this.userEmail,
    this.onRetry,
    this.onSignOut,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (status) {
      case AuthStatus.initial:
        return child ?? const SizedBox.shrink();

      case AuthStatus.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomLoadingIndicator(
                variant: LoadingVariant.circular,
                size: LoadingSize.large,
              ),
              const SizedBox(height: 16),
              Text(
                'Authenticating...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );

      case AuthStatus.authenticated:
        if (child != null) return child!;

        return InfoCard(
          variant: InfoCardVariant.elevated,
          title: 'Welcome back!',
          subtitle: userName != null
              ? 'Hello, $userName'
              : userEmail != null
                  ? 'Hello, $userEmail'
                  : 'You are signed in',
          icon: Icons.check_circle,
          actions: onSignOut != null
              ? [
                  TextButton(
                    onPressed: onSignOut,
                    child: const Text('Sign Out'),
                  ),
                ]
              : null,
        );

      case AuthStatus.unauthenticated:
        if (child != null) return child!;

        return InfoCard(
          variant: InfoCardVariant.outlined,
          title: 'Not signed in',
          subtitle: 'Please sign in to continue',
          icon: Icons.person_outline,
        );

      case AuthStatus.error:
        return InfoCard(
          variant: InfoCardVariant.filled,
          title: 'Authentication Error',
          subtitle: errorMessage ?? 'An error occurred during authentication',
          icon: Icons.error_outline,
          backgroundColor: theme.colorScheme.errorContainer,
          actions: onRetry != null
              ? [
                  TextButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                ]
              : null,
        );
    }
  }
}

/// Compact auth status indicator for app bars or small spaces
class CompactAuthStatusIndicator extends StatelessWidget {
  final AuthStatus status;
  final String? userName;
  final String? userEmail;
  final VoidCallback? onTap;

  const CompactAuthStatusIndicator({
    super.key,
    required this.status,
    this.userName,
    this.userEmail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget icon;
    Color color;
    String tooltip;

    switch (status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        icon = SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        );
        color = theme.colorScheme.primary;
        tooltip = 'Authenticating...';
        break;

      case AuthStatus.authenticated:
        icon = const Icon(Icons.account_circle, size: 24);
        color = theme.colorScheme.primary;
        tooltip = userName ?? userEmail ?? 'Signed in';
        break;

      case AuthStatus.unauthenticated:
        icon = const Icon(Icons.person_outline, size: 24);
        color = theme.colorScheme.onSurfaceVariant;
        tooltip = 'Not signed in';
        break;

      case AuthStatus.error:
        icon = const Icon(Icons.error_outline, size: 24);
        color = theme.colorScheme.error;
        tooltip = 'Authentication error';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: IconTheme(
            data: IconThemeData(color: color),
            child: icon,
          ),
        ),
      ),
    );
  }
}

/// Auth status banner for displaying at the top of screens
class AuthStatusBanner extends StatelessWidget {
  final AuthStatus status;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const AuthStatusBanner({
    super.key,
    required this.status,
    this.errorMessage,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Only show banner for error states
    if (status != AuthStatus.error) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.error.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authentication Error',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onErrorContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: const Text('Retry'),
            ),
          ],
          if (onDismiss != null) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close),
              iconSize: 18,
              color: theme.colorScheme.onErrorContainer,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
