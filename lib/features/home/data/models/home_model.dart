import 'package:touch/features/home/domain/entities/home_entity.dart';

/// Home model extends HomeEntity for data layer
/// This model includes JSON serialization for API/Cache operations
class HomeModel extends HomeEntity {
  const HomeModel({
    required super.id,
    required super.title,
    required super.description,
  });

  /// Convert from JSON
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description};
  }

  /// Convert to entity
  HomeEntity toEntity() {
    return HomeEntity(id: id, title: title, description: description);
  }
}
