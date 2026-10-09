import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/occasion.dart';
import '../../domain/entities/occasion_detail.dart';
import '../../domain/repositories/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final ApiClient _apiClient;

  CategoriesRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final models = await _apiClient.getCategories();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(
        handleApiError(e, defaultMessage: 'Failed to load categories'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Occasion>>> getOccasions() async {
    try {
      final models = await _apiClient.getOccasions();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(
        handleApiError(e, defaultMessage: 'Failed to load occasions'),
      );
    }
  }

  @override
  Future<Either<Failure, OccasionDetail>> getOccasion(String slug) async {
    try {
      final model = await _apiClient.getOccasion(slug);
      return Right(model.toEntity());
    } catch (e) {
      return Left(
        handleApiError(e, defaultMessage: 'Failed to load occasion details'),
      );
    }
  }
}
