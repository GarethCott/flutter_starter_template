import 'package:flutter/material.dart';
import 'package:flutter_starter_template/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_starter_template/features/splash/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/explore/presentation/pages/explore_page.dart';
import '../features/favorites/presentation/pages/favorites_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/main/presentation/pages/main_shell_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import 'route_names.dart';

part 'app_router.g.dart';

/// Global key for navigator state
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

/// App router provider
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: RouteNames.splash,
    routes: [
      // Splash route
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Onboarding route
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Auth routes (outside shell)
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),

      // Main shell with tab navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShellPage(
            location: state.uri.toString(),
            child: child,
          );
        },
        routes: [
          // Home route
          GoRoute(
            path: RouteNames.home,
            name: RouteNames.home,
            builder: (context, state) => const HomePage(),
          ),

          // Explore route
          GoRoute(
            path: RouteNames.explore,
            name: RouteNames.explore,
            builder: (context, state) => const ExplorePage(),
          ),

          // Favorites route
          GoRoute(
            path: RouteNames.favorites,
            name: RouteNames.favorites,
            builder: (context, state) => const FavoritesPage(),
          ),

          // Profile route
          GoRoute(
            path: RouteNames.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfilePage(),
          ),

          // Settings route
          GoRoute(
            path: RouteNames.settings,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
