import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/occasion.dart';
import '../entities/occasion_detail.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Occasion>>> getOccasions();
  Future<Either<Failure, OccasionDetail>> getOccasion(String slug);
}
