import '../../../infrastructure/shared_models/shared_model.dart';
import '../../../server_impementation/databse_entities/databse_entities.dart';
import '../../authors/domain/authors_models.dart';
import '../../posts_category/domain/post_category.dart';
import 'post_status.dart';

class Post extends Entity {
  String title;
  String summary;
  String content;
  List<String>? imagesUrls;
  PostStatus status;
  PostCategory category;
  Author author;
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

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    final Entity tempEntity = Entity.fromJson(parsedJson);
    final Author tempAuthor = Author.fromJson(parsedJson);
    final PostCategory tempPostCategory = PostCategory.fromJson(parsedJson);

    return Post(
      id: tempEntity.id,
      createdAt: tempEntity.createdAt,
      updatedAt: tempEntity.updatedAt,
      title: parsedJson['title'],
      summary: parsedJson['summary'],
      content: parsedJson['content'],
      category: tempPostCategory,
      author: tempAuthor,
      status: PostStatus.fromIndex(parsedJson['status']),
      isBookmarked: parsedJson['is_bookmarked'],
      imagesUrls: (parsedJson['images_urls'] as List<dynamic>?)?.cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();

    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['title'] = title;
    data['summary'] = summary;
    data['content'] = content;
    data['category'] = category;
    data['status'] = status;
    data['is_bookmarked'] = isBookmarked;
    data['author'] = author;
    data['images_urls'] = imagesUrls;

    return data;
  }

  factory Post.fromFakeDatabsePost(DatabsePost databsePost) {
    return Post(
      id: databsePost.id,
      createdAt: databsePost.createdAt,
      updatedAt: databsePost.updatedAt,
      title: databsePost.title,
      summary: databsePost.summary,
      content: databsePost.content,
      category: PostCategory.fromFakeDatabsePostCategory(databsePost.category),
      author: Author.fromFakeDatabseUser(databsePost.author),
      status: PostStatus.fromFakeDatabsePostStatus(databsePost.status),
      isBookmarked: databsePost.isBookmarked,
      imagesUrls: databsePost.imagesUrls,
    );
  }
}
