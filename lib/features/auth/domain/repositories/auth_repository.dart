import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signInWithEmail(
    String email,
    String password,
  );
  Future<Either<Failure, AppUser>> signUpWithEmail(
    String email,
    String password,
    String fullName,
  );
  Future<Either<Failure, AppUser>> firebaseSignIn({
    required String idToken,
    String? fullName,
    String? email,
  });
  Future<Either<Failure, AppUser>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> forgotPassword(String email);
  
  // Firebase Auth methods
  Future<Either<Failure, AppUser>> signInWithGoogle();
  
  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(dynamic credential) onVerificationCompleted,
    required void Function(dynamic e) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
  });

  Future<Either<Failure, AppUser>> confirmOtp({
    required String verificationId,
    required String smsCode,
  });
}
