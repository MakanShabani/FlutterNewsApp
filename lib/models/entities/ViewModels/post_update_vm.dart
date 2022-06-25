import 'dart:io';

import '../post_category.dart';

class PostUpdateVm {
  String? title;
  String? summary;
  String? description;
  PostCategory? category;
  List<File>? imagesFiles;

  PostUpdateVm({
    this.title,
    this.summary,
    this.description,
    this.category,
    this.imagesFiles,
  });
}
