import '../../features/comment/data/dtos/dtos.dart';
import 'databse_entities.dart';
import 'databse_entity.dart';

class DatabaseComment extends DatabaseEntity {
  final String postId;
  final DatabaseUser user;
  final String content;
  final List<DatabaseComment> replies;
  DatabaseComment({
    required super.id,
    required this.postId,
    required super.createdAt,
    required super.updatedAt,
    required this.content,
    required this.user,
    required this.replies,
  });

  factory DatabaseComment.fromSendCommentDTO(
      SendCommentDTO sendCommentDTO, DatabaseUser databaseUser) {
    return DatabaseComment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        postId: sendCommentDTO.postId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        content: sendCommentDTO.content,
        replies: List.empty(growable: true),
        user: databaseUser);
  }
}
