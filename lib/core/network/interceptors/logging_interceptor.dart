import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  static const String _tag = 'HTTP';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logRequest(options);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logResponse(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logError(err);
    }
    super.onError(err, handler);
  }

  void _logRequest(RequestOptions options) {
    final uri = options.uri;
    final method = options.method.toUpperCase();

    developer.log(
      '🚀 REQUEST [$method] $uri',
      name: _tag,
    );

    // Log headers
    if (options.headers.isNotEmpty) {
      developer.log(
        '📋 Headers: ${_formatJson(options.headers)}',
        name: _tag,
      );
    }

    // Log query parameters
    if (options.queryParameters.isNotEmpty) {
      developer.log(
        '🔍 Query: ${_formatJson(options.queryParameters)}',
        name: _tag,
      );
    }

    // Log request data
    if (options.data != null) {
      developer.log(
        '📤 Data: ${_formatData(options.data)}',
        name: _tag,
      );
    }
  }

  void _logResponse(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method.toUpperCase();
    final statusCode = response.statusCode;

    developer.log(
      '✅ RESPONSE [$method] $uri [$statusCode]',
      name: _tag,
    );

    // Log response headers
    if (response.headers.map.isNotEmpty) {
      developer.log(
        '📋 Headers: ${_formatJson(response.headers.map)}',
        name: _tag,
      );
    }

    // Log response data
    if (response.data != null) {
      developer.log(
        '📥 Data: ${_formatData(response.data)}',
        name: _tag,
      );
    }
  }

  void _logError(DioException error) {
    final uri = error.requestOptions.uri;
    final method = error.requestOptions.method.toUpperCase();
    final statusCode = error.response?.statusCode;

    developer.log(
      '❌ ERROR [$method] $uri ${statusCode != null ? '[$statusCode]' : ''}',
      name: _tag,
      error: error.message,
    );

    // Log error response data
    if (error.response?.data != null) {
      developer.log(
        '📥 Error Data: ${_formatData(error.response!.data)}',
        name: _tag,
      );
    }
  }

  String _formatData(dynamic data) {
    try {
      if (data is String) {
        // Try to parse as JSON for better formatting
        try {
          final jsonData = jsonDecode(data);
          return _formatJson(jsonData);
        } catch (_) {
          return data;
        }
      } else if (data is FormData) {
        return 'FormData(${data.fields.length} fields, ${data.files.length} files)';
      } else {
        return _formatJson(data);
      }
    } catch (e) {
      return data.toString();
    }
  }

  String _formatJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }
}
