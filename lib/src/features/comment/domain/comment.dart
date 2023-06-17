import 'package:responsive_admin_dashboard/src/infrastructure/shared_models/entity.dart';
import 'package:responsive_admin_dashboard/src/server_impementation/databse_entities/databse_comment.dart';

class Comment extends Entity {
  final String userId;
  final String userName;
  final String userLastName;
  final String? userImageUrl;
  final String content;
  final List<Comment>? replies;

  Comment({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.userId,
    required this.userName,
    required this.userLastName,
    this.userImageUrl,
    required this.content,
    this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    final Entity tempEntity = Entity.fromJson(parsedJson);

    return Comment(
        id: tempEntity.id,
        createdAt: tempEntity.createdAt,
        updatedAt: tempEntity.updatedAt,
        userId: parsedJson['user_id'],
        userName: parsedJson['user_name'],
        userLastName: parsedJson['user_lastName'],
        userImageUrl: parsedJson['user_image_url'],
        content: parsedJson['content'],
        replies: (parsedJson['repiles'] as List<dynamic>?)?.cast<Comment>());
  }

  factory Comment.fromDatabaseComment(DatabaseComment databaseComment) {
    List<Comment> replies = List.empty(growable: true);

    for (var element in databaseComment.replies) {
      replies.add(Comment.fromDatabaseComment(element));
    }

    return Comment(
      id: databaseComment.id,
      createdAt: databaseComment.createdAt,
      updatedAt: databaseComment.updatedAt,
      userId: databaseComment.user.id,
      userName: databaseComment.user.firstName,
      userLastName: databaseComment.user.lastName,
      userImageUrl: databaseComment.user.imageUrl,
      content: databaseComment.content,
      replies: replies,
    );
  }
}
