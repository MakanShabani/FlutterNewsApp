part of 'send_comment_cubit.dart';

@immutable
abstract class SendCommentState {}

class SendCommentInitialState extends SendCommentState {}

class SendCommentSendingState extends SendCommentState {
  SendCommentSendingState({required this.sendCommentDTO});

  final SendCommentDTO sendCommentDTO;
}

class SendCommentSentState extends SendCommentState {
  SendCommentSentState({required this.sendCommentDTO});
  final SendCommentDTO sendCommentDTO;
}

class SendCommentSendingHasErrorState extends SendCommentState {
  SendCommentSendingHasErrorState(
      {required this.sendCommentDTO, required this.errorModel});
  final SendCommentDTO sendCommentDTO;
  final ErrorModel errorModel;
}
