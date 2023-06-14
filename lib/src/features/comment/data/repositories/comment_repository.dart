import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../domain/comment.dart';
import '../dtos/dtos.dart';

abstract class CommentRepository {
  Future<ResponseDTO<List<Comment>>> getComments(
      {required postId, required PagingOptionsDTO pagingOptionsDTO});

  Future<ResponseDTO<void>> sendComment(
      {required userToken,
      required userId,
      required SendCommentDTO sendCommentDTO});
}
