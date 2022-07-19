import '../../../user_credentials.dart';
import '../../entities/ViewModels/view_models.dart';
import '../../entities/entities.dart';
import '../../fake_data_source/fake_data_source.dart';
import '../post_repository.dart';

class FakePostReposiory implements PostRepository {
  UserCredentials credentials = UserCredentials();
  FakePostDataSource fakePostDataSource = FakePostDataSource();

  @override
  Future<ResponseModel<Post>> createPost(
      {required PostCreationVm postCreationVm}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakePostDataSource.createPost(
            userToken: credentials.credentials!.token,
            postCreationVm: postCreationVm));
  }

  @override
  Future<ResponseModel<void>> deletePost({required postId}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakePostDataSource.deletePost(
            userToken: credentials.credentials!.token, postId: postId));
  }

  @override
  Future<ResponseModel<List<Post>>> getAuthorPosts(
      {required String userId,
      required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakePostDataSource.getAuthorPosts(
              userToken: credentials.credentials!.token,
              userId: userId,
              pagingOptionsVm: pagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<Post>> getPost({required postId}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakePostDataSource.getPost(
            userToken: credentials.credentials!.token, postId: postId));
  }

  @override
  Future<ResponseModel<List<Post>>> getPosts(
      {required PagingOptionsVm pagingOptionsVm, String? categoryId}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakePostDataSource.getPosts(
              userToken: credentials.credentials!.token,
              categoryId: categoryId,
              pagingOptionsVm: pagingOptionsVm,
            ));
  }

  @override
  Future<ResponseModel<Post>> updatePost(
      {required String postId, required PostUpdateVm postUpdateVm}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakePostDataSource.updatePost(
              userToken: credentials.credentials!.token,
              postId: postId,
              postUpdateVm: postUpdateVm,
            ));
  }

  @override
  Future<ResponseModel<List<Post>>> getSlides(
      {String? categoryId,
      required PagingOptionsVm slidePagingOptionsVm}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakePostDataSource.getSlides(
              categoryId: categoryId,
              userToken: credentials.credentials!.token,
              pagingOptionsVm: slidePagingOptionsVm,
            ));
  }
}
