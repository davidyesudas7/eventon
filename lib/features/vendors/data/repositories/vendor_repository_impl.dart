import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/vendor_listing.dart';
import '../../domain/entities/vendor_profile.dart';
import '../../domain/entities/vendor_review.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../datasources/vendor_remote_data_source.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDataSource _remoteDataSource;

  VendorRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, VendorProfile>> getVendorProfile(String id) async {
    try {
      final model = await _remoteDataSource.getVendor(id);
      return Right(
        VendorProfile(
          id: model.id,
          fullName: model.fullName,
          businessName: model.businessName,
          bio: model.bio,
          profilePhotoUrl: model.profilePhotoUrl,
        ),
      );
    } catch (e) {
      return Left(
        handleApiError(e, defaultMessage: 'Failed to load vendor profile'),
      );
    }
  }

  @override
  Future<Either<Failure, List<VendorListing>>> getVendorListings(
    String vendorId,
  ) async {
    try {
      final models = await _remoteDataSource.getVendorListings(vendorId);
      final listings = models
          .map(
            (m) => VendorListing(
              id: m.id,
              vendorId: m.vendorId,
              categoryId: m.categoryId,
              title: m.title,
              description: m.description,
              coverUrl: m.media?.cover?.url,
              priceFrom: m.priceFrom,
              ratingAvg: m.ratingAvg,
              ratingCount: m.ratingCount,
              attributes: m.attributes,
            ),
          )
          .toList();
      return Right(listings);
    } catch (e) {
      return Left(
        handleApiError(e, defaultMessage: 'Failed to load vendor listings'),
      );
    }
  }

  @override
  Future<Either<Failure, PaginatedVendorReviews>> getVendorReviews(
    String vendorId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final model = await _remoteDataSource.getVendorReviews(
        vendorId,
        page: page,
        limit: limit,
      );
      final reviews = model.items
          .map(
            (r) => VendorReview(
              id: r.id,
              rating: r.rating,
              comment: r.comment,
              createdAt: r.createdAt,
              customerId: r.customerId,
            ),
          )
          .toList();

      return Right(
        PaginatedVendorReviews(
          items: reviews,
          total: model.total,
          page: model.page,
          limit: model.limit,
        ),
      );
    } catch (e) {
      return Left(
        handleApiError(e, defaultMessage: 'Failed to load vendor reviews'),
      );
    }
  }
}
