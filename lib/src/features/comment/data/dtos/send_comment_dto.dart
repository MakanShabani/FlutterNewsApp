class SendCommentDTO {
  SendCommentDTO({
    required this.postId,
    required this.content,
    this.replyToThisCommentId,
  });
  String postId;
  final String content;
  String? replyToThisCommentId;
}
