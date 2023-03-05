import 'databse_entities.dart';
import 'databse_entity.dart';

class DatabaseComment extends DatabaseEntity {
  final String postId;
  final DatabaseUser user;
  final String content;
  final List<DatabaseComment>? replies;
  DatabaseComment({
    required super.id,
    required this.postId,
    required super.createdAt,
    required super.updatedAt,
    required this.content,
    required this.user,
    this.replies,
  });
}
