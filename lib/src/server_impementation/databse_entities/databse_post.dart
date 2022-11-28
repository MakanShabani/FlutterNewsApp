import 'databse_entity.dart';
import 'databse_post_category.dart';
import 'databse_post_status.dart';
import 'database_user.dart';

class DatabsePost extends DatabaseEntity {
  String title;
  String summary;
  String content;
  List<String>? imagesUrls;
  DatabsePostStatus status;
  DatabasePostCategory category;
  DatabaseUser author;
  bool isBookmarked;

  DatabsePost({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.author,
    required this.status,
    required this.isBookmarked,
    this.imagesUrls,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
}
