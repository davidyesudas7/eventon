import 'dart:developer';

import 'package:dio/dio.dart';
import 'token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage tokenStorage;
  final Dio refreshDio;
  final void Function()? onUnauthorized;

  AuthInterceptor({
    required this.tokenStorage,
    required this.refreshDio,
    this.onUnauthorized,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log("the api url is ${options.path}");
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final path = err.requestOptions.path;

    // Skip refresh logic if endpoint is an auth endpoint itself
    final isAuthPath =
        path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/firebase') ||
        path.contains('/auth/refresh');

    if (response?.statusCode == 401 && !isAuthPath) {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Call refresh API with separate plain Dio
          final refreshResponse = await refreshDio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          if (refreshResponse.statusCode == 200 ||
              refreshResponse.statusCode == 201) {
            final data = refreshResponse.data as Map<String, dynamic>;
            final newAccessToken = data['accessToken'] as String;
            final newRefreshToken = data['refreshToken'] as String;

            await tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            // Retry original request with new token
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';

            final cloneReq = await refreshDio.fetch(opts);
            return handler.resolve(cloneReq);
          }
        } catch (_) {
          // Refresh failed
        }
      }

      // If refresh token missing or refresh failed -> force logout
      await tokenStorage.clearTokens();
      onUnauthorized?.call();
    }

    return handler.next(err);
  }
}
