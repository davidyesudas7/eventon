class VendorReview {
  final String id;
  final num rating;
  final String comment;
  final String createdAt;
  final String customerId;
  final String? vendorId;
  final String? listingId;

  const VendorReview({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.customerId,
    this.vendorId,
    this.listingId,
  });
}

class PaginatedVendorReviews {
  final List<VendorReview> items;
  final int total;
  final int page;
  final int limit;

  const PaginatedVendorReviews({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  bool get hasMore => items.length < total;
}
