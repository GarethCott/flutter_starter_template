import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_token.dart';

part 'auth_token_model.g.dart';

@JsonSerializable()
class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required super.accessToken,
    super.refreshToken,
    super.tokenType,
    required super.expiresAt,
    required super.issuedAt,
    super.scopes,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);

  factory AuthTokenModel.fromEntity(AuthToken token) {
    return AuthTokenModel(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      tokenType: token.tokenType,
      expiresAt: token.expiresAt,
      issuedAt: token.issuedAt,
      scopes: token.scopes,
    );
  }

  AuthToken toEntity() {
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresAt: expiresAt,
      issuedAt: issuedAt,
      scopes: scopes,
    );
  }

  @override
  AuthTokenModel copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    DateTime? expiresAt,
    DateTime? issuedAt,
    List<String>? scopes,
  }) {
    return AuthTokenModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
      issuedAt: issuedAt ?? this.issuedAt,
      scopes: scopes ?? this.scopes,
    );
  }
}
