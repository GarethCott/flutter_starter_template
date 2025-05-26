import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

/// Hasura-specific configuration and setup
class HasuraConfig {
  // Private constructor to prevent instantiation
  HasuraConfig._();

  /// Hasura GraphQL endpoint
  static String get hasuraEndpoint => '${ApiConstants.devBaseUrl}/v1/graphql';

  /// Hasura WebSocket endpoint for subscriptions
  static String get hasuraWebSocketEndpoint =>
      hasuraEndpoint.replaceFirst('http', 'ws').replaceFirst('https', 'wss');

  /// Hasura admin secret (for development/testing only)
  static const String? adminSecret = null; // Set this for development if needed

  /// Create Hasura HTTP Link
  static HttpLink createHasuraHttpLink() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add admin secret if available (development only)
    if (adminSecret != null) {
      headers['x-hasura-admin-secret'] = adminSecret!;
    }

    return HttpLink(
      hasuraEndpoint,
      defaultHeaders: headers,
    );
  }

  /// Create Hasura WebSocket Link for subscriptions
  static WebSocketLink createHasuraWebSocketLink() {
    return WebSocketLink(
      hasuraWebSocketEndpoint,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        initialPayload: () async {
          final payload = <String, dynamic>{};

          // Add authentication token
          final token = await SecureStorage.getToken();
          if (token != null) {
            payload['Authorization'] = 'Bearer $token';
          }

          // Add admin secret if available (development only)
          if (adminSecret != null) {
            payload['x-hasura-admin-secret'] = adminSecret!;
          }

          return payload;
        },
      ),
    );
  }

  /// Create Hasura Auth Link
  static AuthLink createHasuraAuthLink() {
    return AuthLink(
      getToken: () async {
        final token = await SecureStorage.getToken();
        return token != null ? 'Bearer $token' : null;
      },
      headerKey: 'Authorization',
    );
  }

  /// Hasura-specific error codes
  static const Map<String, String> hasuraErrorCodes = {
    'validation-failed': 'Validation failed',
    'parse-failed': 'Query parse failed',
    'constraint-error': 'Database constraint error',
    'permission-error': 'Permission denied',
    'not-exists': 'Resource does not exist',
    'already-exists': 'Resource already exists',
    'access-denied': 'Access denied',
    'authentication-failed': 'Authentication failed',
  };

  /// Common Hasura headers for authenticated requests
  static Future<Map<String, String>> getAuthenticatedHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add authentication token
    final token = await SecureStorage.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Add admin secret if available (development only)
    if (adminSecret != null) {
      headers['x-hasura-admin-secret'] = adminSecret!;
    }

    return headers;
  }

  /// Hasura role-based access control headers
  static Map<String, String> getRoleHeaders(String role) {
    return {
      'x-hasura-role': role,
    };
  }

  /// Get user-specific headers for Hasura
  static Future<Map<String, String>> getUserHeaders(String userId) async {
    final headers = await getAuthenticatedHeaders();
    headers['x-hasura-user-id'] = userId;
    return headers;
  }

  /// Common Hasura query fragments
  static const String userFragment = '''
    fragment UserFragment on users {
      id
      email
      name
      avatar_url
      created_at
      updated_at
    }
  ''';

  static const String postFragment = '''
    fragment PostFragment on posts {
      id
      title
      content
      author_id
      created_at
      updated_at
      author {
        ...UserFragment
      }
    }
  ''';

  /// Hasura subscription connection parameters
  static const Duration subscriptionTimeout = Duration(seconds: 30);
  static const Duration reconnectInterval = Duration(seconds: 5);
  static const int maxReconnectAttempts = 5;

  /// Hasura batch request configuration
  static const int maxBatchSize = 10;
  static const Duration batchTimeout = Duration(milliseconds: 100);

  /// Hasura cache configuration
  static const Duration cacheTimeout = Duration(minutes: 5);
  static const int maxCacheSize = 100; // Number of queries to cache
}
