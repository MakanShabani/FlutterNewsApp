// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';

import '../entities/ViewModels/view_models.dart';
import '../entities/entities.dart';
import 'fake_database.dart';

class FakePostDataSource {
  FakeDatabase fakeDatabase = FakeDatabase();

  ResponseModel<List<Post>> getPosts(
      {required String userToken,
      String? categoryId,
      required PagingOptionsVm pagingOptionsVm}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.authenticatedUser!.id);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );
      return ResponseModel(statusCode: 404, error: error);
    }

    if (categoryId != null) {
      //we send category posts

      //Category not exist
      if (!fakeDatabase.categories.any((element) => element.id == categoryId)) {
        return ResponseModel(
            statusCode: 401, error: fakeDatabase.categoryNotExist);
      }

      //get posts
      Iterable<Post> posts = fakeDatabase.posts
          .where((element) => element.category.id == categoryId)
          .sorted(
              (a, b) => b.createdAt.compareTo(a.createdAt)) //Descending order
          .skip(pagingOptionsVm.offset)
          .take(pagingOptionsVm.limit);

      //check each post bookmark status and modify it accordingly
      //if user has any bookmarked posts.
      var userBookmarkedPostTableEntry = fakeDatabase
          .bookmarkedPostsTable.entries
          .firstWhereOrNull((element) => element.key == user.id);
      if (userBookmarkedPostTableEntry != null) {
        for (var element in posts) {
          userBookmarkedPostTableEntry.value.contains(element.id)
              ? element.isBookmarked = true
              : element.isBookmarked = false;
        }
      }

      //everything is ok
      return ResponseModel(
        statusCode: 200,
        data: posts.toList(),
      );
    } else {
      //everything is ok so we send all category posts

      return ResponseModel(
          statusCode: 200,
          data: fakeDatabase.posts
              .sorted((a, b) =>
                  b.createdAt.compareTo(a.createdAt)) //Descending order
              .skip(pagingOptionsVm.offset)
              .take(pagingOptionsVm.limit)
              .toList());
    }
  }

  ResponseModel<List<Post>> getSlides(
      {required String userToken,
      String? categoryId,
      required PagingOptionsVm pagingOptionsVm}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    if (categoryId != null) {
      //we send category posts

      //Category not exist
      if (!fakeDatabase.categories.any((element) => element.id == categoryId)) {
        return ResponseModel(
            statusCode: 401, error: fakeDatabase.categoryNotExist);
      }

      //everything is ok
      return ResponseModel(
          statusCode: 200,
          data: fakeDatabase.posts
              .where((element) => element.category.id == categoryId)
              .sorted((a, b) =>
                  b.createdAt.compareTo(a.createdAt)) //Descending order
              .skip(pagingOptionsVm.offset)
              .take(pagingOptionsVm.limit)
              .toList());
    } else {
      //everything is ok so we send all category posts

      return ResponseModel(
          statusCode: 200,
          data: fakeDatabase.posts
              .sorted((a, b) =>
                  b.createdAt.compareTo(a.createdAt)) //Descending order
              .skip(pagingOptionsVm.offset)
              .take(pagingOptionsVm.limit)
              .toList());
    }
  }

  ResponseModel<List<Post>> getAuthorPosts(
      {required String userToken,
      required String userId,
      required PagingOptionsVm pagingOptionsVm}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users.firstWhereOrNull((u) => u.id == userId);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'Author not found',
        detail: 'Author not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    //everything is ok

    //get posts
    Iterable<Post> posts = fakeDatabase.posts
        .where((p) => p.author.id == userId)
        .skip(pagingOptionsVm.offset)
        .take(pagingOptionsVm.limit);

    //check each post bookmark status and modify it accordingly
    //if user has any bookmarked posts.
    var userBookmarkedPostTableEntry = fakeDatabase.bookmarkedPostsTable.entries
        .firstWhereOrNull((element) => element.key == user.id);
    if (userBookmarkedPostTableEntry != null) {
      for (var element in posts) {
        userBookmarkedPostTableEntry.value.contains(element.id)
            ? element.isBookmarked = true
            : element.isBookmarked = false;
      }
    }

    return ResponseModel(
      statusCode: 200,
      data: posts.toList(),
    );
  }

  ResponseModel<Post> getPost({required String userToken, required postId}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.authenticatedUser!.id);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );
      return ResponseModel(statusCode: 404, error: error);
    }

    Post? post = fakeDatabase.posts.firstWhereOrNull((p) => p.id == postId);

    //Post not found
    if (post == null) {
      ErrorModel error = ErrorModel(
        message: 'Post not found',
        detail: 'Post not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    //everything is ok

    //check post bookmark status and modify it accordingly
    //if user has any bookmarked posts.
    var userBookmarkedPostTableEntry = fakeDatabase.bookmarkedPostsTable.entries
        .firstWhereOrNull((element) => element.key == user.id);
    if (userBookmarkedPostTableEntry != null) {
      userBookmarkedPostTableEntry.value.contains(post.id)
          ? post.isBookmarked = true
          : post.isBookmarked = false;
    }

    return ResponseModel(statusCode: 200, data: post);
  }

  ResponseModel<Post> createPost(
      {required String userToken, required PostCreationVm postCreationVm}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.authenticatedUser!.id);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    //everything is ok
    Post post = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      title: postCreationVm.title,
      summary: postCreationVm.summary,
      content: postCreationVm.description,
      status: PostStatus.reviewing,
      category: postCreationVm.category,
      author: user,
      isBookmarked: false,
    );

    return ResponseModel(statusCode: 200, data: post);
  }

  ResponseModel<Post> updatePost(
      {required String userToken,
      required String postId,
      required PostUpdateVm postUpdateVm}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.authenticatedUser!.id);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    Post? post = fakeDatabase.posts.firstWhereOrNull((p) => p.id == postId);

    //Post not found
    if (post == null) {
      ErrorModel error = ErrorModel(
        message: 'Post not found',
        detail: 'Post not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    if (post.author.id != fakeDatabase.authenticatedUser!.id) {
      ErrorModel error = ErrorModel(
        message: 'Permission denied',
        detail: 'You have no authority to update this post.',
        statusCode: 403,
      );

      return ResponseModel(statusCode: 403, error: error);
    }

    //everything is ok

    if (postUpdateVm.title?.isNotEmpty ?? false) {
      post.title = postUpdateVm.title!;
    }
    if (postUpdateVm.summary?.isNotEmpty ?? false) {
      post.summary = postUpdateVm.summary!;
    }
    if (postUpdateVm.description?.isNotEmpty ?? false) {
      post.content = postUpdateVm.description!;
    }
    if (postUpdateVm.category != null) {
      post.category = postUpdateVm.category!;
    }
    if (postUpdateVm.imagesFiles != null) {
      // update images
    }

    return ResponseModel(statusCode: 200, data: post);
  }

  ResponseModel<void> deletePost({required String userToken, required postId}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.authenticatedUser!.id);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    Post? post = fakeDatabase.posts.firstWhereOrNull((p) => p.id == postId);

    //Post not found
    if (post == null) {
      ErrorModel error = ErrorModel(
        message: 'Post not found',
        detail: 'Post not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    if (post.author.id != user.id) {
      ErrorModel error = ErrorModel(
        message: 'Permission denied',
        detail: 'You have no authority to delete this post.',
        statusCode: 403,
      );

      return ResponseModel(statusCode: 403, error: error);
    }

    //everything is ok

    fakeDatabase.posts.remove(post);

    return ResponseModel(statusCode: 204);
  }

  ResponseModel<void> toggleBookmarkPost(
      {required String userToken, required String postId}) {
//user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.authenticatedUser!.id);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }

    Post? post = fakeDatabase.posts.firstWhereOrNull((p) => p.id == postId);

    //Post not found
    if (post == null) {
      ErrorModel error = ErrorModel(
        message: 'Post not found',
        detail: 'Post not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
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

          value.add(postId);
        }
        return value;
      },
      //we'll add this user to bookmarked table  if it doesn't exist in the table
      //the list must be growable for updating purposes
      ifAbsent: () => List.empty(growable: true)..add(postId),
    );

    return ResponseModel(statusCode: 204);
  }

  ResponseModel<List<Post>> getUserBookmarkedPosts({
    required String userToken,
    required PagingOptionsVm pagingOptionsVm,
  }) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    User? user = fakeDatabase.users
        .firstWhereOrNull((u) => u.id == fakeDatabase.authenticatedUser!.id);

    //User not found
    if (user == null) {
      ErrorModel error = ErrorModel(
        message: 'User not found',
        detail: 'User not found.',
        statusCode: 404,
      );

      return ResponseModel(statusCode: 404, error: error);
    }
    //everything is ok

    var userEntryInBookmarkedtable = fakeDatabase.bookmarkedPostsTable.entries
        .firstWhereOrNull((element) => element.key == user.id);

    if (userEntryInBookmarkedtable == null) {
      // user has'nt any bookmarked posts

      return ResponseModel(statusCode: 200, data: List.empty());
    }

    return ResponseModel(
        statusCode: 200,
        data: userEntryInBookmarkedtable.value
            .map((e) => fakeDatabase.posts.firstWhereOrNull((p) => p.id == e)!
              ..isBookmarked = true)
            .skip(pagingOptionsVm.offset)
            .take(pagingOptionsVm.limit)
            .toList());
  }
}
