import 'package:responsive_admin_dashboard/src/features/comment/data/repositories/comment_repository.dart';

import '../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../data/dtos/dtos.dart';

class CommentSendingService {
  CommentSendingService({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;
  final CommentRepository _commentRepository;

  Future<ResponseDTO<void>> sendComment(
      {required String userToken,
      required String userId,
      required SendCommentDTO sendCommentDTO}) async {
    //we write our core logic here to send a comment

    return await _commentRepository.sendComment(
        userToken: userToken, userId: userId, sendCommentDTO: sendCommentDTO);
  }
}
