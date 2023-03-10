import 'databse_entity.dart';
import 'databse_post.dart';
import 'databse_user_role.dart';
import 'databse_user_status.dart';

class DatabaseUser extends DatabaseEntity {
  String firstName;
  String lastName;
  String email;
  String? password;
  int? age;
  String? phone;
  String? imageUrl;
  String? token;
  DateTime? tokenExpiresAt;
  DatabseUserRole role;
  DatabseUserStatus status;
  List<DatabsePost>? posts;

  DatabaseUser({
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
    this.token,
    this.tokenExpiresAt,
    this.phone,
    this.imageUrl,
    this.posts,
  });

  factory DatabaseUser.fromJson(Map<String, dynamic> parsedJson) {
    final DatabaseUser tempEntity = DatabaseUser.fromJson(parsedJson);

    return DatabaseUser(
      id: tempEntity.id,
      createdAt: tempEntity.createdAt,
      updatedAt: tempEntity.updatedAt,
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      password: parsedJson['password'],
      age: parsedJson['age'],
      email: parsedJson['email'],
      role: DatabseUserRole.fromIndex(parsedJson['role']),
      status: DatabseUserStatus.fromIndex(parsedJson['status']),
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
    data['token'] = token;
    data['token_expires_at'] = tokenExpiresAt;
    return data;
  }
}
