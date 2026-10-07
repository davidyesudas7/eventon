import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/occasion.dart';
import '../repositories/categories_repository.dart';

class GetOccasionsUseCase implements UseCase<List<Occasion>, NoParams> {
  final CategoriesRepository repository;

  GetOccasionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Occasion>>> call(NoParams params) async {
    return await repository.getOccasions();
  }
}
