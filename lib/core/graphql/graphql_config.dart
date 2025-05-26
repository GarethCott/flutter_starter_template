import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

/// GraphQL configuration and policies
class GraphQLConfig {
  // Private constructor to prevent instantiation
  GraphQLConfig._();

  /// GraphQL endpoint URL
  static String get graphqlEndpoint => '${ApiConstants.devBaseUrl}/graphql';

  /// WebSocket endpoint for subscriptions
  static String get websocketEndpoint =>
      graphqlEndpoint.replaceFirst('http', 'ws').replaceFirst('https', 'wss');

  /// Create HTTP Link for GraphQL operations
  static HttpLink createHttpLink() {
    return HttpLink(
      graphqlEndpoint,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  /// Create WebSocket Link for subscriptions
  static WebSocketLink createWebSocketLink() {
    return WebSocketLink(
      websocketEndpoint,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        initialPayload: () async {
          // Add authentication token to WebSocket connection
          final token = await SecureStorage.getToken();
          return token != null ? {'Authorization': 'Bearer $token'} : {};
        },
      ),
    );
  }

  /// Create Auth Link for adding authentication headers
  static AuthLink createAuthLink() {
    return AuthLink(
      getToken: () async {
        final token = await SecureStorage.getToken();
        return token != null ? 'Bearer $token' : null;
      },
    );
  }

  /// Handle GraphQL errors (to be used in client setup)
  static void handleGraphQLError(OperationException exception) {
    // Handle GraphQL errors
    if (exception.graphqlErrors.isNotEmpty) {
      for (final graphqlError in exception.graphqlErrors) {
        print('GraphQL Error: ${graphqlError.message}');

        // Handle specific error types
        if (graphqlError.extensions?['code'] == 'UNAUTHENTICATED') {
          // Clear token and redirect to login
          SecureStorage.clearToken();
        }
      }
    }

    // Handle network errors
    if (exception.linkException != null) {
      print('Network Error: ${exception.linkException}');
    }
  }

  /// Default cache policies
  static final Map<String, CacheRereadPolicy> defaultCachePolicies = {
    'Query': CacheRereadPolicy.mergeOptimistic,
    'Mutation': CacheRereadPolicy.mergeOptimistic,
    'Subscription': CacheRereadPolicy.ignoreAll,
  };

  /// Default fetch policies
  static const FetchPolicy defaultQueryFetchPolicy =
      FetchPolicy.cacheAndNetwork;
  static const FetchPolicy defaultMutationFetchPolicy = FetchPolicy.networkOnly;

  /// Error policies
  static const ErrorPolicy defaultErrorPolicy = ErrorPolicy.all;

  /// Cache configuration
  static GraphQLCache createCache() {
    return GraphQLCache(
      store: InMemoryStore(),
      // You can also use HiveStore for persistent caching:
      // store: HiveStore(),
    );
  }

  /// Create optimistic response for mutations
  static Map<String, dynamic>? createOptimisticResponse(
    String operationName,
    Map<String, dynamic> variables,
  ) {
    // Implement optimistic responses for specific mutations
    switch (operationName) {
      case 'CreatePost':
        return {
          'createPost': {
            '__typename': 'Post',
            'id': 'temp-${DateTime.now().millisecondsSinceEpoch}',
            'title': variables['title'],
            'content': variables['content'],
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        };
      default:
        return null;
    }
  }

  /// Update cache after mutation
  static void updateCacheAfterMutation(
    GraphQLDataProxy cache,
    QueryResult result,
    String operationName,
  ) {
    // Implement cache updates for specific mutations
    switch (operationName) {
      case 'CreatePost':
        // Update posts list cache
        break;
      case 'UpdatePost':
        // Update specific post cache
        break;
      case 'DeletePost':
        // Remove post from cache
        break;
    }
  }

  /// Subscription configuration
  static const Duration subscriptionKeepAliveTimeout = Duration(seconds: 30);
  static const Duration subscriptionReconnectTimeout = Duration(seconds: 5);

  /// Query complexity limits
  static const int maxQueryComplexity = 1000;
  static const int maxQueryDepth = 10;

  /// Batch configuration
  static const Duration batchInterval = Duration(milliseconds: 10);
  static const int maxBatchSize = 10;
}
