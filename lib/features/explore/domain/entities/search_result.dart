class SearchListing {
  final String id;
  final String title;
  final String categoryId;
  final String? description;
  final String? coverUrl;
  final num? priceFrom;

  const SearchListing({
    required this.id,
    required this.title,
    required this.categoryId,
    this.description,
    this.coverUrl,
    this.priceFrom,
  });
}

class SearchResult {
  final List<SearchListing> items;
  final int total;
  final int page;
  final int limit;

  const SearchResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}
