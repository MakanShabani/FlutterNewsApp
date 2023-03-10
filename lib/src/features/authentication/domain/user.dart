import '../../../server_impementation/databse_entities/databse_entities.dart';
import '../../../infrastructure/shared_models/shared_model.dart';
import './user_role.dart';
import './user_status.dart';

class User extends Entity {
  final String token;
  final DateTime expireAt;
  final String firstName;
  final String lastName;
  final String email;
  final int? age;
  final String? phone;
  final String? imageUrl;
  final UserRole role;
  final UserStatus status;

  User(
      {required super.id,
      required super.createdAt,
      required super.updatedAt,
      required this.token,
      required this.expireAt,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.age,
      this.phone,
      this.imageUrl,
      required this.role,
      required this.status});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    final Entity tempEntity = Entity.fromJson(parsedJson);

    return User(
      token: parsedJson['token'],
      expireAt: DateTime.parse(parsedJson['expire_at']),
      id: tempEntity.id,
      createdAt: tempEntity.createdAt,
      updatedAt: tempEntity.updatedAt,
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      age: parsedJson['age'],
      email: parsedJson['email'],
      role: UserRole.fromIndex(parsedJson['role']),
      status: UserStatus.fromIndex(parsedJson['status']),
      phone: parsedJson['phone'],
      imageUrl: parsedJson['image_url'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['token'] = token;
    data['expire_at'] = expireAt.toString();
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['age'] = age;
    data['phone'] = phone;
    data['image_url'] = imageUrl;
    data['role'] = role.index;
    data['status'] = status.index;
    return data;
  }

  factory User.fromFakeDatabseUser(DatabaseUser databseUser) {
    return User(
        token: databseUser.token!,
        expireAt: databseUser.tokenExpiresAt!,
        id: databseUser.id,
        createdAt: databseUser.createdAt,
        updatedAt: databseUser.updatedAt,
        firstName: databseUser.firstName,
        lastName: databseUser.lastName,
        email: databseUser.email,
        role: UserRole.fromIndex(databseUser.role.index),
        status: UserStatus.fromIndex(databseUser.status.index));
  }
}
