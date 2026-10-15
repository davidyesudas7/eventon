import '../../data/models/listing_detail_model.dart';
import '../entities/listing_details_data.dart';

abstract interface class ListingRepository {
  Future<ListingDetailsData> getListingDetails(String listingId);
  Future<List<ListingDetailModel>> getListings({
    String? vendorId,
    String? categoryId,
  });
}
