import '../models/ViewModels/view_models.dart';
import '../models/entities/entities.dart';

abstract class PostRepository {
  Future<ResponseModel<List<Post>>> getSlides(
      {String? categoryId, required PagingOptionsVm slidePagingOptionsVm});

  Future<ResponseModel<List<Post>>> getPosts(
      {required PagingOptionsVm pagingOptionsVm, String? categoryId});

  Future<ResponseModel<List<Post>>> getAuthorPosts(
      {required String userId, required PagingOptionsVm pagingOptionsVm});

  Future<ResponseModel<Post>> getPost({required postId});

  Future<ResponseModel<Post>> createPost(
      {required PostCreationVm postCreationVm});

  Future<ResponseModel<Post>> updatePost(
      {required String postId, required PostUpdateVm postUpdateVm});

  Future<ResponseModel<void>> deletePost({required postId});

  Future<ResponseModel<void>> toggleBookmark({required String postId});

  Future<ResponseModel<List<Post>>> getBookmarkedPosts(
      {required PagingOptionsVm pagingOptionsVm});
}
