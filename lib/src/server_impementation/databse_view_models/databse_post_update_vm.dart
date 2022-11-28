import 'dart:io';

import '../databse_entities/databse_entities.dart';

class PostUpdateVm {
  String? title;
  String? summary;
  String? description;
  DatabasePostCategory? category;
  List<File>? imagesFiles;

  PostUpdateVm({
    this.title,
    this.summary,
    this.description,
    this.category,
    this.imagesFiles,
  });
}
