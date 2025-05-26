import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/auth_token.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart'
    as feature_auth;
import '../../features/auth/presentation/widgets/auth_status_widget.dart';

/// Global authentication state that wraps the feature auth provider
/// This provides a consistent interface for the entire app
class GlobalAuthState {
  final AuthStatus status;
  final User? user;
  final AuthToken? token;
  final String? errorMessage;
  final DateTime lastUpdated;

  const GlobalAuthState({
    required this.status,
    this.user,
    this.token,
    this.errorMessage,
    required this.lastUpdated,
  });

  GlobalAuthState copyWith({
    AuthStatus? status,
    User? user,
    AuthToken? token,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return GlobalAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Whether the user is authenticated
  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  /// Whether authentication is in progress
  bool get isLoading => status == AuthStatus.loading;

  /// Whether there's an authentication error
  bool get hasError => status == AuthStatus.error;

  /// Whether the user is unauthenticated
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// Get user ID if authenticated
  String? get userId => user?.id;

  /// Get user email if authenticated
  String? get userEmail => user?.email;

  /// Get user name if authenticated
  String? get userName => user?.name;

  /// Check if user email is verified
  bool get isEmailVerified => user?.isEmailVerified ?? false;

  /// Check if token is expired
  bool get isTokenExpired {
    if (token == null) return true;
    return DateTime.now().isAfter(token!.expiresAt);
  }

  /// Check if token needs refresh (expires within 5 minutes)
  bool get needsTokenRefresh {
    if (token == null) return false;
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(token!.expiresAt);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GlobalAuthState &&
        other.status == status &&
        other.user == user &&
        other.token == token &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, user, token, errorMessage);

  @override
  String toString() {
    return 'GlobalAuthState(status: $status, user: ${user?.email}, hasToken: ${token != null})';
  }
}

/// Global auth provider that wraps the feature auth provider
final globalAuthProvider = Provider<GlobalAuthState>((ref) {
  final featureAuthState = ref.watch(feature_auth.authProvider);

  return GlobalAuthState(
    status: featureAuthState.status,
    user: featureAuthState.user,
    token: featureAuthState.token,
    errorMessage: featureAuthState.errorMessage,
    lastUpdated: DateTime.now(),
  );
});

/// Convenience providers for common auth checks
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(globalAuthProvider).isAuthenticated;
});

final isLoadingAuthProvider = Provider<bool>((ref) {
  return ref.watch(globalAuthProvider).isLoading;
});

final hasAuthErrorProvider = Provider<bool>((ref) {
  return ref.watch(globalAuthProvider).hasError;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(globalAuthProvider).user;
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(globalAuthProvider).userId;
});

final currentUserEmailProvider = Provider<String?>((ref) {
  return ref.watch(globalAuthProvider).userEmail;
});

final currentUserNameProvider = Provider<String?>((ref) {
  return ref.watch(globalAuthProvider).userName;
});

final authTokenProvider = Provider<AuthToken?>((ref) {
  return ref.watch(globalAuthProvider).token;
});

final isEmailVerifiedProvider = Provider<bool>((ref) {
  return ref.watch(globalAuthProvider).isEmailVerified;
});

final authErrorMessageProvider = Provider<String?>((ref) {
  return ref.watch(globalAuthProvider).errorMessage;
});

/// Provider for checking if token needs refresh
final needsTokenRefreshProvider = Provider<bool>((ref) {
  return ref.watch(globalAuthProvider).needsTokenRefresh;
});

/// Provider for checking if token is expired
final isTokenExpiredProvider = Provider<bool>((ref) {
  return ref.watch(globalAuthProvider).isTokenExpired;
});

/// Global auth actions provider
final globalAuthActionsProvider = Provider<GlobalAuthActions>((ref) {
  return GlobalAuthActions(ref);
});

/// Global auth actions class
class GlobalAuthActions {
  final Ref _ref;

  GlobalAuthActions(this._ref);

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    await _ref.read(feature_auth.authActionsProvider).signIn(email, password);
  }

  /// Sign up with email, password, and name
  Future<void> signUp(String email, String password, String name) async {
    await _ref
        .read(feature_auth.authActionsProvider)
        .signUp(email, password, name);
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _ref.read(feature_auth.authActionsProvider).signOut();
  }

  /// Clear authentication errors
  void clearError() {
    _ref.read(feature_auth.authActionsProvider).clearError();
  }

  /// Refresh user data
  Future<void> refreshUser() async {
    await _ref.read(feature_auth.authActionsProvider).refreshUser();
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _ref.read(isAuthenticatedProvider);
  }

  /// Get current user
  User? getCurrentUser() {
    return _ref.read(currentUserProvider);
  }

  /// Get current auth token
  AuthToken? getCurrentToken() {
    return _ref.read(authTokenProvider);
  }

  /// Check if authentication is required for a feature
  bool requiresAuth(void Function() onUnauthenticated) {
    if (!isAuthenticated()) {
      onUnauthenticated();
      return false;
    }
    return true;
  }

  /// Check if email verification is required
  bool requiresEmailVerification(void Function() onUnverified) {
    if (!_ref.read(isEmailVerifiedProvider)) {
      onUnverified();
      return false;
    }
    return true;
  }

  /// Get auth header for API requests
  Map<String, String>? getAuthHeaders() {
    final token = getCurrentToken();
    if (token == null) return null;

    return {
      'Authorization': '${token.tokenType} ${token.accessToken}',
    };
  }

  /// Check if token is valid and not expired
  bool hasValidToken() {
    final token = getCurrentToken();
    if (token == null) return false;
    return DateTime.now().isBefore(token.expiresAt);
  }
}

/// Provider for auth-dependent features
/// This can be used to conditionally show features based on auth state
final authDependentFeaturesProvider = Provider<AuthDependentFeatures>((ref) {
  return AuthDependentFeatures(ref);
});

/// Helper class for managing auth-dependent features
class AuthDependentFeatures {
  final Ref _ref;

  AuthDependentFeatures(this._ref);

  /// Check if profile features should be available
  bool get canAccessProfile => _ref.read(isAuthenticatedProvider);

  /// Check if settings features should be available
  bool get canAccessSettings => true; // Settings available to all users

  /// Check if premium features should be available
  bool get canAccessPremiumFeatures {
    final user = _ref.read(currentUserProvider);
    // Add premium user logic here
    return user != null;
  }

  /// Check if admin features should be available
  bool get canAccessAdminFeatures {
    final user = _ref.read(currentUserProvider);
    // Add admin role logic here
    return user != null; // Placeholder
  }

  /// Get available navigation items based on auth state
  List<String> getAvailableNavigationItems() {
    final items = <String>['home'];

    if (canAccessProfile) {
      items.add('profile');
    }

    if (canAccessSettings) {
      items.add('settings');
    }

    if (canAccessAdminFeatures) {
      items.add('admin');
    }

    return items;
  }
}
