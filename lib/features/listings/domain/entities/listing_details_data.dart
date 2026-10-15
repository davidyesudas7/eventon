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

  const ListingDetailsData({
    required this.listing,
    this.vendor,
    this.category,
    this.reviews = const [],
    this.reviewTotal = 0,
    this.packages = const [],
  });
}
