import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCaseWithParams<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

abstract class UseCaseWithoutParams<T> {
  Future<Either<Failure, T>> call();
}

// Deprecated fallback for backward compatibility
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}
