import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../domain/posts_models.dart';

abstract class PostsRepository {
  Future<ResponseDTO<List<Post>>> getPosts(
      {required String userToken,
      required PagingOptionsDTO pagingOptionsDTO,
      String? categoryId});

  Future<ResponseDTO<List<Post>>> getPostsAsguest(
      {required PagingOptionsDTO pagingOptionsDTO, String? categoryId});

  Future<ResponseDTO<List<Post>>> getAuthorPosts(
      {required String userToken,
      required String authorId,
      required PagingOptionsDTO pagingOptionsDTO});

  Future<ResponseDTO<List<Post>>> getAuthorPostsAsGuest(
      {required String authorId, required PagingOptionsDTO pagingOptionsDTO});

  Future<ResponseDTO<Post>> getPost(
      {required String userToken, required postId});

  Future<ResponseDTO<Post>> getPostAsGuest({required postId});

  Future<ResponseDTO<List<Post>>> getBookmarkedPosts(
      {required String userToken, required PagingOptionsDTO pagingOptionsDTO});
}
