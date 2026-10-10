import '../../../../core/network/api_client.dart';
import '../../../listings/data/models/listing_detail_model.dart';
import '../../../listings/data/models/review_model.dart';
import '../../../listings/data/models/vendor_profile_model.dart';

abstract class VendorRemoteDataSource {
  Future<VendorProfileModel> getVendor(String id);
  Future<List<ListingDetailModel>> getVendorListings(String vendorId);
  Future<PaginatedReviewsModel> getVendorReviews(
    String vendorId, {
    int page = 1,
    int limit = 20,
  });
}

class VendorRemoteDataSourceImpl implements VendorRemoteDataSource {
  final ApiClient _apiClient;

  VendorRemoteDataSourceImpl(this._apiClient);

  @override
  Future<VendorProfileModel> getVendor(String id) {
    return _apiClient.getVendor(id);
  }

  @override
  Future<List<ListingDetailModel>> getVendorListings(String vendorId) {
    return _apiClient.getListings(vendorId: vendorId);
  }

  @override
  Future<PaginatedReviewsModel> getVendorReviews(
    String vendorId, {
    int page = 1,
    int limit = 20,
  }) {
    return _apiClient.getVendorReviews(vendorId, page: page, limit: limit);
  }
}
