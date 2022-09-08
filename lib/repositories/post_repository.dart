import '../models/ViewModels/view_models.dart';
import '../models/entities/entities.dart';

abstract class PostRepository {
  Future<ResponseModel<List<Post>>> getSlides(
      {String? categoryId, required PagingOptionsVm slidePagingOptionsVm});

  Future<ResponseModel<List<Post>>> getPosts(
      {required String userToken,
      required PagingOptionsVm pagingOptionsVm,
      String? categoryId});

  Future<ResponseModel<List<Post>>> getPostsAsguest(
      {required PagingOptionsVm pagingOptionsVm, String? categoryId});

  Future<ResponseModel<List<Post>>> getAuthorPosts(
      {required String userToken,
      required String authorId,
      required PagingOptionsVm pagingOptionsVm});

  Future<ResponseModel<List<Post>>> getAuthorPostsAsGuest(
      {required String authorId, required PagingOptionsVm pagingOptionsVm});

  Future<ResponseModel<Post>> getPost(
      {required String userToken, required postId});

  Future<ResponseModel<Post>> getPostAsGuest({required postId});

  Future<ResponseModel<Post>> createPost(
      {required String userToken, required PostCreationVm postCreationVm});

  Future<ResponseModel<Post>> updatePost(
      {required String userToken,
      required String postId,
      required PostUpdateVm postUpdateVm});

  Future<ResponseModel<void>> deletePost(
      {required String userToken, required postId});

  Future<ResponseModel<void>> toggleBookmark(
      {required String userToken, required String postId});

  Future<ResponseModel<List<Post>>> getBookmarkedPosts(
      {required String userToken, required PagingOptionsVm pagingOptionsVm});
}
