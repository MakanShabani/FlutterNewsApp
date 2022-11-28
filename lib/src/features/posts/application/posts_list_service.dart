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
}
