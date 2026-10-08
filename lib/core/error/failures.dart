abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ProfileRequiredFailure extends Failure {
  final String? idToken;
  const ProfileRequiredFailure([
    super.message = 'Profile details required to complete registration',
    this.idToken,
  ]);
}

class UsePasswordFailure extends Failure {
  const UsePasswordFailure([
    super.message =
        'This account uses password authentication. Please sign in with email and password.',
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Unauthorized or session expired',
  ]);
}
