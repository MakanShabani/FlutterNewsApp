import 'entity.dart';

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
}
