import '../../../../core/network/api_client.dart';
import '../../../categories/data/models/category_model.dart';
import '../../domain/entities/listing_details_data.dart';
import '../../domain/repositories/listing_repository.dart';
import '../models/listing_detail_model.dart';
import '../models/package_model.dart';
import '../models/review_model.dart';
import '../models/vendor_profile_model.dart';

class ListingRepositoryImpl implements ListingRepository {
  ListingRepositoryImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<ListingDetailsData> getListingDetails(String listingId) async {
    // 1. Fetch listing details (fails completely if this fails)
    final listing = await _apiClient.getListing(listingId);

    // 2. Fetch parallel dependencies gracefully
    VendorProfileModel? vendor;
    CategoryModel? category;
    PaginatedReviewsModel? reviewsRes;
    List<PackageModel>? packages;

    await Future.wait([
      () async {
        try {
          vendor = await _apiClient.getVendor(listing.vendorId);
        } catch (_) {}
      }(),
      () async {
        try {
          category = await _apiClient.getCategory(listing.categoryId);
        } catch (_) {}
      }(),
      () async {
        try {
          reviewsRes = await _apiClient.getListingReviews(listingId);
        } catch (_) {}
      }(),
      () async {
        try {
          packages = await _apiClient.getListingPackages(listingId);
        } catch (_) {}
      }(),
    ]);

    return ListingDetailsData(
      listing: listing,
      vendor: vendor,
      category: category,
      reviews: reviewsRes?.items ?? [],
      reviewTotal: reviewsRes?.total ?? 0,
      packages: packages ?? [],
    );
  }

  @override
  Future<List<ListingDetailModel>> getListings({
    String? vendorId,
    String? categoryId,
  }) {
    return _apiClient.getListings(
      vendorId: vendorId,
      categoryId: categoryId,
    );
  }
}
