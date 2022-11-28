enum DatabseUserRole {
  chiefEditor,
  writer,
  client;

  factory DatabseUserRole.fromIndex(int index) {
    if (index == 0) {
      return DatabseUserRole.chiefEditor;
    } else if (index == 1) {
      return DatabseUserRole.writer;
    } else {
      return DatabseUserRole.client;
    }
  }
}

extension UserRoleExtensions on DatabseUserRole {
  String get stringValue => toString().split('.').last;
}
