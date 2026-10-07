class CategoryAttribute {
  final String id;
  final String name;
  final String uiHint;
  final List<String> options;
  final num? min;
  final num? max;

  const CategoryAttribute({
    required this.id,
    required this.name,
    required this.uiHint,
    this.options = const [],
    this.min,
    this.max,
  });
}
