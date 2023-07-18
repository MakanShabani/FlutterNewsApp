// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/shared_dtos/shared_dtos.dart';

import '../../../../../infrastructure/shared_models/shared_model.dart';
import '../../../application/comment_application.dart';
import '../../../data/dtos/send_comment_dto.dart';

part 'send_comment_state.dart';

class SendCommentCubit extends Cubit<SendCommentState> {
  SendCommentCubit({required CommentSendingService sendCommentService})
      : _sendCommentService = sendCommentService,
        super(SendCommentInitialState());

  final CommentSendingService _sendCommentService;

  void sendComment(
      {required String userToken,
      required String userId,
      required SendCommentDTO sendCommentDTO}) async {
    //do nothing another sending is in progress
    if (state is SendCommentSendingState) {
      return;
    }

    //everything is ok, we can send our new comment to the server

    //change the state to sending mode
    if (!isClosed) {
      emit(SendCommentSendingState(sendCommentDTO: sendCommentDTO));
    }
    // send the comment to the server via sendCommentService and get the response from the server
    ResponseDTO<void> responseDTO = await _sendCommentService.sendComment(
        userToken: userToken, userId: userId, sendCommentDTO: sendCommentDTO);

    //process the response
    if (responseDTO.statusCode == 201) {
      //we successfully sent the comment to the server
      //set state to Sent mode
      if (!isClosed) {
        emit(SendCommentSentState(sendCommentDTO: sendCommentDTO));
        return;
      }
    } else {
      // we have error and could not send the comment successfully to the server
      //set state to Error mode
      if (!isClosed) {
        emit(SendCommentSendingHasErrorState(
            sendCommentDTO: sendCommentDTO, errorModel: responseDTO.error!));
        return;
      }
    }
  }
}
