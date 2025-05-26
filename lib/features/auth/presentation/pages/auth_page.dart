import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_status_widget.dart';
import '../widgets/social_auth_buttons.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  AuthFormMode _formMode = AuthFormMode.signIn;

  void _toggleFormMode() {
    setState(() {
      _formMode = _formMode == AuthFormMode.signIn
          ? AuthFormMode.signUp
          : AuthFormMode.signIn;
    });
  }

  void _handleSignIn(String email, String password) {
    ref.read(authActionsProvider).signIn(email, password);
  }

  void _handleSignUp(String email, String password, String name) {
    ref.read(authActionsProvider).signUp(email, password, name);
  }

  void _handleSocialAuth(String provider) {
    // TODO: Implement social authentication
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider authentication not implemented yet'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleQuickLogin(String email, String password) {
    ref.read(authActionsProvider).signIn(email, password);
  }

  Widget _buildDemoCredentialsSection(ThemeData theme, bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.science_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Demo Credentials',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Try the app with these demo accounts:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickLoginButton(
            theme: theme,
            title: 'Admin User',
            email: 'admin@example.com',
            password: 'admin123',
            description: 'Full admin access',
            icon: Icons.admin_panel_settings,
            isLoading: isLoading,
          ),
          const SizedBox(height: 8),
          _buildQuickLoginButton(
            theme: theme,
            title: 'Regular User',
            email: 'user@example.com',
            password: 'user123',
            description: 'Standard user account',
            icon: Icons.person,
            isLoading: isLoading,
          ),
          const SizedBox(height: 8),
          _buildQuickLoginButton(
            theme: theme,
            title: 'Demo User',
            email: 'demo@example.com',
            password: 'demo123',
            description: 'Demo account for testing',
            icon: Icons.play_circle_outline,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLoginButton({
    required ThemeData theme,
    required String title,
    required String email,
    required String password,
    required String description,
    required IconData icon,
    required bool isLoading,
  }) {
    return InkWell(
      onTap: isLoading ? null : () => _handleQuickLogin(email, password),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 16,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: AuthStatusWidget(
          status: authState.status,
          errorMessage: authState.errorMessage,
          userName: authState.user?.name,
          userEmail: authState.user?.email,
          onRetry: () => ref.read(authActionsProvider).clearError(),
          onSignOut: () => ref.read(authActionsProvider).signOut(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo/Branding
                Container(
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.flutter_dash,
                          size: 40,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Flutter Starter',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Demo Credentials Section (only for sign in mode)
                if (_formMode == AuthFormMode.signIn) ...[
                  _buildDemoCredentialsSection(theme, authState.isLoading),
                  const SizedBox(height: 24),
                ],

                // Auth Form
                AuthForm(
                  mode: _formMode,
                  onToggleMode: _toggleFormMode,
                  onSubmit: _handleSignIn,
                  onSignUp: _handleSignUp,
                  isLoading: authState.isLoading,
                  errorMessage: authState.errorMessage,
                ),

                const SizedBox(height: 32),

                // Social Authentication
                SocialAuthButtons(
                  onGooglePressed: () => _handleSocialAuth('Google'),
                  onApplePressed: () => _handleSocialAuth('Apple'),
                  onFacebookPressed: () => _handleSocialAuth('Facebook'),
                  isLoading: authState.isLoading,
                ),

                const SizedBox(height: 32),

                // Terms and Privacy
                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact authentication page for smaller screens or modal presentation
class CompactAuthPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const CompactAuthPage({
    super.key,
    this.onSuccess,
    this.onCancel,
  });

  @override
  ConsumerState<CompactAuthPage> createState() => _CompactAuthPageState();
}

class _CompactAuthPageState extends ConsumerState<CompactAuthPage> {
  AuthFormMode _formMode = AuthFormMode.signIn;

  void _toggleFormMode() {
    setState(() {
      _formMode = _formMode == AuthFormMode.signIn
          ? AuthFormMode.signUp
          : AuthFormMode.signIn;
    });
  }

  void _handleSignIn(String email, String password) {
    ref.read(authActionsProvider).signIn(email, password);
  }

  void _handleSignUp(String email, String password, String name) {
    ref.read(authActionsProvider).signUp(email, password, name);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    // Listen for authentication success
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && widget.onSuccess != null) {
        widget.onSuccess!();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_formMode == AuthFormMode.signIn ? 'Sign In' : 'Sign Up'),
        leading: widget.onCancel != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onCancel,
              )
            : null,
        actions: [
          CompactAuthStatusIndicator(
            status: authState.status,
            userName: authState.user?.name,
            userEmail: authState.user?.email,
            onTap: authState.isAuthenticated
                ? () => ref.read(authActionsProvider).signOut()
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Error Banner
              AuthStatusBanner(
                status: authState.status,
                errorMessage: authState.errorMessage,
                onRetry: () => ref.read(authActionsProvider).clearError(),
              ),

              // Auth Form
              AuthForm(
                mode: _formMode,
                onToggleMode: _toggleFormMode,
                onSubmit: _handleSignIn,
                onSignUp: _handleSignUp,
                isLoading: authState.isLoading,
                errorMessage: null, // Handled by banner
              ),

              const SizedBox(height: 24),

              // Compact Social Authentication
              CompactSocialAuthButtons(
                onGooglePressed: () {
                  // TODO: Implement Google auth
                },
                onApplePressed: () {
                  // TODO: Implement Apple auth
                },
                isLoading: authState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
