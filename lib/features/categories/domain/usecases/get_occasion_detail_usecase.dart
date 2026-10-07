import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/occasion_detail.dart';
import '../repositories/categories_repository.dart';

class GetOccasionDetailUseCase implements UseCase<OccasionDetail, String> {
  final CategoriesRepository repository;

  GetOccasionDetailUseCase(this.repository);

  @override
  Future<Either<Failure, OccasionDetail>> call(String slug) async {
    return await repository.getOccasion(slug);
  }
}
