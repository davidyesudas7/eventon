class UiHintOption {
  final String value;
  final String label;

  const UiHintOption({
    required this.value,
    required this.label,
  });
}

class UiHint {
  final String key;
  final String label;
  final String widget;
  final String? group;
  final int order;
  final String? unit;
  final List<UiHintOption> options;

  const UiHint({
    required this.key,
    required this.label,
    required this.widget,
    this.group,
    required this.order,
    this.unit,
    this.options = const [],
  });
}
