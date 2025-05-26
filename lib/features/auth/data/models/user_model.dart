import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    super.profilePictureUrl,
    super.isEmailVerified,
    super.isPhoneVerified,
    super.role,
    super.status,
    required super.createdAt,
    required super.updatedAt,
    super.lastLoginAt,
    super.locale,
    super.timezone,
    super.metadata,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      profilePictureUrl: user.profilePictureUrl,
      isEmailVerified: user.isEmailVerified,
      isPhoneVerified: user.isPhoneVerified,
      role: user.role,
      status: user.status,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      lastLoginAt: user.lastLoginAt,
      locale: user.locale,
      timezone: user.timezone,
      metadata: user.metadata,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profilePictureUrl: profilePictureUrl,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      role: role,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastLoginAt: lastLoginAt,
      locale: locale,
      timezone: timezone,
      metadata: metadata,
    );
  }

  @override
  @override
  UserModel copyWith({
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
    return UserModel(
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
}
