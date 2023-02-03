// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';

import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../infrastructure/shared_models/shared_model.dart';
import '../../../../server_impementation/databse_entities/databse_entities.dart';
import '../../../../server_impementation/fake_database.dart';

class FakeBookmarkDataSource {
  FakeDatabase fakeDatabase = FakeDatabase();

  ResponseDTO<void> toggleBookmarkPost(
      {required String userToken, required String postId}) {
//user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseDTO(
          statusCode: 401,
          error:
              ErrorModel.fromFakeDatabaseError(fakeDatabase.unAuthorizedError));
    }

    DatabaseUser? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.sigendInUserID);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );

      return ResponseDTO(statusCode: 404, error: error);
    }

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

    fakeDatabase.bookmarkedPostsTable.update(
      user.id,
      (value) {
        if (value.contains(postId)) {
          //we'll unbookmark the post
          value.remove(postId);
        } else {
          //we'll bookmark the post

          value.insert(0, postId);
        }
        return value;
      },
      //we'll add this user to bookmarked table  if it doesn't exist in the table
      //the list must be growable for updating purposes
      ifAbsent: () => List.empty(growable: true)..add(postId),
    );

    return ResponseDTO(statusCode: 204);
  }
}
