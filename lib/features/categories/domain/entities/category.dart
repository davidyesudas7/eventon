import 'ui_hint.dart';

class Category {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? icon;
  final String? iconUrl;
  final bool isActive;
  final List<String> occasionIds;
  final List<UiHint> uiHints;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.icon,
    this.iconUrl,
    required this.isActive,
    required this.occasionIds,
    this.uiHints = const [],
  });
}
