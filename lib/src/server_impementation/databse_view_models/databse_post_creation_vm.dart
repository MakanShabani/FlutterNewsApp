import 'dart:io';

import '../databse_entities/databse_entities.dart';

class PostCreationVm {
  String title;
  String summary;
  String description;
  DatabasePostCategory category;
  List<File>? imagesUrls;

  PostCreationVm({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.title,
    required this.summary,
    required this.description,
    required this.category,
    this.imagesUrls,
  });
}
