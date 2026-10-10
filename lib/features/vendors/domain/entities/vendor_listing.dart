class VendorListing {
  final String id;
  final String vendorId;
  final String categoryId;
  final String title;
  final String description;
  final String? coverUrl;
  final num? priceFrom;
  final double? ratingAvg;
  final int? ratingCount;
  final Map<String, dynamic> attributes;

  const VendorListing({
    required this.id,
    required this.vendorId,
    required this.categoryId,
    required this.title,
    required this.description,
    this.coverUrl,
    this.priceFrom,
    this.ratingAvg,
    this.ratingCount,
    this.attributes = const {},
  });
}
