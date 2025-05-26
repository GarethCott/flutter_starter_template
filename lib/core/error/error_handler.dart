import 'dart:io';

import 'package:flutter/foundation.dart';

import 'app_error.dart';

/// Utility class for handling and converting errors
class ErrorHandler {
  /// Convert any exception to an AppError
  static AppError handleError(dynamic error) {
    if (error is AppError) {
      return error;
    }

    if (error is SocketException) {
      return NetworkError.noConnection();
    }

    if (error is HttpException) {
      return NetworkError.serverError();
    }

    if (error is FormatException) {
      return ValidationError.invalidFormat('data');
    }

    // Log unknown errors in debug mode
    if (kDebugMode) {
      debugPrint('Unknown error: $error');
    }

    return UnknownError.fromException(
      error is Exception ? error : Exception(error.toString()),
    );
  }

  /// Get user-friendly error message
  static String getUserMessage(AppError error) {
    // Return the error message as it's already user-friendly
    return error.message;
  }

  /// Check if error should be reported to crash analytics
  static bool shouldReport(AppError error) {
    // Don't report validation errors or user errors
    if (error is ValidationError || error is AuthError) {
      return false;
    }

    // Don't report network connectivity issues
    if (error is NetworkError &&
        (error.code == 'NO_CONNECTION' || error.code == 'TIMEOUT')) {
      return false;
    }

    // Report all other errors
    return true;
  }

  /// Log error for debugging
  static void logError(AppError error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('AppError: ${error.toString()}');
      if (error.details != null) {
        debugPrint('Details: ${error.details}');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }
}
