import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class FirebaseSignInParams {
  final String idToken;
  final String? fullName;
  final String? email;
  const FirebaseSignInParams({required this.idToken, this.fullName, this.email});
}

class FirebaseSignInUseCase implements UseCase<AppUser, FirebaseSignInParams> {
  final AuthRepository repository;
  FirebaseSignInUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(FirebaseSignInParams params) {
    return repository.firebaseSignIn(idToken: params.idToken, fullName: params.fullName, email: params.email);
  }
}
