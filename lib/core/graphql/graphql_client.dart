import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'graphql_config.dart';

/// GraphQL client service for handling GraphQL operations
class GraphQLClientService {
  late final GraphQLClient _client;
  late final ValueNotifier<GraphQLClient> _clientNotifier;

  GraphQLClientService() {
    _initializeClient();
  }

  /// Initialize the GraphQL client with proper configuration
  void _initializeClient() {
    // Create the link chain
    final httpLink = GraphQLConfig.createHttpLink();
    final authLink = GraphQLConfig.createAuthLink();
    final websocketLink = GraphQLConfig.createWebSocketLink();

    // Combine links - auth link should be before http link
    final link = Link.split(
      (request) => request.isSubscription,
      authLink.concat(websocketLink),
      authLink.concat(httpLink),
    );

    // Create cache
    final cache = GraphQLConfig.createCache();

    // Create client
    _client = GraphQLClient(
      link: link,
      cache: cache,
    );

    _clientNotifier = ValueNotifier(_client);
  }

  /// Get the GraphQL client
  GraphQLClient get client => _client;

  /// Get the client notifier for GraphQLProvider
  ValueNotifier<GraphQLClient> get clientNotifier => _clientNotifier;

  /// Execute a query
  Future<QueryResult> query(
    String query, {
    Map<String, dynamic>? variables,
    FetchPolicy? fetchPolicy,
    ErrorPolicy? errorPolicy,
    CacheRereadPolicy? cacheRereadPolicy,
  }) async {
    final options = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
      fetchPolicy: fetchPolicy ?? GraphQLConfig.defaultQueryFetchPolicy,
      errorPolicy: errorPolicy ?? GraphQLConfig.defaultErrorPolicy,
      cacheRereadPolicy: cacheRereadPolicy,
    );

    final result = await _client.query(options);

    // Handle errors
    if (result.hasException) {
      GraphQLConfig.handleGraphQLError(result.exception!);
    }

    return result;
  }

  /// Execute a mutation
  Future<QueryResult> mutate(
    String mutation, {
    Map<String, dynamic>? variables,
    FetchPolicy? fetchPolicy,
    ErrorPolicy? errorPolicy,
    Map<String, dynamic>? optimisticResult,
    String? operationName,
  }) async {
    final options = MutationOptions(
      document: gql(mutation),
      variables: variables ?? {},
      fetchPolicy: fetchPolicy ?? GraphQLConfig.defaultMutationFetchPolicy,
      errorPolicy: errorPolicy ?? GraphQLConfig.defaultErrorPolicy,
      optimisticResult: optimisticResult ??
          (operationName != null
              ? GraphQLConfig.createOptimisticResponse(
                  operationName, variables ?? {})
              : null),
    );

    final result = await _client.mutate(options);

    // Handle errors
    if (result.hasException) {
      GraphQLConfig.handleGraphQLError(result.exception!);
    }

    // Update cache if needed
    if (operationName != null && !result.hasException) {
      GraphQLConfig.updateCacheAfterMutation(
          _client.cache, result, operationName);
    }

    return result;
  }

  /// Create a subscription stream
  Stream<QueryResult> subscribe(
    String subscription, {
    Map<String, dynamic>? variables,
    ErrorPolicy? errorPolicy,
  }) {
    final options = SubscriptionOptions(
      document: gql(subscription),
      variables: variables ?? {},
      errorPolicy: errorPolicy ?? GraphQLConfig.defaultErrorPolicy,
    );

    return _client.subscribe(options);
  }

  /// Watch a query (reactive)
  ObservableQuery watchQuery(
    String query, {
    Map<String, dynamic>? variables,
    FetchPolicy? fetchPolicy,
    ErrorPolicy? errorPolicy,
    Duration? pollInterval,
  }) {
    final options = WatchQueryOptions(
      document: gql(query),
      variables: variables ?? {},
      fetchPolicy: fetchPolicy ?? GraphQLConfig.defaultQueryFetchPolicy,
      errorPolicy: errorPolicy ?? GraphQLConfig.defaultErrorPolicy,
      pollInterval: pollInterval,
    );

    return _client.watchQuery(options);
  }

  /// Clear cache
  Future<void> clearCache() async {
    _client.cache.store.reset();
  }

  /// Reset client (useful for logout)
  void resetClient() {
    _client.cache.store.reset();
    _initializeClient();
  }

  /// Dispose resources
  void dispose() {
    _clientNotifier.dispose();
  }
}

/// Provider for GraphQL client service
final graphqlClientServiceProvider = Provider<GraphQLClientService>((ref) {
  final service = GraphQLClientService();

  // Dispose when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Provider for GraphQL client
final graphqlClientProvider = Provider<GraphQLClient>((ref) {
  return ref.read(graphqlClientServiceProvider).client;
});

/// Provider for GraphQL client notifier (for GraphQLProvider widget)
final graphqlClientNotifierProvider =
    Provider<ValueNotifier<GraphQLClient>>((ref) {
  return ref.read(graphqlClientServiceProvider).clientNotifier;
});
