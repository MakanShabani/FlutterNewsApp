import '../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../data/repositories/posts_repositories.dart';

class PostService {
  PostService({required PostsRepository postRepository})
      : _postsRepository = postRepository;

  final PostsRepository _postsRepository;

  Future<ResponseDTO<void>> togglePostBookmarkSatus(
      {required String userToken, required String postId}) async {
    return await _postsRepository.toggleBookmark(
        userToken: userToken, postId: postId);
  }
}
