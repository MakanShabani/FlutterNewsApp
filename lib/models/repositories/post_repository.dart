import '../entities/ViewModels/view_models.dart';
import '../entities/entities.dart';

abstract class PostRepository {
  Future<ResponseModel<List<Post>>> getPosts(
      {required PagingOptionsVm pagingOptionsVm});

  Future<ResponseModel<List<Post>>> getAuthorPosts(
      {required String userId, required PagingOptionsVm pagingOptionsVm});

  Future<ResponseModel<Post>> getPost({required postId});

  Future<ResponseModel<Post>> createPost(
      {required PostCreationVm postCreationVm});

  Future<ResponseModel<Post>> updatePost(
      {required String postId, required PostUpdateVm postUpdateVm});

  Future<ResponseModel<void>> deletePost({required postId});
}
