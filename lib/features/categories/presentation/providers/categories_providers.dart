import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_providers.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/occasion_detail.dart';
import '../../domain/repositories/categories_repository.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_occasion_detail_usecase.dart';
import '../../domain/usecases/get_occasions_usecase.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/entities/occasion.dart';

part 'categories_providers.g.dart';

@riverpod
CategoriesRepository categoriesRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CategoriesRepositoryImpl(apiClient);
}

@riverpod
GetCategoriesUseCase getCategoriesUseCase(Ref ref) {
  return GetCategoriesUseCase(ref.watch(categoriesRepositoryProvider));
}

@riverpod
GetOccasionsUseCase getOccasionsUseCase(Ref ref) {
  return GetOccasionsUseCase(ref.watch(categoriesRepositoryProvider));
}

@riverpod
GetOccasionDetailUseCase getOccasionDetailUseCase(Ref ref) {
  return GetOccasionDetailUseCase(ref.watch(categoriesRepositoryProvider));
}

@Riverpod(keepAlive: true)
Future<List<Occasion>> occasions(Ref ref) async {
  final usecase = ref.watch(getOccasionsUseCaseProvider);
  final result = await usecase(const NoParams());
  return result.fold(
    (failure) => throw failure,
    (occasions) => occasions,
  );
}

@Riverpod(keepAlive: true)
Future<List<Category>> categories(Ref ref) async {
  final usecase = ref.watch(getCategoriesUseCaseProvider);
  final result = await usecase(const NoParams());
  return result.fold(
    (failure) => throw failure,
    (categories) => categories,
  );
}

@Riverpod(keepAlive: true)
Future<OccasionDetail> occasionDetail(
  Ref ref,
  String slug,
) async {
  final usecase = ref.watch(getOccasionDetailUseCaseProvider);
  final result = await usecase(slug);
  return result.fold(
    (failure) => throw failure,
    (occasion) => occasion,
  );
}
