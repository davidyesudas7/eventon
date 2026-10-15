import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/search_result.dart';
import '../../data/repositories/explore_repository_impl.dart';

final searchProvider = FutureProvider.family<SearchResult, String>((ref, queryStr) async {
  final repository = ref.watch(exploreRepositoryProvider);
  final queries = jsonDecode(queryStr) as Map<String, dynamic>;
  return repository.search(queries);
});
