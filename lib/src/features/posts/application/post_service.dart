import '../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../data/repositories/posts_repositories.dart';
import '../domain/posts_models.dart';

class PostsListService {
  PostsListService({required PostsRepository postRepository})
      : _postRepository = postRepository;

  final PostsRepository _postRepository;

  Future<ResponseDTO<List<Post>>> getPosts(
      {String? userToken,
      String? categoryId,
      required PagingOptionsDTO pagingOptionsDTO}) async {
    if (userToken == null) {
      return await _postRepository.getPostsAsguest(
        pagingOptionsDTO: pagingOptionsDTO,
        categoryId: categoryId,
      );
    } else {
      return await _postRepository.getPosts(
        userToken: userToken,
        pagingOptionsDTO: pagingOptionsDTO,
        categoryId: categoryId,
      );
    }
  }

  Future<ResponseDTO<List<Post>>> getUserBookmarkedPosts(
      {required String userToken,
      required PagingOptionsDTO pagingOptionsDTO}) async {
    return await _postRepository.getBookmarkedPosts(
        userToken: userToken, pagingOptionsDTO: pagingOptionsDTO);
  }

  Future<ResponseDTO<Post>> getPostDetails(
      {String? userToken, required String postId}) async {
    if (userToken == null) {
      //get post As a guest
      return await _postRepository.getPostAsGuest(postId: postId);
    }

    //get post as a signed in user
    return await _postRepository.getPost(userToken: userToken, postId: postId);
  }
}
