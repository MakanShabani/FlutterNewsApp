import '../../../infrastructure/shared_models/shared_model.dart';
import '../../../server_impementation/databse_entities/databse_entities.dart';

class PostCategory extends Entity {
  String title;
  String description;

  PostCategory(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      required this.title,
      required this.description})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory PostCategory.fromJson(Map<String, dynamic> parsedJson) {
    final Entity tempEntity = Entity.fromJson(parsedJson);

    return PostCategory(
        id: tempEntity.id,
        createdAt: tempEntity.createdAt,
        updatedAt: tempEntity.updatedAt,
        title: parsedJson['title'],
        description: parsedJson['description']);
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();

    data['title'] = title;
    data['description'] = description;
    return data;
  }

  factory PostCategory.fromFakeDatabsePostCategory(
      DatabasePostCategory databsePostCategory) {
    return PostCategory(
        id: databsePostCategory.id,
        createdAt: databsePostCategory.createdAt,
        updatedAt: databsePostCategory.updatedAt,
        title: databsePostCategory.title,
        description: databsePostCategory.description);
  }
}
