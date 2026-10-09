import 'package:eventon/core/network/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/search_result.dart';

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  return ExploreRepository(ref.watch(apiClientProvider));
});

class ExploreRepository {
  ExploreRepository(this._apiClient);
  final ApiClient _apiClient;

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
