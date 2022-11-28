import 'dart:io';

class UserRegisterDTO {
  String firstName;
  String lastName;
  String email;
  int age;
  String? phone;
  File? avatarImage;

  UserRegisterDTO({
    required String id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    this.phone,
    this.avatarImage,
  });
}
