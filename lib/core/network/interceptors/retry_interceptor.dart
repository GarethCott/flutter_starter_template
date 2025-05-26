import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for automatic request retry with exponential backoff
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;
  final List<int> retryableStatusCodes;
  final List<DioExceptionType> retryableExceptionTypes;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.retryableStatusCodes = const [408, 429, 500, 502, 503, 504],
    this.retryableExceptionTypes = const [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = _shouldRetry(err);
    final retryCount = _getRetryCount(err.requestOptions);

    if (shouldRetry && retryCount < maxRetries) {
      final newRetryCount = retryCount + 1;
      final delay = _calculateDelay(newRetryCount);

      if (kDebugMode) {
        debugPrint(
          '🔄 Retrying request ($newRetryCount/$maxRetries) '
          'after ${delay.inMilliseconds}ms: ${err.requestOptions.uri}',
        );
      }

      // Wait before retrying
      await Future.delayed(delay);

      // Update retry count in request options
      err.requestOptions.extra['retry_count'] = newRetryCount;

      try {
        // Retry the request
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // If retry fails, continue with the error
        if (e is DioException) {
          super.onError(e, handler);
          return;
        }
      }
    }

    super.onError(err, handler);
  }

  /// Check if the error should trigger a retry
  bool _shouldRetry(DioException error) {
    // Don't retry if it's a client error (4xx) except for specific cases
    if (error.response?.statusCode != null) {
      final statusCode = error.response!.statusCode!;

      // Don't retry client errors except for specific retryable ones
      if (statusCode >= 400 && statusCode < 500) {
        return retryableStatusCodes.contains(statusCode);
      }

      // Retry server errors (5xx)
      if (statusCode >= 500) {
        return retryableStatusCodes.contains(statusCode);
      }
    }

    // Retry specific exception types
    return retryableExceptionTypes.contains(error.type);
  }

  /// Get current retry count from request options
  int _getRetryCount(RequestOptions options) {
    return options.extra['retry_count'] ?? 0;
  }

  /// Calculate delay with exponential backoff and jitter
  Duration _calculateDelay(int retryCount) {
    // Exponential backoff: baseDelay * 2^(retryCount - 1)
    final exponentialDelay = baseDelay.inMilliseconds * pow(2, retryCount - 1);

    // Add jitter (random factor between 0.5 and 1.5)
    final jitter = 0.5 + Random().nextDouble();
    final delayWithJitter = (exponentialDelay * jitter).round();

    // Cap the maximum delay at 30 seconds
    final cappedDelay = min(delayWithJitter, 30000);

    return Duration(milliseconds: cappedDelay);
  }
}
