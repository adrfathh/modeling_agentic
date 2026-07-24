// lib/core/network/api_client.dart
//
// HTTP API Client — Dio-based with JWT injection
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:dio/dio.dart';
import '../auth/token_storage.dart';
import '../auth/auth_events.dart';

/// Centralized HTTP client with JWT token injection.
///
/// Features:
/// - Automatic Authorization header injection
/// - Request/Response logging (debug mode)
/// - Error transformation
/// - Base URL configuration
class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;

  // Loads BASE_URL from dart-define, falling back to default
  static const String _baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.smakasihan.sch.id/v1',
  );

  ApiClient({TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // JWT injection interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 — token expired
          if (error.response?.statusCode == 401) {
            await _tokenStorage.clearAll();
            // Trigger navigation to login via event bus
            AuthEventBus.triggerLogout();
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
  }) async {
    return _dio.post<T>(path, data: data);
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) async {
    return _dio.put<T>(path, data: data);
  }

  /// DELETE request
  Future<Response<T>> delete<T>(String path) async {
    return _dio.delete<T>(path);
  }
}
