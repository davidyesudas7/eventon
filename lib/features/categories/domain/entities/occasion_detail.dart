import 'category.dart';

class OccasionDetail {
  final String id;
  final String name;
  final String slug;
  final String? tagline;
  final String? coverUrl;
  final int order;
  final bool isActive;
  final int categoryCount;
  final List<Category> categories;

  const OccasionDetail({
    required this.id,
    required this.name,
    required this.slug,
    this.tagline,
    this.coverUrl,
    required this.order,
    required this.isActive,
    required this.categoryCount,
    required this.categories,
  });
}
