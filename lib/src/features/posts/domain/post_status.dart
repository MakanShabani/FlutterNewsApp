import 'package:flutter/foundation.dart';

import '../../../server_impementation/databse_entities/databse_entities.dart';

enum PostStatus {
  reviewing,
  published,
  suspended;

  factory PostStatus.fromIndex(int index) {
    if (index == 0) {
      return PostStatus.reviewing;
    } else if (index == 1) {
      return PostStatus.published;
    } else {
      return PostStatus.suspended;
    }
  }

  factory PostStatus.fromFakeDatabsePostStatus(
      DatabsePostStatus databsePostStatus) {
    switch (databsePostStatus) {
      case DatabsePostStatus.published:
        return PostStatus.published;
      case DatabsePostStatus.suspended:
        return PostStatus.suspended;
      case DatabsePostStatus.reviewing:
        return PostStatus.reviewing;
    }
  }
}

extension PostStatusExtensions on PostStatus {
  String get stringValue => toString().split('.').last;
}
