import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_providers.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/explore_repository.dart';

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  return ExploreRepositoryImpl(ref.watch(apiClientProvider));
});

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<SearchResult> search(Map<String, dynamic> queries) async {
    try {
      final res = await _apiClient.search(queries);
      return res.toEntity();
    } catch (e) {
      throw Exception(
        extractErrorMessage(e, defaultMessage: 'Failed to search listings'),
      );
    }
  }
}
