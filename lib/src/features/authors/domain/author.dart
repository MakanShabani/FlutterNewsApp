import '../../../infrastructure/shared_models/shared_model.dart';
import '../../../server_impementation/databse_entities/databse_entities.dart';

class Author extends Entity {
  Author(
      {required this.lastname,
      required this.firstName,
      this.imageUrl,
      required super.id,
      required super.createdAt,
      required super.updatedAt});

  final String firstName;
  final String lastname;
  final String? imageUrl;

  factory Author.fromJson(Map<String, dynamic> parsedJson) {
    final Entity tempEntity = Entity.fromJson(parsedJson);

    return Author(
        lastname: parsedJson['last_name'],
        firstName: parsedJson['first_name'],
        imageUrl: parsedJson['image_url'],
        id: tempEntity.id,
        createdAt: tempEntity.createdAt,
        updatedAt: tempEntity.updatedAt);
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();

    data['first_name'] = firstName;
    data['last_name'] = lastname;
    data['image_url'] = imageUrl;
    return data;
  }

  factory Author.fromFakeDatabseUser(DatabaseUser databseuser) {
    return Author(
        lastname: databseuser.lastName,
        firstName: databseuser.firstName,
        imageUrl: databseuser.imageUrl,
        id: databseuser.id,
        createdAt: databseuser.createdAt,
        updatedAt: databseuser.updatedAt);
  }
}
