import 'dart:io';

class UserRegisterVm {
  String firstName;
  String lastName;
  String email;
  int age;
  String? phone;
  File? avatarImage;

  UserRegisterVm({
    required String id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    this.phone,
    this.avatarImage,
  });
}
