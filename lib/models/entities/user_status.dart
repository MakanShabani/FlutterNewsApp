enum UserStatus {
  active,
  suspended,
  banned;

  factory UserStatus.fromIndex(int index) {
    if (index == 0) {
      return UserStatus.active;
    } else if (index == 1) {
      return UserStatus.suspended;
    } else {
      return UserStatus.banned;
    }
  }
}

extension UserStatusExtensions on UserStatus {
  String get stringValue => toString().split('.').last;
}
