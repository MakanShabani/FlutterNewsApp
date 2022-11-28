import 'databse_entity.dart';

class DatabasePostCategory extends DatabaseEntity {
  String title;
  String description;

  DatabasePostCategory(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      required this.title,
      required this.description})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
}
