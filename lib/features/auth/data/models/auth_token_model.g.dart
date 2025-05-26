// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthTokenModel _$AuthTokenModelFromJson(Map<String, dynamic> json) =>
    AuthTokenModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      scopes:
          (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AuthTokenModelToJson(AuthTokenModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'issuedAt': instance.issuedAt.toIso8601String(),
      'scopes': instance.scopes,
    };
