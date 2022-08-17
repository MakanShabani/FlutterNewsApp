import 'user.dart';

class AuthenticatedUserModel extends User {
  String token;
  DateTime expireAt;

  AuthenticatedUserModel(
      {required this.token, required this.expireAt, required User user})
      : super(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          age: user.age,
          email: user.email,
          role: user.role,
          status: user.status,
          imageUrl: user.imageUrl,
          phone: user.phone,
          posts: user.posts,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        );

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> parsedJson) =>
      AuthenticatedUserModel(
        token: parsedJson['token'],
        expireAt: parsedJson['expire_at'],
        user: User.fromJson(parsedJson),
      );
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['token'] = token;
    data['expire_at'] = expireAt;
    return data;
  }
}
