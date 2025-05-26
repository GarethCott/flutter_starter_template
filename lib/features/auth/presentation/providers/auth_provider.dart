import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/storage/services/auth_storage_service.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/feedback/snackbar.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../widgets/auth_status_widget.dart';

// Auth state
class AuthState {
  final AuthStatus status;
  final User? user;
  final AuthToken? token;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.token,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    AuthToken? token,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(status: AuthStatus.initial)) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Check for existing authentication data
      final authData = await AuthStorageService.getAuthData();

      if (authData != null) {
        // Restore user session
        final userData = authData['user_data'] as Map<String, dynamic>?;
        if (userData != null) {
          final user = User(
            id: userData['id'] as String,
            email: userData['email'] as String,
            name: userData['name'] as String,
            isEmailVerified: userData['isEmailVerified'] as bool? ?? false,
            createdAt: DateTime.parse(userData['createdAt'] as String),
            updatedAt: DateTime.parse(userData['updatedAt'] as String),
            profilePictureUrl: userData['profilePictureUrl'] as String?,
            role: _parseUserRole(userData['role'] as String?),
          );

          final token = AuthToken(
            accessToken: authData['token'] as String,
            refreshToken: authData['refresh_token'] as String,
            expiresAt:
                DateTime.now().add(const Duration(hours: 1)), // Mock expiration
            issuedAt: DateTime.now(),
            tokenType: 'Bearer',
          );

          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            token: token,
            errorMessage: null,
          );
          return;
        }
      }
    } catch (e) {
      // If there's an error loading auth data, continue as unauthenticated
    }

    // Start as unauthenticated if no valid session found
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: null,
    );
  }

  Future<void> signInWithEmail(String email, String password,
      {BuildContext? context}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      // Simulate network delay for realistic demo experience
      await Future.delayed(const Duration(seconds: 2));

      // Use dummy credentials for demo
      final demoUser = _validateAndCreateDemoUser(email, password);
      final demoToken = _generateDemoToken();

      // Store authentication data
      await AuthStorageService.storeAuthData(
        token: demoToken.accessToken,
        refreshToken: demoToken.refreshToken ?? 'demo_refresh_token',
        userId: demoUser.id,
        userData: {
          'id': demoUser.id,
          'email': demoUser.email,
          'name': demoUser.name,
          'isEmailVerified': demoUser.isEmailVerified,
          'createdAt': demoUser.createdAt.toIso8601String(),
          'updatedAt': demoUser.updatedAt.toIso8601String(),
          'profilePictureUrl': demoUser.profilePictureUrl ?? '',
          'role': demoUser.role.name,
        },
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: demoUser,
        token: demoToken,
        errorMessage: null,
      );

      // Show welcome message and navigate to home
      if (context != null && context.mounted) {
        CustomSnackbar.showSuccess(
          context,
          message: 'Welcome back, ${demoUser.displayName}!',
          duration: const Duration(seconds: 3),
        );

        // Navigate to home page
        context.go(RouteNames.home);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signUpWithEmail(String email, String password, String name,
      {BuildContext? context}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful sign up
      final user = User(
        id: '1',
        email: email,
        name: name,
        isEmailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final token = AuthToken(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        issuedAt: DateTime.now(),
        tokenType: 'Bearer',
      );

      // Store authentication data
      await AuthStorageService.storeAuthData(
        token: token.accessToken,
        refreshToken: token.refreshToken ?? 'mock_refresh_token',
        userId: user.id,
        userData: {
          'id': user.id,
          'email': user.email,
          'name': user.name,
          'isEmailVerified': user.isEmailVerified,
          'createdAt': user.createdAt.toIso8601String(),
          'updatedAt': user.updatedAt.toIso8601String(),
          'profilePictureUrl': user.profilePictureUrl ?? '',
          'role': user.role.name,
        },
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
        errorMessage: null,
      );

      // Show welcome message and navigate to home
      if (context != null && context.mounted) {
        CustomSnackbar.showSuccess(
          context,
          message: 'Welcome to the app, ${user.displayName}!',
          duration: const Duration(seconds: 3),
        );

        // Navigate to home page
        context.go(RouteNames.home);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Sign up failed: $e',
      );
    }
  }

  Future<void> signOut({BuildContext? context}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      // Clear stored authentication data
      await AuthStorageService.logout();

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        token: null,
        errorMessage: null,
      );

      // Show logout message and navigate to login
      if (context != null && context.mounted) {
        CustomSnackbar.showInfo(
          context,
          message: 'You have been logged out successfully',
          duration: const Duration(seconds: 2),
        );

        // Navigate to login page
        context.go(RouteNames.login);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Sign out failed: $e',
      );
    }
  }

  void clearError() {
    if (state.hasError) {
      state = state.copyWith(
        status: state.user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
        errorMessage: null,
      );
    }
  }

  Future<void> refreshUser() async {
    if (!state.isAuthenticated) return;

    try {
      // Simulate refresh
      await Future.delayed(const Duration(milliseconds: 300));

      if (state.user != null) {
        final updatedUser = User(
          id: state.user!.id,
          email: state.user!.email,
          name: state.user!.name,
          isEmailVerified: state.user!.isEmailVerified,
          createdAt: state.user!.createdAt,
          updatedAt: DateTime.now(),
        );

        state = state.copyWith(user: updatedUser);
      }
    } catch (e) {
      // Don't change status on refresh failure
    }
  }

  /// Helper method to parse user role from string
  UserRole _parseUserRole(String? roleString) {
    if (roleString == null) return UserRole.user;

    switch (roleString.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'moderator':
        return UserRole.moderator;
      case 'superadmin':
        return UserRole.superAdmin;
      default:
        return UserRole.user;
    }
  }

  /// Dummy credentials for demo purposes
  static const Map<String, Map<String, dynamic>> _dummyCredentials = {
    'admin@example.com': {
      'password': 'admin123',
      'name': 'Admin User',
      'firstName': 'Admin',
      'lastName': 'User',
      'role': UserRole.admin,
      'phoneNumber': '+1234567890',
    },
    'user@example.com': {
      'password': 'user123',
      'name': 'John Doe',
      'firstName': 'John',
      'lastName': 'Doe',
      'role': UserRole.user,
      'phoneNumber': '+1234567891',
    },
    'demo@example.com': {
      'password': 'demo123',
      'name': 'Demo User',
      'firstName': 'Demo',
      'lastName': 'User',
      'role': UserRole.user,
      'phoneNumber': null,
    },
  };

  /// Validate credentials and create demo user
  User _validateAndCreateDemoUser(String email, String password) {
    if (!_dummyCredentials.containsKey(email)) {
      throw Exception('Invalid email or password');
    }

    final credentials = _dummyCredentials[email]!;
    if (credentials['password'] != password) {
      throw Exception('Invalid email or password');
    }

    final now = DateTime.now();
    return User(
      id: 'user_${email.hashCode.abs()}',
      email: email,
      name: credentials['name'] as String,
      firstName: credentials['firstName'] as String?,
      lastName: credentials['lastName'] as String?,
      phoneNumber: credentials['phoneNumber'] as String?,
      profilePictureUrl:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(credentials['name'] as String)}&background=6366f1&color=fff',
      isEmailVerified: true,
      isPhoneVerified: credentials['phoneNumber'] != null,
      role: credentials['role'] as UserRole,
      status: UserStatus.active,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now.subtract(const Duration(days: 1)),
      lastLoginAt: now,
      locale: 'en',
      timezone: 'UTC',
      metadata: {
        'isDemoUser': true,
        'loginCount': 42,
        'lastIpAddress': '192.168.1.1',
      },
    );
  }

  /// Generate demo auth token
  AuthToken _generateDemoToken() {
    final now = DateTime.now();
    return AuthToken(
      accessToken: 'demo_access_token_${now.millisecondsSinceEpoch}',
      refreshToken: 'demo_refresh_token_${now.millisecondsSinceEpoch}',
      tokenType: 'Bearer',
      expiresAt: now.add(const Duration(hours: 24)),
      issuedAt: now,
    );
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Convenience providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authProvider).status;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).errorMessage;
});

// Auth actions provider for UI
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(ref);
});

class AuthActions {
  final Ref _ref;

  AuthActions(this._ref);

  Future<void> signIn(String email, String password) async {
    await _ref.read(authProvider.notifier).signInWithEmail(email, password);
  }

  Future<void> signUp(String email, String password, String name) async {
    await _ref
        .read(authProvider.notifier)
        .signUpWithEmail(email, password, name);
  }

  Future<void> signOut() async {
    await _ref.read(authProvider.notifier).signOut();
  }

  void clearError() {
    _ref.read(authProvider.notifier).clearError();
  }

  Future<void> refreshUser() async {
    await _ref.read(authProvider.notifier).refreshUser();
  }
}
