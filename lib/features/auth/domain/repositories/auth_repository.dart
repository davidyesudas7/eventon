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
}
