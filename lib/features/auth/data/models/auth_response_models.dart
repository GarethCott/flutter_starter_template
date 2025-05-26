import 'package:json_annotation/json_annotation.dart';

import 'auth_token_model.dart';
import 'user_model.dart';

part 'auth_response_models.g.dart';

@JsonSerializable()
class AuthResponse {
  final UserModel user;
  final AuthTokenModel token;

  const AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class RefreshTokenResponse {
  final AuthTokenModel token;

  const RefreshTokenResponse({
    required this.token,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}

@JsonSerializable()
class MessageResponse {
  final String message;
  final bool success;

  const MessageResponse({
    required this.message,
    this.success = true,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}
