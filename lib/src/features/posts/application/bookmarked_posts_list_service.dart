import '../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../data/repositories/posts_repositories.dart';
import '../domain/posts_models.dart';

class BookmarkedPostsListServcie {
  BookmarkedPostsListServcie({required PostsRepository postRepository})
      : _postsRepository = postRepository;

  final PostsRepository _postsRepository;

  Future<ResponseDTO<List<Post>>> getUserBookmarekdPosts(
      {required String userToken,
      required PagingOptionsDTO pagingOptionsDTO,
      String? categoryId}) async {
    return await _postsRepository.getBookmarkedPosts(
        userToken: userToken, pagingOptionsDTO: pagingOptionsDTO);
  }
}
