import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/user.dart';
import 'auth_provider.dart';

/// User preferences that can be customized
class UserPreferences {
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final bool darkModeEnabled;
  final String preferredLanguage;
  final bool analyticsEnabled;
  final bool crashReportingEnabled;

  const UserPreferences({
    this.notificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.pushNotificationsEnabled = true,
    this.darkModeEnabled = false,
    this.preferredLanguage = 'en',
    this.analyticsEnabled = true,
    this.crashReportingEnabled = true,
  });

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? pushNotificationsEnabled,
    bool? darkModeEnabled,
    String? preferredLanguage,
    bool? analyticsEnabled,
    bool? crashReportingEnabled,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReportingEnabled:
          crashReportingEnabled ?? this.crashReportingEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'darkModeEnabled': darkModeEnabled,
      'preferredLanguage': preferredLanguage,
      'analyticsEnabled': analyticsEnabled,
      'crashReportingEnabled': crashReportingEnabled,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] ?? true,
      pushNotificationsEnabled: json['pushNotificationsEnabled'] ?? true,
      darkModeEnabled: json['darkModeEnabled'] ?? false,
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      analyticsEnabled: json['analyticsEnabled'] ?? true,
      crashReportingEnabled: json['crashReportingEnabled'] ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.notificationsEnabled == notificationsEnabled &&
        other.emailNotificationsEnabled == emailNotificationsEnabled &&
        other.pushNotificationsEnabled == pushNotificationsEnabled &&
        other.darkModeEnabled == darkModeEnabled &&
        other.preferredLanguage == preferredLanguage &&
        other.analyticsEnabled == analyticsEnabled &&
        other.crashReportingEnabled == crashReportingEnabled;
  }

  @override
  int get hashCode => Object.hash(
        notificationsEnabled,
        emailNotificationsEnabled,
        pushNotificationsEnabled,
        darkModeEnabled,
        preferredLanguage,
        analyticsEnabled,
        crashReportingEnabled,
      );

  @override
  String toString() {
    return 'UserPreferences(notifications: $notificationsEnabled, darkMode: $darkModeEnabled, language: $preferredLanguage)';
  }
}

/// User profile data that extends the basic User entity
class UserProfile {
  final User user;
  final UserPreferences preferences;
  final String? avatarUrl;
  final String? bio;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? location;
  final String? website;
  final Map<String, dynamic> customFields;
  final DateTime lastUpdated;

  const UserProfile({
    required this.user,
    required this.preferences,
    this.avatarUrl,
    this.bio,
    this.phoneNumber,
    this.dateOfBirth,
    this.location,
    this.website,
    this.customFields = const {},
    required this.lastUpdated,
  });

  UserProfile copyWith({
    User? user,
    UserPreferences? preferences,
    String? avatarUrl,
    String? bio,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? location,
    String? website,
    Map<String, dynamic>? customFields,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      user: user ?? this.user,
      preferences: preferences ?? this.preferences,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      website: website ?? this.website,
      customFields: customFields ?? this.customFields,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Get user's display name (name or email)
  String get displayName =>
      (user.name?.isNotEmpty ?? false) ? user.name! : user.email;

  /// Get user's initials for avatar
  String get initials {
    if (user.name?.isNotEmpty ?? false) {
      final parts = user.name!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return user.name![0].toUpperCase();
    }
    return user.email[0].toUpperCase();
  }

  /// Check if profile is complete
  bool get isProfileComplete {
    return (user.name?.isNotEmpty ?? false) &&
        user.isEmailVerified &&
        bio != null &&
        bio!.isNotEmpty;
  }

  /// Get profile completion percentage
  double get profileCompletionPercentage {
    int completed = 0;
    int total = 6;

    if (user.name?.isNotEmpty ?? false) completed++;
    if (user.isEmailVerified) completed++;
    if (bio != null && bio!.isNotEmpty) completed++;
    if (avatarUrl != null) completed++;
    if (phoneNumber != null) completed++;
    if (dateOfBirth != null) completed++;

    return completed / total;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.user == user &&
        other.preferences == preferences &&
        other.avatarUrl == avatarUrl &&
        other.bio == bio &&
        other.phoneNumber == phoneNumber &&
        other.dateOfBirth == dateOfBirth &&
        other.location == location &&
        other.website == website;
  }

  @override
  int get hashCode => Object.hash(
        user,
        preferences,
        avatarUrl,
        bio,
        phoneNumber,
        dateOfBirth,
        location,
        website,
      );

  @override
  String toString() {
    return 'UserProfile(user: ${user.email}, complete: ${(profileCompletionPercentage * 100).toInt()}%)';
  }
}

/// User state for managing user data and preferences
class UserState {
  final UserProfile? profile;
  final bool isLoading;
  final String? errorMessage;
  final DateTime lastUpdated;

  const UserState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
    required this.lastUpdated,
  });

  UserState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return UserState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Whether user profile is available
  bool get hasProfile => profile != null;

  /// Whether there's an error
  bool get hasError => errorMessage != null;

  /// Get current user
  User? get user => profile?.user;

  /// Get user preferences
  UserPreferences get preferences =>
      profile?.preferences ?? const UserPreferences();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserState &&
        other.profile == profile &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(profile, isLoading, errorMessage);

  @override
  String toString() {
    return 'UserState(hasProfile: $hasProfile, isLoading: $isLoading, hasError: $hasError)';
  }
}

/// User notifier for managing user state
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(lastUpdated: DateTime.now())) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize user state - this would typically load from storage
    // For now, we'll just set initial state
    state = state.copyWith(
      isLoading: false,
      lastUpdated: DateTime.now(),
    );
  }

  /// Update user profile from authenticated user
  void updateFromAuthUser(User? user) {
    if (user == null) {
      state = state.copyWith(
        profile: null,
        lastUpdated: DateTime.now(),
      );
      return;
    }

    final currentProfile = state.profile;
    final preferences = currentProfile?.preferences ?? const UserPreferences();

    final newProfile = UserProfile(
      user: user,
      preferences: preferences,
      avatarUrl: currentProfile?.avatarUrl,
      bio: currentProfile?.bio,
      phoneNumber: currentProfile?.phoneNumber,
      dateOfBirth: currentProfile?.dateOfBirth,
      location: currentProfile?.location,
      website: currentProfile?.website,
      customFields: currentProfile?.customFields ?? {},
      lastUpdated: DateTime.now(),
    );

    state = state.copyWith(
      profile: newProfile,
      lastUpdated: DateTime.now(),
    );
  }

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences preferences) async {
    if (state.profile == null) return;

    state = state.copyWith(isLoading: true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedProfile = state.profile!.copyWith(
        preferences: preferences,
        lastUpdated: DateTime.now(),
      );

      state = state.copyWith(
        profile: updatedProfile,
        isLoading: false,
        errorMessage: null,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update preferences: $e',
      );
    }
  }

  /// Update profile information
  Future<void> updateProfile({
    String? name,
    String? bio,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? location,
    String? website,
    String? avatarUrl,
  }) async {
    if (state.profile == null) return;

    state = state.copyWith(isLoading: true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final currentUser = state.profile!.user;
      final updatedUser = User(
        id: currentUser.id,
        email: currentUser.email,
        name: name ?? currentUser.name,
        isEmailVerified: currentUser.isEmailVerified,
        createdAt: currentUser.createdAt,
        updatedAt: DateTime.now(),
      );

      final updatedProfile = state.profile!.copyWith(
        user: updatedUser,
        bio: bio ?? state.profile!.bio,
        phoneNumber: phoneNumber ?? state.profile!.phoneNumber,
        dateOfBirth: dateOfBirth ?? state.profile!.dateOfBirth,
        location: location ?? state.profile!.location,
        website: website ?? state.profile!.website,
        avatarUrl: avatarUrl ?? state.profile!.avatarUrl,
        lastUpdated: DateTime.now(),
      );

      state = state.copyWith(
        profile: updatedProfile,
        isLoading: false,
        errorMessage: null,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update profile: $e',
      );
    }
  }

  /// Clear error message
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(errorMessage: null);
    }
  }

  /// Clear user data (on sign out)
  void clearUserData() {
    state = UserState(lastUpdated: DateTime.now());
  }
}

/// User provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final notifier = UserNotifier();

  // Listen to auth changes and update user profile
  ref.listen<User?>(currentUserProvider, (previous, next) {
    notifier.updateFromAuthUser(next);
  });

  return notifier;
});

/// Convenience providers
final userProfileProvider = Provider<UserProfile?>((ref) {
  return ref.watch(userProvider).profile;
});

final userPreferencesProvider = Provider<UserPreferences>((ref) {
  return ref.watch(userProvider).preferences;
});

final userLoadingProvider = Provider<bool>((ref) {
  return ref.watch(userProvider).isLoading;
});

final userErrorProvider = Provider<String?>((ref) {
  return ref.watch(userProvider).errorMessage;
});

final profileCompletionProvider = Provider<double>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile?.profileCompletionPercentage ?? 0.0;
});

final userDisplayNameProvider = Provider<String>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile?.displayName ?? 'Guest';
});

final userInitialsProvider = Provider<String>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile?.initials ?? 'G';
});

/// User actions provider
final userActionsProvider = Provider<UserActions>((ref) {
  return UserActions(ref);
});

/// User actions class
class UserActions {
  final Ref _ref;

  UserActions(this._ref);

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences preferences) async {
    await _ref.read(userProvider.notifier).updatePreferences(preferences);
  }

  /// Update profile information
  Future<void> updateProfile({
    String? name,
    String? bio,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? location,
    String? website,
    String? avatarUrl,
  }) async {
    await _ref.read(userProvider.notifier).updateProfile(
          name: name,
          bio: bio,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
          location: location,
          website: website,
          avatarUrl: avatarUrl,
        );
  }

  /// Clear error messages
  void clearError() {
    _ref.read(userProvider.notifier).clearError();
  }

  /// Get current user profile
  UserProfile? getCurrentProfile() {
    return _ref.read(userProfileProvider);
  }

  /// Get current user preferences
  UserPreferences getCurrentPreferences() {
    return _ref.read(userPreferencesProvider);
  }

  /// Check if profile is complete
  bool isProfileComplete() {
    final profile = getCurrentProfile();
    return profile?.isProfileComplete ?? false;
  }

  /// Get profile completion percentage
  double getProfileCompletionPercentage() {
    return _ref.read(profileCompletionProvider);
  }

  /// Toggle notification preference
  Future<void> toggleNotifications(bool enabled) async {
    final currentPrefs = getCurrentPreferences();
    await updatePreferences(
        currentPrefs.copyWith(notificationsEnabled: enabled));
  }

  /// Toggle email notifications
  Future<void> toggleEmailNotifications(bool enabled) async {
    final currentPrefs = getCurrentPreferences();
    await updatePreferences(
        currentPrefs.copyWith(emailNotificationsEnabled: enabled));
  }

  /// Toggle push notifications
  Future<void> togglePushNotifications(bool enabled) async {
    final currentPrefs = getCurrentPreferences();
    await updatePreferences(
        currentPrefs.copyWith(pushNotificationsEnabled: enabled));
  }

  /// Toggle analytics
  Future<void> toggleAnalytics(bool enabled) async {
    final currentPrefs = getCurrentPreferences();
    await updatePreferences(currentPrefs.copyWith(analyticsEnabled: enabled));
  }

  /// Toggle crash reporting
  Future<void> toggleCrashReporting(bool enabled) async {
    final currentPrefs = getCurrentPreferences();
    await updatePreferences(
        currentPrefs.copyWith(crashReportingEnabled: enabled));
  }
}
