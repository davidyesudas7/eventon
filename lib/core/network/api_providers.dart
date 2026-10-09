import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'api_client.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';
import '../router/app_router.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

part 'api_providers.g.dart';

@riverpod
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage();
}

@riverpod
Dio dio(Ref ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final baseUrl = dotenv.env['BASE_URL']!;

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
        // Logout user state
        ref.read(authControllerProvider.notifier).logout();
        // Force redirect to login page
        ref.read(goRouterProvider).go('/sign-in-mobile');
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        print(
          'API Response [${response.requestOptions.path}]: ${response.data}',
        );
        handler.next(response);
      },
      onError: (DioException e, handler) {
        print('API Error [${e.requestOptions.path}]: ${e.response?.data}');
        handler.next(e);
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
