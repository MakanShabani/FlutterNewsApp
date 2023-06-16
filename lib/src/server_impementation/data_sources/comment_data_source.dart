// ignore_for_file: depend_on_referenced_packages

import 'dart:ffi';

import '../../features/comment/data/dtos/send_comment_dto.dart';
import '../../features/comment/domain/comment.dart';
import '../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../infrastructure/shared_models/shared_model.dart';
import '../databse_entities/databse_comment.dart';
import '../fake_database.dart';
import 'package:collection/collection.dart';

import '../databse_entities/databse_entities.dart';

class CommentDataSource {
  FakeDatabase fakeDatabase = FakeDatabase();

  ResponseDTO<List<Comment>> getComments(
      {required String postId, required PagingOptionsDTO pagingOptionsDTO}) {
    //check the existence of the post

    DatabsePost? post =
        fakeDatabase.posts.firstWhereOrNull((p) => p.id == postId);

    //Post not found
    if (post == null) {
      ErrorModel error = ErrorModel(
        message: 'Post not found',
        detail: 'Post not found.',
        statusCode: 404,
      );

      return ResponseDTO(statusCode: 404, error: error);
    }

    //everything is ok

    //load the post's comments

    List<DatabaseComment> databaseComments = fakeDatabase.comments
        .where((comment) => comment.postId == postId)
        .sorted((a, b) => b.createdAt.compareTo(a.createdAt)) //Descending order
        .skip(pagingOptionsDTO.offset)
        .take(pagingOptionsDTO.limit)
        .toList();

    //Convert databaseComment to Comment object
    List<Comment> finalComments = List.empty(growable: true);
    for (var item in databaseComments) {
      finalComments.add(Comment.fromDatabaseComment(item));
    }

    return ResponseDTO(statusCode: 200, data: finalComments);
  }

  ResponseDTO<int> getCommentsCount({required String postId}) {
    //check the existence of the post

    DatabsePost? post =
        fakeDatabase.posts.firstWhereOrNull((p) => p.id == postId);

    //Post not found
    if (post == null) {
      ErrorModel error = ErrorModel(
        message: 'Post not found',
        detail: 'Post not found.',
        statusCode: 404,
      );

      return ResponseDTO(statusCode: 404, error: error);
    }

    //everything is ok

    return ResponseDTO(
        statusCode: 200,
        data: fakeDatabase.comments
            .where((element) => element.id == postId)
            .toList()
            .length);
  }

  ResponseDTO<void> sendComment(
      {required String userToken, required SendCommentDTO sendCommentDTO}) {
    //check the user Token is valid and the user is signedIn
    if (fakeDatabase.sigendInUser?.token != userToken) {
      //user is not sigend in, so the user can not send any comments
      return ResponseDTO(
          statusCode: 401,
          error:
              ErrorModel.fromFakeDatabaseError(fakeDatabase.unAuthorizedError));
    }

    //Check whether the Post id is valid
    DatabsePost? post = fakeDatabase.posts
        .firstWhereOrNull((element) => element.id == sendCommentDTO.postId);
    if (post == null) {
      return ResponseDTO(
          statusCode: 404,
          error: ErrorModel(
            message: 'Post was not found',
            detail: 'Post was not found.',
            statusCode: 404,
          ));
    }

    // check whether its a reply comment to another comment or a new comment to a post
    if (sendCommentDTO.replyToThisCommentId == null) {
      //the comment is a new comment to the post

      //add the comment to database
      fakeDatabase.comments.add(DatabaseComment.fromSendCommentDTO(
          sendCommentDTO, fakeDatabase.sigendInUser!));

      return ResponseDTO(statusCode: 201);
    } else {
      //the comment is a reply to another comment of the post

      //Check whether the comment that the user wants to reply to it is exists
      DatabaseComment? existedComment = fakeDatabase.comments.firstWhereOrNull(
          (element) => element.id == sendCommentDTO.replyToThisCommentId!);
      if (existedComment == null) {
        //the comment is does not exists -->> we send back an error to the client
        return ResponseDTO(
            statusCode: 404,
            error: ErrorModel(
                message: 'Comment was not found',
                detail: 'Comment was not found',
                statusCode: 404));
      }

      //else everything is ok --> we add the reply to the reply list of the desired comment
      existedComment.replies.add(DatabaseComment.fromSendCommentDTO(
          sendCommentDTO, fakeDatabase.sigendInUser!));

      return ResponseDTO(statusCode: 201);
    }
  }
}
