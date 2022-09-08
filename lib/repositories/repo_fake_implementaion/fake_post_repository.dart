import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../data_source/fake_data_source/fake_data_source.dart';
import '../post_repository.dart';

class FakePostReposiory implements PostRepository {
  FakePostReposiory({
    required this.fetchDelayDurationInSeconds,
    required this.toggleBookmarkDelay,
  });

  FakePostDataSource fakePostDataSource = FakePostDataSource();
  final int fetchDelayDurationInSeconds;
  final int toggleBookmarkDelay;

  @override
  Future<ResponseModel<Post>> createPost(
      {required String userToken,
      required PostCreationVm postCreationVm}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.createPost(
            userToken: userToken, postCreationVm: postCreationVm));
  }

  @override
  Future<ResponseModel<void>> deletePost(
      {required String userToken, required postId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.deletePost(
            userToken: userToken, postId: postId));
  }

  @override
  Future<ResponseModel<List<Post>>> getAuthorPosts(
      {required String userToken,
      required String authorId,
      required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getAuthorPosts(
              userToken: userToken,
              authorId: authorId,
              pagingOptionsVm: pagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<Post>> getPost(
      {required userToken, required postId}) async {
    return await Future.delayed(Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getPost(userToken: userToken, postId: postId));
  }

  @override
  Future<ResponseModel<List<Post>>> getPosts(
      {required String userToken,
      required PagingOptionsVm pagingOptionsVm,
      String? categoryId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getPosts(
              userToken: userToken,
              categoryId: categoryId,
              pagingOptionsVm: pagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<Post>> updatePost(
      {required String userToken,
      required String postId,
      required PostUpdateVm postUpdateVm}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.updatePost(
              userToken: userToken,
              postId: postId,
              postUpdateVm: postUpdateVm,
            ));
  }

  @override
  Future<ResponseModel<List<Post>>> getSlides(
      {String? categoryId,
      required PagingOptionsVm slidePagingOptionsVm}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getSlides(
              categoryId: categoryId,
              pagingOptionsVm: slidePagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<List<Post>>> getBookmarkedPosts(
      {required String userToken,
      required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
      Duration(seconds: fetchDelayDurationInSeconds),
      () => fakePostDataSource.getUserBookmarkedPosts(
          userToken: userToken, pagingOptionsVm: pagingOptionsVm),
    );
  }

  @override
  Future<ResponseModel<void>> toggleBookmark(
      {required String userToken, required String postId}) async {
    return await Future.delayed(
      Duration(seconds: toggleBookmarkDelay),
      () => fakePostDataSource.toggleBookmarkPost(
        userToken: userToken,
        postId: postId,
      ),
    );
  }

  @override
  Future<ResponseModel<List<Post>>> getAuthorPostsAsGuest(
      {required String authorId,
      required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getAuthorPosts(
              authorId: authorId,
              pagingOptionsVm: pagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<Post>> getPostAsGuest({required postId}) async {
    return await Future.delayed(Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getPost(postId: postId));
  }

  @override
  Future<ResponseModel<List<Post>>> getPostsAsguest(
      {required PagingOptionsVm pagingOptionsVm, String? categoryId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getPosts(
              categoryId: categoryId,
              pagingOptionsVm: pagingOptionsVm,
            ));
  }
}
