enum UserRole {
  chiefEditor,
  writer,
  client;

  factory UserRole.fromIndex(int index) {
    if (index == 0) {
      return UserRole.chiefEditor;
    } else if (index == 1) {
      return UserRole.writer;
    } else {
      return UserRole.client;
    }
  }
}

extension UserRoleExtensions on UserRole {
  String get stringValue => toString().split('.').last;
}
