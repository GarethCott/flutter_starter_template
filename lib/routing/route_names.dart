/// Route names for the application
class RouteNames {
  // Private constructor to prevent instantiation
  RouteNames._();

  // Main routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String explore = '/explore';
  static const String favorites = '/favorites';

  // Auth routes
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Feature routes
  static const String dashboard = '/dashboard';
  static const String notifications = '/notifications';

  // Nested routes
  static const String profileEdit = '/profile/edit';
  static const String settingsTheme = '/settings/theme';
  static const String settingsAccount = '/settings/account';
}
