import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_providers.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';
import '../../domain/usecases/firebase_sign_in_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../../../features/explore/presentation/providers/location_search_provider.dart';

part 'auth_providers.g.dart';

@riverpod
FirebaseAuthDatasource firebaseAuthDatasource(Ref ref) {
  return FirebaseAuthDatasource();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  final firebaseAuthDatasource = ref.watch(firebaseAuthDatasourceProvider);

  return AuthRepositoryImpl(
    apiClient: apiClient,
    tokenStorage: tokenStorage,
    firebaseAuthDatasource: firebaseAuthDatasource,
  );
}

@riverpod
SignInWithEmailUseCase signInWithEmailUseCase(Ref ref) {
  return SignInWithEmailUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignUpWithEmailUseCase signUpWithEmailUseCase(Ref ref) {
  return SignUpWithEmailUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
FirebaseSignInUseCase firebaseSignInUseCase(Ref ref) {
  return FirebaseSignInUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
}

sealed class AuthState {
  const AuthState();
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  final AppUser user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateError extends AuthState {
  final Failure failure;
  const AuthStateError(this.failure);
}

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    Future.microtask(() => checkAuthStatus());
    return const AuthStateUnauthenticated();
  }

  Future<void> checkAuthStatus() async {
    final usecase = ref.read(getCurrentUserUseCaseProvider);
    final result = await usecase(const NoParams());

    state = result.fold(
      (failure) => const AuthStateUnauthenticated(),
      (user) => AuthStateAuthenticated(user),
    );
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = const AuthStateLoading();
    final usecase = ref.read(signInWithEmailUseCaseProvider);
    final result = await usecase(SignInWithEmailParams(email: email, password: password));

    return result.fold(
      (failure) {
        state = AuthStateError(failure);
        return false;
      },
      (user) {
        state = AuthStateAuthenticated(user);
        return true;
      },
    );
  }

  Future<bool> signUpWithEmail(
    String email,
    String password,
    String fullName,
  ) async {
    state = const AuthStateLoading();
    final usecase = ref.read(signUpWithEmailUseCaseProvider);
    final result = await usecase(SignUpWithEmailParams(email: email, password: password, fullName: fullName));

    return result.fold(
      (failure) {
        state = AuthStateError(failure);
        return false;
      },
      (user) {
        state = AuthStateAuthenticated(user);
        return true;
      },
    );
  }

  Future<bool> firebaseSignIn({
    required String idToken,
    String? fullName,
    String? email,
  }) async {
    state = const AuthStateLoading();
    final usecase = ref.read(firebaseSignInUseCaseProvider);
    final result = await usecase(FirebaseSignInParams(
      idToken: idToken,
      fullName: fullName,
      email: email,
    ));

    return result.fold(
      (failure) {
        state = AuthStateError(failure);
        return false;
      },
      (user) {
        state = AuthStateAuthenticated(user);
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = const AuthStateLoading();
    final usecase = ref.read(logoutUseCaseProvider);
    await usecase(const NoParams());
    
    // Clear selected location
    ref.read(exploreLocationProvider.notifier).clearLocation();
    
    state = const AuthStateUnauthenticated();
  }
}
