import 'dart:io';

class UserUpdateVm {
  String? firstName;
  String? lastName;
  File? avatarImage;
  int? age;

  UserUpdateVm({
    this.firstName,
    this.lastName,
    this.age,
    this.avatarImage,
  });
}
