/// Home entity - core business logic model
/// This is platform-independent and doesn't depend on any external packages
class HomeEntity {
  final int id;
  final String title;
  final String description;

  const HomeEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  String toString() =>
      'HomeEntity(id: $id, title: $title, description: $description)';
}
