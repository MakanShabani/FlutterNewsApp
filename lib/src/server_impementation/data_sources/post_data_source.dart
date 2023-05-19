// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';

import '../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../infrastructure/shared_models/shared_model.dart';
import '../databse_entities/databse_entities.dart';
import '../fake_database.dart';
import '../../features/posts/domain/posts_models.dart';

class PostDataSource {
  FakeDatabase fakeDatabase = FakeDatabase();

  ResponseDTO<List<Post>> getPosts(
      {String? userToken,
      String? categoryId,
      required PagingOptionsDTO pagingOptionsDTO}) {
    if (userToken != null) {
      //user token is not valid -- Unauthorized
      if (!fakeDatabase.isUserTokenValid(token: userToken)) {
        return ResponseDTO(
            statusCode: 401,
            error: ErrorModel.fromFakeDatabaseError(
                fakeDatabase.unAuthorizedError));
      }
    }

    if (categoryId != null) {
      //we send category posts

      //Category not exist
      if (!fakeDatabase.categories.any((element) => element.id == categoryId)) {
        return ResponseDTO(
            statusCode: 401,
            error: ErrorModel.fromFakeDatabaseError(
                fakeDatabase.categoryNotExist));
      }

      //get posts
      Iterable<DatabsePost> posts = fakeDatabase.posts
          .where((element) => element.category.id == categoryId)
          .sorted(
              (a, b) => b.createdAt.compareTo(a.createdAt)) //Descending order
          .skip(pagingOptionsDTO.offset)
          .take(pagingOptionsDTO.limit);

      //check each post bookmark status and modify it accordingly
      //if user has any bookmarked posts.
      if (userToken != null) {
        var userBookmarkedPostTableEntry =
            fakeDatabase.bookmarkedPostsTable.entries.firstWhereOrNull(
                (element) => element.key == fakeDatabase.sigendInUser!.id);
        if (userBookmarkedPostTableEntry != null) {
          for (var element in posts) {
            userBookmarkedPostTableEntry.value.contains(element.id)
                ? element.isBookmarked = true
                : element.isBookmarked = false;
          }
        }
      }

      //everything is ok

      //Convert databasepost to post object
      List<Post> finalPosts = List.empty(growable: true);
      for (var item in posts) {
        finalPosts.add(Post.fromFakeDatabsePost(item));
      }

      return ResponseDTO(
        statusCode: 200,
        data: finalPosts,
      );
    } else {
      //everything is ok so we send all category posts
      //Guest Mode

      //Convert databasepost to post object
      List<Post> finalPosts = List.empty(growable: true);
      for (var item in fakeDatabase.posts
          .sorted(
              (a, b) => b.createdAt.compareTo(a.createdAt)) //Descending order
          .skip(pagingOptionsDTO.offset)
          .take(pagingOptionsDTO.limit)
          .toList()) {
        finalPosts.add(Post.fromFakeDatabsePost(item));
      }

      return ResponseDTO(statusCode: 200, data: finalPosts);
    }
  }

  ResponseDTO<List<Post>> getAuthorPosts(
      {String? userToken,
      required String authorId,
      required PagingOptionsDTO pagingOptionsDTO}) {
    //Check authorization
    if (userToken != null) {
      if (!fakeDatabase.isUserTokenValid(token: userToken)) {
        return ResponseDTO(
            statusCode: 401,
            error: ErrorModel.fromFakeDatabaseError(
                fakeDatabase.unAuthorizedError));
      }
    }

    DatabaseUser? user =
        fakeDatabase.clients.firstWhereOrNull((u) => u.id == authorId);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'Author not found',
        detail: 'Author not found.',
        statusCode: 404,
      );

      return ResponseDTO(statusCode: 404, error: error);
    }

    //everything is ok

    //get posts
    Iterable<DatabsePost> posts = fakeDatabase.posts
        .where((p) => p.author.id == authorId)
        .skip(pagingOptionsDTO.offset)
        .take(pagingOptionsDTO.limit);

    if (userToken != null) {
      //check each post bookmark status and modify it accordingly
      //if user has any bookmarked posts.
      var userBookmarkedPostTableEntry =
          fakeDatabase.bookmarkedPostsTable.entries.firstWhereOrNull(
              (element) => element.key == fakeDatabase.sigendInUser!.id);
      if (userBookmarkedPostTableEntry != null) {
        for (var element in posts) {
          userBookmarkedPostTableEntry.value.contains(element.id)
              ? element.isBookmarked = true
              : element.isBookmarked = false;
        }
      }
    }

    //Convert databasepost to post object
    List<Post> finalPosts = List.empty(growable: true);
    for (var item in posts) {
      finalPosts.add(Post.fromFakeDatabsePost(item));
    }

    return ResponseDTO(
      statusCode: 200,
      data: finalPosts,
    );
  }

  ResponseDTO<Post> getPost({String? userToken, required postId}) {
    //user token is not valid -- Unauthorized
    if (userToken != null) {
      if (!fakeDatabase.isUserTokenValid(token: userToken)) {
        return ResponseDTO(
            statusCode: 401,
            error: ErrorModel.fromFakeDatabaseError(
                fakeDatabase.unAuthorizedError));
      }
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
    //check post bookmark status and modify it accordingly
    //if user has any bookmarked posts.
    if (userToken != null) {
      var userBookmarkedPostTableEntry =
          fakeDatabase.bookmarkedPostsTable.entries.firstWhereOrNull(
              (element) => element.key == fakeDatabase.sigendInUser!.id);
      if (userBookmarkedPostTableEntry != null) {
        userBookmarkedPostTableEntry.value.contains(post.id)
            ? post.isBookmarked = true
            : post.isBookmarked = false;
      }
    }

    return ResponseDTO(statusCode: 200, data: Post.fromFakeDatabsePost(post));
  }

  ResponseDTO<List<Post>> getUserBookmarkedPosts({
    required String userToken,
    required PagingOptionsDTO pagingOptionsDTO,
  }) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseDTO(
          statusCode: 401,
          error:
              ErrorModel.fromFakeDatabaseError(fakeDatabase.unAuthorizedError));
    }
    //everything is ok

    var userEntryInBookmarkedtable = fakeDatabase.bookmarkedPostsTable.entries
        .firstWhereOrNull(
            (element) => element.key == fakeDatabase.sigendInUser!.id);

    if (userEntryInBookmarkedtable == null) {
      // user has'nt any bookmarked posts

      return ResponseDTO(statusCode: 200, data: List.empty());
    }

    //Convert databasepost to post object
    List<Post> finalPosts = List.empty(growable: true);
    for (var item in userEntryInBookmarkedtable.value
        .map((e) => fakeDatabase.posts.firstWhereOrNull((p) => p.id == e)!
          ..isBookmarked = true)
        .skip(pagingOptionsDTO.offset)
        .take(pagingOptionsDTO.limit)
        .toList()) {
      finalPosts.add(Post.fromFakeDatabsePost(item));
    }

    return ResponseDTO(statusCode: 200, data: finalPosts);
  }
}
