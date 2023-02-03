import '../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../data/repositories/bookmark_repository.dart';

class BookmarkService {
  BookmarkService({required BookmarkRepository bookmarkRepository})
      : _bookmarkRepository = bookmarkRepository;

  final BookmarkRepository _bookmarkRepository;

  Future<ResponseDTO<void>> togglePostBookmarkSatus(
      {required String userToken, required String postId}) async {
    return await _bookmarkRepository.toggleBookmark(
        userToken: userToken, postId: postId);
  }
}
