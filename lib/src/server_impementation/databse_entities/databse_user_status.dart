enum DatabseUserStatus {
  active,
  suspended,
  banned;

  factory DatabseUserStatus.fromIndex(int index) {
    if (index == 0) {
      return DatabseUserStatus.active;
    } else if (index == 1) {
      return DatabseUserStatus.suspended;
    } else {
      return DatabseUserStatus.banned;
    }
  }
}

extension UserStatusExtensions on DatabseUserStatus {
  String get stringValue => toString().split('.').last;
}
