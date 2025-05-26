import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../error/app_error.dart';

/// Interceptor for global error handling
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error in debug mode
    if (kDebugMode) {
      debugPrint('🔥 Network Error: ${err.message}');
      debugPrint('🔥 Status Code: ${err.response?.statusCode}');
      debugPrint('🔥 Response Data: ${err.response?.data}');
    }

    // Convert DioException to AppError for consistent error handling
    final appError = _convertToAppError(err);

    // Create a new DioException with the AppError message
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appError,
      message: appError.message,
    );

    super.onError(newError, handler);
  }

  /// Convert DioException to AppError
  AppError _convertToAppError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkError.timeout();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data);

        if (statusCode != null) {
          if (statusCode == 400) {
            return ValidationError(
              message: message ?? 'Invalid request data',
            );
          } else if (statusCode == 401) {
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
          message: 'SSL certificate error. Connection is not secure.',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
      default:
        return UnknownError(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Try common error message fields
      final message = data['message'] ??
          data['error'] ??
          data['detail'] ??
          data['msg'] ??
          data['error_description'];

      if (message is String) {
        return message;
      }

      // Handle validation errors
      if (data['errors'] is Map) {
        final errors = data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        } else if (firstError is String) {
          return firstError;
        }
      }

      // Handle array of errors
      if (data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          final firstError = errors.first;
          if (firstError is Map && firstError['message'] != null) {
            return firstError['message'].toString();
          } else {
            return firstError.toString();
          }
        }
      }
    } else if (data is String) {
      return data;
    }

    return null;
  }
}
