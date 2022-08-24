import '../../../logged_in_user_info.dart';
import '../../models/entities/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../data_source/fake_data_source/fake_data_source.dart';
import '../post_repository.dart';

class FakePostReposiory implements PostRepository {
  FakePostReposiory({
    required this.fetchDelayDurationInSeconds,
    required this.toggleBookmarkDelay,
  });

  LoggedInUserInfo user = LoggedInUserInfo();
  FakePostDataSource fakePostDataSource = FakePostDataSource();
  final int fetchDelayDurationInSeconds;
  final int toggleBookmarkDelay;

  @override
  Future<ResponseModel<Post>> createPost(
      {required PostCreationVm postCreationVm}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.createPost(
            userToken: user.authenticatedUser!.token,
            postCreationVm: postCreationVm));
  }

  @override
  Future<ResponseModel<void>> deletePost({required postId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.deletePost(
            userToken: user.authenticatedUser!.token, postId: postId));
  }

  @override
  Future<ResponseModel<List<Post>>> getAuthorPosts(
      {required String userId,
      required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getAuthorPosts(
              userToken: user.authenticatedUser!.token,
              userId: userId,
              pagingOptionsVm: pagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<Post>> getPost({required postId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getPost(
            userToken: user.authenticatedUser!.token, postId: postId));
  }

  @override
  Future<ResponseModel<List<Post>>> getPosts(
      {required PagingOptionsVm pagingOptionsVm, String? categoryId}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.getPosts(
              userToken: user.authenticatedUser!.token,
              categoryId: categoryId,
              pagingOptionsVm: pagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<Post>> updatePost(
      {required String postId, required PostUpdateVm postUpdateVm}) async {
    return await Future.delayed(
        Duration(seconds: fetchDelayDurationInSeconds),
        () => fakePostDataSource.updatePost(
              userToken: user.authenticatedUser!.token,
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
              userToken: user.authenticatedUser!.token,
              pagingOptionsVm: slidePagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<List<Post>>> getBookmarkedPosts(
      {required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
      Duration(seconds: fetchDelayDurationInSeconds),
      () => fakePostDataSource.getUserBookmarkedPosts(
          userToken: user.authenticatedUser!.token,
          pagingOptionsVm: pagingOptionsVm),
    );
  }

  @override
  Future<ResponseModel<void>> toggleBookmark({required String postId}) async {
    return await Future.delayed(
      Duration(seconds: toggleBookmarkDelay),
      () => fakePostDataSource.toggleBookmarkPost(
        userToken: user.authenticatedUser!.token,
        postId: postId,
      ),
    );
  }
}
