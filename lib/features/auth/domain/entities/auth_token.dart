/// Authentication token entity
class AuthToken {
  /// Access token for API requests
  final String accessToken;

  /// Refresh token for obtaining new access tokens
  final String? refreshToken;

  /// Token type (usually 'Bearer')
  final String tokenType;

  /// When the access token expires
  final DateTime expiresAt;

  /// When the token was issued
  final DateTime issuedAt;

  /// Token scope/permissions
  final List<String>? scopes;

  const AuthToken({
    required this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
    required this.expiresAt,
    required this.issuedAt,
    this.scopes,
  });

  /// Whether the access token is expired
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Whether the access token will expire soon (within 5 minutes)
  bool get isExpiringSoon {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt);
  }

  /// Time remaining until token expires
  Duration get timeUntilExpiry {
    return expiresAt.difference(DateTime.now());
  }

  /// Whether the token is valid (not expired)
  bool get isValid => !isExpired;

  /// Whether refresh is available
  bool get canRefresh => refreshToken != null;

  /// Copy token with updated properties
  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    DateTime? expiresAt,
    DateTime? issuedAt,
    List<String>? scopes,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
      issuedAt: issuedAt ?? this.issuedAt,
      scopes: scopes ?? this.scopes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthToken &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.tokenType == tokenType &&
        other.expiresAt == expiresAt &&
        other.issuedAt == issuedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      accessToken,
      refreshToken,
      tokenType,
      expiresAt,
      issuedAt,
    );
  }

  @override
  String toString() {
    return 'AuthToken(tokenType: $tokenType, expiresAt: $expiresAt, isExpired: $isExpired)';
  }
}
