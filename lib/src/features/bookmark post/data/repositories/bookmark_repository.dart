import '../../../../infrastructure/shared_dtos/shared_dtos.dart';

abstract class BookmarkRepository {
  Future<ResponseDTO<void>> toggleBookmark(
      {required String userToken, required String postId});
}
