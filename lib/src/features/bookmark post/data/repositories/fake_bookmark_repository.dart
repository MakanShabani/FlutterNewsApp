import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../server_impementation/data_sources/bookmark_data_source.dart';
import 'bookmark_repository.dart';

class FakeBookmarkReposiory implements BookmarkRepository {
  FakeBookmarkReposiory(
      {required this.toggleBookmarkDelay,
      required BookmarkDataSource fakeBookmarkDataSource})
      : _fakeBookmarkDataSource = fakeBookmarkDataSource;

  final BookmarkDataSource _fakeBookmarkDataSource;
  final int toggleBookmarkDelay;

  @override
  Future<ResponseDTO<void>> toggleBookmark(
      {required String userToken, required String postId}) async {
    return await Future.delayed(
      Duration(seconds: toggleBookmarkDelay),
      () => _fakeBookmarkDataSource.toggleBookmarkPost(
        userToken: userToken,
        postId: postId,
      ),
    );
  }
}
