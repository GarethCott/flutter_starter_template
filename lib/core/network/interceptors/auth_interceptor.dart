import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/secure_storage.dart';

/// Interceptor for handling authentication tokens
class AuthInterceptor extends Interceptor {
  static const String _authHeader = 'Authorization';
  static const String _bearerPrefix = 'Bearer ';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Get token from secure storage
    final token = await SecureStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers[_authHeader] = '$_bearerPrefix$token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized responses
    if (err.response?.statusCode == 401) {
      // Clear stored token on 401
      await SecureStorage.clearToken();

      // You might want to trigger a logout or redirect to login
      // This could be done through a callback or event system
    }

    super.onError(err, handler);
  }
}

/// Provider for AuthInterceptor
final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor();
});
