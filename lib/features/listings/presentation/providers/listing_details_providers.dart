import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_providers.dart';
import '../../../categories/data/models/category_model.dart';
import '../../data/models/listing_detail_model.dart';
import '../../data/models/package_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/vendor_profile_model.dart';

class ListingDetailsData {
  final ListingDetailModel listing;
  final VendorProfileModel? vendor;
  final CategoryModel? category;
  final List<ReviewModel> reviews;
  final int reviewTotal;
  final List<PackageModel> packages;

  ListingDetailsData({
    required this.listing,
    this.vendor,
    this.category,
    this.reviews = const [],
    this.reviewTotal = 0,
    this.packages = const [],
  });
}

final listingDetailsProvider = FutureProvider.autoDispose.family<ListingDetailsData, String>((ref, id) async {
  final apiClient = ref.read(apiClientProvider);

  // 1. Fetch listing details (fail completely if this fails)
  final listing = await apiClient.getListing(id);

  // 2. Fetch parallel dependencies
  VendorProfileModel? vendor;
  CategoryModel? category;
  PaginatedReviewsModel? reviewsRes;
  List<PackageModel>? packages;

  await Future.wait([
    () async { try { vendor = await apiClient.getVendor(listing.vendorId); } catch (_) {} }(),
    () async { try { category = await apiClient.getCategory(listing.categoryId); } catch (_) {} }(),
    () async { try { reviewsRes = await apiClient.getListingReviews(id); } catch (_) {} }(),
    () async { try { packages = await apiClient.getListingPackages(id); } catch (_) {} }(),
  ]);

  return ListingDetailsData(
    listing: listing,
    vendor: vendor,
    category: category,
    reviews: reviewsRes?.items ?? [],
    reviewTotal: reviewsRes?.total ?? 0,
    packages: packages ?? [],
  );
});
