import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailParams {
  final String email;
  final String password;
  final String fullName;
  const SignUpWithEmailParams({required this.email, required this.password, required this.fullName});
}

class SignUpWithEmailUseCase implements UseCase<AppUser, SignUpWithEmailParams> {
  final AuthRepository repository;
  SignUpWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(SignUpWithEmailParams params) {
    return repository.signUpWithEmail(params.email, params.password, params.fullName);
  }
}
