import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/quotes_repository.dart';
import '../models/quote_request_model.dart';

class QuotesRepositoryImpl implements QuotesRepository {
  final ApiClient apiClient;

  QuotesRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, QuoteRequestModel>> createQuoteRequest(Map<String, dynamic> body) async {
    try {
      final response = await apiClient.createQuoteRequest(body);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuoteRequestModel>>> getQuoteRequests() async {
    try {
      final response = await apiClient.getQuoteRequests();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuoteRequestModel>> getQuoteRequestById(String id) async {
    try {
      final response = await apiClient.getQuoteRequestById(id);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> closeQuoteRequest(String id) async {
    try {
      await apiClient.closeQuoteRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
