import '../entities/search_result.dart';

abstract interface class ExploreRepository {
  Future<SearchResult> search(Map<String, dynamic> queries);
}
