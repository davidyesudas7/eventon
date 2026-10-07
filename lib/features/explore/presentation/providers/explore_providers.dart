import 'dart:convert';
import 'package:eventon/features/explore/data/repositories/explore_repository.dart';
import 'package:eventon/features/explore/domain/entities/search_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = FutureProvider.family<SearchResult, String>((ref, queryStr) async {
  final repository = ref.watch(exploreRepositoryProvider);
  final queries = jsonDecode(queryStr) as Map<String, dynamic>;
  return repository.search(queries);
});
