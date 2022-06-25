import 'package:responsive_admin_dashboard/models/entities/post.dart';

import 'entity.dart';
import 'user_role.dart';
import 'user_status.dart';

class User extends Entity {
  String firstName;
  String lastName;
  String email;
  String? password;
  int age;
  String? phone;
  String? imageUr;
  UserRole role;
  UserStatus status;
  List<Post>? posts;

  User({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.firstName,
    required this.lastName,
    this.password,
    required this.age,
    required this.email,
    required this.role,
    required this.status,
    this.phone,
    this.imageUr,
    this.posts,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
}
