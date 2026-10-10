import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/vendor_review.dart';
import '../repositories/vendor_repository.dart';

class GetVendorReviewsParams {
  final String vendorId;
  final int page;
  final int limit;

  const GetVendorReviewsParams({
    required this.vendorId,
    this.page = 1,
    this.limit = 20,
  });
}

class GetVendorReviewsUseCase
    implements UseCase<PaginatedVendorReviews, GetVendorReviewsParams> {
  final VendorRepository repository;

  GetVendorReviewsUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedVendorReviews>> call(
    GetVendorReviewsParams params,
  ) async {
    return await repository.getVendorReviews(
      params.vendorId,
      page: params.page,
      limit: params.limit,
    );
  }
}
