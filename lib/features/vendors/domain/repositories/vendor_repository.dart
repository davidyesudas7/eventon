import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/vendor_profile.dart';
import '../entities/vendor_listing.dart';
import '../entities/vendor_review.dart';

abstract class VendorRepository {
  Future<Either<Failure, VendorProfile>> getVendorProfile(String id);
  Future<Either<Failure, List<VendorListing>>> getVendorListings(String vendorId);
  Future<Either<Failure, PaginatedVendorReviews>> getVendorReviews(
    String vendorId, {
    int page = 1,
    int limit = 20,
  });
}
