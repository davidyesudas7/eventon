import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> signInWithEmail(String email, String password);
  Future<Either<Failure, bool>> signUpWithEmail(String email, String password);
}
