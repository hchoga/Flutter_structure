class DropdownItemModel {
  final int id;
  final String label;
  final double advanceNotice;

  /// When false the item is shown but cannot be selected (greyed out).
  final bool enabled;

  DropdownItemModel({
    required this.id,
    required this.label,
    required this.advanceNotice,
    this.enabled = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
