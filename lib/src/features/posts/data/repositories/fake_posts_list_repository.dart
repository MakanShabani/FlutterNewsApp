import 'package:responsive_admin_dashboard/src/features/posts/domain/post.dart';

import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../data_sources/post_data_sources.dart';
import 'posts_repository.dart';

class FakePostReposiory implements PostsRepository {
  FakePostReposiory(
      {required this.fetchDelayDurationInSeconds,
      required this.toggleBookmarkDelay,
      required FakePostsDataSource fakePostsDataSource})
      : _fakePostDataSource = fakePostsDataSource;

  final FakePostsDataSource _fakePostDataSource;
  final int fetchDelayDurationInSeconds;
  final int toggleBookmarkDelay;

  @override
  Future<ResponseDTO<List<Post>>> getAuthorPosts(
      {required String userToken,
      required String authorId,
      required PagingOptionsDTO pagingOptionsDTO}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => _fakePostDataSource.getAuthorPosts(
              userToken: userToken,
              authorId: authorId,
              pagingOptionsDTO: pagingOptionsDTO,
            ));
  }

  @override
  Future<ResponseDTO<Post>> getPost(
      {required userToken, required postId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () =>
            _fakePostDataSource.getPost(userToken: userToken, postId: postId));
  }

  @override
  Future<ResponseDTO<List<Post>>> getPosts(
      {required String userToken,
      required PagingOptionsDTO pagingOptionsDTO,
      String? categoryId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => _fakePostDataSource.getPosts(
              userToken: userToken,
              categoryId: categoryId,
              pagingOptionsDTO: pagingOptionsDTO,
            ));
  }

  @override
  Future<ResponseDTO<List<Post>>> getBookmarkedPosts(
      {required String userToken,
      required PagingOptionsDTO pagingOptionsDTO}) async {
    return await Future.delayed(
      Duration(seconds: fetchDelayDurationInSeconds),
      () => _fakePostDataSource.getUserBookmarkedPosts(
          userToken: userToken, pagingOptionsDTO: pagingOptionsDTO),
    );
  }

  @override
  Future<ResponseDTO<List<Post>>> getAuthorPostsAsGuest(
      {required String authorId,
      required PagingOptionsDTO pagingOptionsDTO}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => _fakePostDataSource.getAuthorPosts(
              authorId: authorId,
              pagingOptionsDTO: pagingOptionsDTO,
            ));
  }

  @override
  Future<ResponseDTO<Post>> getPostAsGuest({required postId}) async {
    return await Future.delayed(Duration(seconds: fetchDelayDurationInSeconds),
        () => _fakePostDataSource.getPost(postId: postId));
  }

  @override
  Future<ResponseDTO<List<Post>>> getPostsAsguest(
      {required PagingOptionsDTO pagingOptionsDTO, String? categoryId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => _fakePostDataSource.getPosts(
              categoryId: categoryId,
              pagingOptionsDTO: pagingOptionsDTO,
            ));
  }
}
