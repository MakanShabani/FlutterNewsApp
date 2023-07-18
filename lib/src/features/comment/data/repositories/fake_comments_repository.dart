import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../server_impementation/data_sources/comment_data_source.dart';
import '../../domain/comment.dart';

import '../dtos/send_comment_dto.dart';

import 'comment_repository.dart';

class FakeCommentsRepository implements CommentRepository {
  FakeCommentsRepository(
      {required this.delayDurationInSeconds,
      required CommentDataSource commentDataSource})
      : _commentDataSource = commentDataSource;
  final CommentDataSource _commentDataSource;
  final int delayDurationInSeconds;
  @override
  Future<ResponseDTO<List<Comment>>> getComments(
      {required postId, required PagingOptionsDTO pagingOptionsDTO}) async {
    return await Future.delayed(
        Duration(seconds: delayDurationInSeconds),
        () => _commentDataSource.getComments(
            postId: postId, pagingOptionsDTO: pagingOptionsDTO));
  }

  @override
  Future<ResponseDTO<void>> sendComment(
      {required userToken,
      required userId,
      required SendCommentDTO sendCommentDTO}) async {
    return await Future.delayed(
        Duration(seconds: delayDurationInSeconds),
        () => _commentDataSource.sendComment(
            userToken: userToken, sendCommentDTO: sendCommentDTO));
  }

  @override
  Future<ResponseDTO<List<Comment>>> getCommentReplies(
      {required commentId, required PagingOptionsDTO pagingOptionsDTO}) async {
    return await Future.delayed(
        Duration(seconds: delayDurationInSeconds),
        () => _commentDataSource.getCommentReplies(
            commentId: commentId, pagingOptionsDTO: pagingOptionsDTO));
  }
}
