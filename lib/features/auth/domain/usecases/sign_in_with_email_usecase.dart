import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailParams {
  final String email;
  final String password;
  const SignInWithEmailParams({required this.email, required this.password});
}

class SignInWithEmailUseCase implements UseCase<AppUser, SignInWithEmailParams> {
  final AuthRepository repository;
  SignInWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(SignInWithEmailParams params) {
    return repository.signInWithEmail(params.email, params.password);
  }
}
