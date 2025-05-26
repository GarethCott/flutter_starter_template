import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../error/app_error.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'models/api_response.dart';

/// HTTP client service using Dio for API communication
class ApiClient {
  late final Dio _dio;

  ApiClient({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    _dio = Dio();
    _setupDio(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );
    _setupInterceptors();
  }

  /// Configure Dio with base options
  void _setupDio({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.devBaseUrl, // Default to dev environment
      connectTimeout: connectTimeout ??
          const Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: receiveTimeout ??
          const Duration(milliseconds: AppConstants.receiveTimeout),
      sendTimeout:
          sendTimeout ?? const Duration(milliseconds: AppConstants.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        // Accept all status codes to handle them in interceptors
        return status != null && status < 500;
      },
    );
  }

  /// Setup interceptors for the Dio client
  void _setupInterceptors() {
    _dio.interceptors.clear();

    // Add interceptors in order of execution
    _dio.interceptors.addAll([
      AuthInterceptor(),
      RetryInterceptor(_dio),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Upload file
  Future<ApiResponse<T>> upload<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle successful response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final data = response.data;

    if (data is Map<String, dynamic>) {
      // If response has a standard API wrapper format
      if (data.containsKey('data') || data.containsKey('success')) {
        return ApiResponse<T>.fromJson(data, fromJson);
      }
    }

    // Direct data response
    T? parsedData;
    if (fromJson != null && data != null) {
      parsedData = fromJson(data);
    } else if (data is T) {
      parsedData = data;
    }

    return ApiResponse<T>(
      success: true,
      data: parsedData,
      message: 'Request successful',
      statusCode: response.statusCode,
    );
  }

  /// Handle Dio errors and convert to AppError
  AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkError.timeout();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data);

        if (statusCode != null) {
          if (statusCode == 401) {
            return NetworkError.unauthorized();
          } else if (statusCode == 403) {
            return NetworkError.forbidden();
          } else if (statusCode == 404) {
            return NetworkError.notFound();
          } else if (statusCode >= 400 && statusCode < 500) {
            return NetworkError(
              message: message ?? 'Client error occurred',
              statusCode: statusCode,
            );
          } else if (statusCode >= 500) {
            return NetworkError.serverError(statusCode);
          }
        }

        return NetworkError(
          message: message ?? 'Network error occurred',
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const NetworkError(
          message: 'Request was cancelled',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.connectionError:
        return NetworkError.noConnection();

      case DioExceptionType.badCertificate:
        return const NetworkError(
          message: 'Certificate error. Please check your connection security.',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
      default:
        return UnknownError(
          message: error.message ?? 'An unknown error occurred',
        );
    }
  }

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Try common error message fields
      return data['message'] ?? data['error'] ?? data['detail'] ?? data['msg'];
    } else if (data is String) {
      return data;
    }
    return null;
  }

  /// Update base URL
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Update headers
  void updateHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// Clear headers
  void clearHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
  }

  /// Get current Dio instance (for advanced usage)
  Dio get dio => _dio;

  /// Close the client and clean up resources
  void close() {
    _dio.close();
  }
}

/// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Provider for Dio instance (if needed directly)
final dioProvider = Provider<Dio>((ref) {
  return ref.read(apiClientProvider).dio;
});
