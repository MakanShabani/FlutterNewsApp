import 'entity.dart';
import 'post_category.dart';
import 'post_status.dart';
import 'user.dart';

class Post extends Entity {
  String title;
  String summary;
  String content;
  List<String>? imagesUrls;
  PostStatus status;
  PostCategory category;
  User author;
  bool isBookmarked;

  Post({
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
