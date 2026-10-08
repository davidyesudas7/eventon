import 'package:dartz/dartz.dart';
import 'package:eventon/features/quotes/data/models/quote_request_model.dart';
import '../../../../core/error/failures.dart';

abstract class QuotesRepository {
  Future<Either<Failure, QuoteRequestModel>> createQuoteRequest(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, List<QuoteRequestModel>>> getQuoteRequests();
  Future<Either<Failure, QuoteRequestModel>> getQuoteRequestById(String id);
  Future<Either<Failure, void>> closeQuoteRequest(String id);
}
