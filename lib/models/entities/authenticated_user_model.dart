import 'user.dart';

class AuthenticatedUserModel extends User {
  String token;
  DateTime expirationDate;

  AuthenticatedUserModel(
      {required this.token, required this.expirationDate, required User user})
      : super(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          age: user.age,
          email: user.email,
          role: user.role,
          status: user.status,
          imageUr: user.imageUr,
          phone: user.phone,
          posts: user.posts,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        );
}
