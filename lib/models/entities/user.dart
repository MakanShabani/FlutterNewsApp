import 'package:responsive_admin_dashboard/models/entities/post.dart';

import 'entity.dart';
import 'user_role.dart';
import 'user_status.dart';

class User extends Entity {
  String firstName;
  String lastName;
  String email;
  String? password;
  int? age;
  String? phone;
  String? imageUrl;
  UserRole role;
  UserStatus status;
  List<Post>? posts;

  User({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.firstName,
    required this.lastName,
    this.password,
    this.age,
    required this.email,
    required this.role,
    required this.status,
    this.phone,
    this.imageUrl,
    this.posts,
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    final Entity tempEntity = Entity.fromJson(parsedJson);

    return User(
      id: tempEntity.id,
      createdAt: tempEntity.createdAt,
      updatedAt: tempEntity.updatedAt,
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      password: parsedJson['password'],
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
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['password'] = password;
    data['age'] = age;
    data['email'] = email;
    data['role'] = role.index;
    data['status'] = status.index;
    data['phone'] = phone;
    data['image_url'] = imageUrl;
    return data;
  }
}
