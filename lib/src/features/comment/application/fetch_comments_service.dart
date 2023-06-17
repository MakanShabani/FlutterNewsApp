import '../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../data/repositories/repositories.dart';
import '../domain/comment.dart';

class FetchCommentsService {
  FetchCommentsService({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;
  final CommentRepository _commentRepository;

  Future<ResponseDTO<List<Comment>>> getComments(
      {required postId, required PagingOptionsDTO pagingOptionsDTO}) async {
    //we write our core logic here to get list of comments
    return await _commentRepository.getComments(
        postId: postId, pagingOptionsDTO: pagingOptionsDTO);
  }

  Future<ResponseDTO<List<Comment>>> getCommentReplies(
      {required commentId, required PagingOptionsDTO pagingOptionsDTO}) async {
    //we write our core logic here to get list of replies to a specific comment

    return await _commentRepository.getCommentReplies(
        commentId: commentId, pagingOptionsDTO: pagingOptionsDTO);
  }
}
