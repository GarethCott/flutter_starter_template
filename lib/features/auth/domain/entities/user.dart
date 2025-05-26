/// User entity representing the authenticated user
class User {
  /// Unique user identifier
  final String id;

  /// User's email address
  final String email;

  /// User's display name
  final String? name;

  /// User's first name
  final String? firstName;

  /// User's last name
  final String? lastName;

  /// User's phone number
  final String? phoneNumber;

  /// User's profile picture URL
  final String? profilePictureUrl;

  /// Whether the user's email is verified
  final bool isEmailVerified;

  /// Whether the user's phone is verified
  final bool isPhoneVerified;

  /// User's role/permissions
  final UserRole role;

  /// User's account status
  final UserStatus status;

  /// When the user was created
  final DateTime createdAt;

  /// When the user was last updated
  final DateTime updatedAt;

  /// When the user last logged in
  final DateTime? lastLoginAt;

  /// User's preferred locale
  final String? locale;

  /// User's timezone
  final String? timezone;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profilePictureUrl,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.role = UserRole.user,
    this.status = UserStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.locale,
    this.timezone,
    this.metadata,
  });

  /// Get user's full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return name ?? email.split('@').first;
  }

  /// Get user's display name (prioritizes name, then full name, then email)
  String get displayName {
    return name ?? fullName;
  }

  /// Get user's initials for avatar
  String get initials {
    final displayName = this.displayName;
    final parts = displayName.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
  }

  /// Whether the user is fully verified
  bool get isFullyVerified =>
      isEmailVerified && (phoneNumber == null || isPhoneVerified);

  /// Whether the user is active
  bool get isActive => status == UserStatus.active;

  /// Whether the user is an admin
  bool get isAdmin => role == UserRole.admin || role == UserRole.superAdmin;

  /// Copy user with updated properties
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profilePictureUrl,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    UserRole? role,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    String? locale,
    String? timezone,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      locale: locale ?? this.locale,
      timezone: timezone ?? this.timezone,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phoneNumber == phoneNumber &&
        other.profilePictureUrl == profilePictureUrl &&
        other.isEmailVerified == isEmailVerified &&
        other.isPhoneVerified == isPhoneVerified &&
        other.role == role &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.lastLoginAt == lastLoginAt &&
        other.locale == locale &&
        other.timezone == timezone;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      name,
      firstName,
      lastName,
      phoneNumber,
      profilePictureUrl,
      isEmailVerified,
      isPhoneVerified,
      role,
      status,
      createdAt,
      updatedAt,
      lastLoginAt,
      locale,
      timezone,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role, status: $status)';
  }
}

/// User roles in the system
enum UserRole {
  /// Regular user
  user,

  /// Moderator with limited admin privileges
  moderator,

  /// Administrator
  admin,

  /// Super administrator with full privileges
  superAdmin,
}

/// User account status
enum UserStatus {
  /// Active user account
  active,

  /// Inactive user account
  inactive,

  /// Suspended user account
  suspended,

  /// Banned user account
  banned,

  /// Pending verification
  pending,
}

/// Extension for UserRole
extension UserRoleExtension on UserRole {
  /// Get display name for the role
  String get displayName {
    switch (this) {
      case UserRole.user:
        return 'User';
      case UserRole.moderator:
        return 'Moderator';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.superAdmin:
        return 'Super Administrator';
    }
  }

  /// Get role priority (higher number = more privileges)
  int get priority {
    switch (this) {
      case UserRole.user:
        return 1;
      case UserRole.moderator:
        return 2;
      case UserRole.admin:
        return 3;
      case UserRole.superAdmin:
        return 4;
    }
  }
}

/// Extension for UserStatus
extension UserStatusExtension on UserStatus {
  /// Get display name for the status
  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.banned:
        return 'Banned';
      case UserStatus.pending:
        return 'Pending';
    }
  }

  /// Whether the status allows login
  bool get canLogin {
    switch (this) {
      case UserStatus.active:
        return true;
      case UserStatus.inactive:
      case UserStatus.suspended:
      case UserStatus.banned:
      case UserStatus.pending:
        return false;
    }
  }
}
