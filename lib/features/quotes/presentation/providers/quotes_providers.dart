import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_providers.dart';
import '../../data/models/quote_request_model.dart';
import '../../data/repositories/quotes_repository_impl.dart';
import '../../domain/repositories/quotes_repository.dart';

part 'quotes_providers.g.dart';

@riverpod
QuotesRepository quotesRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return QuotesRepositoryImpl(apiClient);
}

@riverpod
Future<List<QuoteRequestModel>> quoteRequests(Ref ref) async {
  final repo = ref.watch(quotesRepositoryProvider);
  final result = await repo.getQuoteRequests();
  return result.fold(
    (l) => throw Exception(l.message),
    (r) => r,
  );
}

@riverpod
Future<QuoteRequestModel> quoteRequestDetail(Ref ref, String id) async {
  final repo = ref.watch(quotesRepositoryProvider);
  final result = await repo.getQuoteRequestById(id);
  return result.fold(
    (l) => throw Exception(l.message),
    (r) => r,
  );
}
