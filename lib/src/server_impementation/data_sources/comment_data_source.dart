// ignore_for_file: depend_on_referenced_packages

import 'package:responsive_admin_dashboard/src/infrastructure/shared_dtos/paging_options_dto.dart';
import 'package:responsive_admin_dashboard/src/server_impementation/databse_entities/databse_comment.dart';

import '../../features/comment/domain/comment.dart';
import '../../infrastructure/shared_dtos/response_dto.dart';
import '../../infrastructure/shared_models/shared_model.dart';
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
}
