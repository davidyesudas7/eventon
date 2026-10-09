import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/token_storage.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/auth_request_dtos.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;
  final FirebaseAuthDatasource firebaseAuthDatasource;

  AuthRepositoryImpl({
    required this.apiClient,
    required this.tokenStorage,
    required this.firebaseAuthDatasource,
  });

  AppUser _mapUserModelToEntity(UserModel model) {
    return AppUser(
      id: model.id,
      email: model.email,
      fullName: model.fullName,
      roles: model.roles,
      phone: model.phone,
      phoneSignIn: model.phoneSignIn,
      businessName: model.businessName,
      bio: model.bio,
      profilePhotoUrl: model.profilePhotoUrl,
      territoryId: model.territoryId,
      basePincode: model.basePincode,
      lsgId: model.lsgId,
    );
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final response = await apiClient.login(
        LoginDto(email: email, password: password),
      );
      await tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return Right(_mapUserModelToEntity(response.user));
    } catch (e) {
      return Left(handleApiError(e, defaultMessage: 'Failed to sign in'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmail(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      final response = await apiClient.register(
        RegisterDto(
          email: email,
          password: password,
          fullName: fullName,
          role: 'customer',
        ),
      );
      await tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return Right(_mapUserModelToEntity(response.user));
    } catch (e) {
      return Left(handleApiError(e, defaultMessage: 'Failed to create account'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> firebaseSignIn({
    required String idToken,
    String? fullName,
    String? email,
  }) async {
    try {
      final response = await apiClient.firebaseSignIn(
        FirebaseSignInDto(
          idToken: idToken,
          fullName: fullName,
          email: email,
          as: 'customer',
        ),
      );
      await tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return Right(_mapUserModelToEntity(response.user));
    } catch (e) {
      return Left(handleApiError(e, idToken: idToken, defaultMessage: 'Sign in failed'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> getCurrentUser() async {
    try {
      final accessToken = await tokenStorage.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        return const Left(UnauthorizedFailure());
      }
      final userModel = await apiClient.getMe();
      return Right(_mapUserModelToEntity(userModel));
    } catch (e) {
      return Left(handleApiError(e, defaultMessage: 'Failed to load user profile'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await apiClient.logout();
    } catch (_) {}
    await firebaseAuthDatasource.signOut();
    await tokenStorage.clearTokens();
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await apiClient.forgotPassword(ForgotPasswordDto(email: email));
      return const Right(null);
    } catch (e) {
      return Left(handleApiError(e, defaultMessage: 'Failed to send reset link'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    try {
      final idToken = await firebaseAuthDatasource.signInWithGoogle();
      return await firebaseSignIn(idToken: idToken);
    } catch (e) {
      if (e.toString().contains('cancelled')) {
        return const Left(ServerFailure('Google sign in cancelled by user'));
      }
      return Left(handleApiError(e, defaultMessage: 'Google sign in failed'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(dynamic credential) onVerificationCompleted,
    required void Function(dynamic e) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
  }) async {
    try {
      await firebaseAuthDatasource.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onVerificationCompleted: onVerificationCompleted,
        onVerificationFailed: onVerificationFailed,
        onCodeSent: onCodeSent,
        onCodeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
      );
      return const Right(null);
    } catch (e) {
      return Left(handleApiError(e, defaultMessage: 'Failed to verify phone number'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> confirmOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final idToken = await firebaseAuthDatasource.confirmOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await firebaseSignIn(idToken: idToken);
    } catch (e) {
      return Left(handleApiError(e, defaultMessage: 'Invalid or expired OTP code'));
    }
  }
}
