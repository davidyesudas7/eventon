import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'api_client.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

part 'api_providers.g.dart';

@riverpod
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage();
}

@riverpod
Dio dio(Ref ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final baseUrl = "https://api.eventongo.in";

  final refreshDio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: tokenStorage,
      refreshDio: refreshDio,
      onUnauthorized: () {
        // Handled by AuthNotifier listening or checking auth status
      },
    ),
  );

  return dio;
}

@riverpod
ApiClient apiClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
}
