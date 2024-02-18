import 'package:shaspeaker_news_app/src/server_impementation/services/signed_in_user_service.dart';

import '../../infrastructure/shared_dtos/shared_dtos.dart';
import '../databse_entities/databse_entities.dart';
import '../fake_database.dart';
import '../../features/posts_category/domain/post_category_models.dart';

class PostCategoryDataSource {
  final FakeDatabase _fakeDatabase = FakeDatabase();
  final SignedInUserService _signedInUserService = SignedInUserService();
  Future<ResponseDTO<List<PostCategory>>> getCategories(
      {required PagingOptionsDTO pagingOptionsDTO}) async {
    //load previous loggedIn user if his/her token is still valid
    //we update signedInUser here because its the first place FakeDatabse is initialized
    _fakeDatabase.sigendInUser =
        await _signedInUserService.loadAndCheckUserCredentials();

    List<PostCategory> finalObjects = List.empty(growable: true);
    for (DatabasePostCategory item in _fakeDatabase.categories
        .skip(pagingOptionsDTO.offset)
        .take(pagingOptionsDTO.limit)
        .toList()) {
      finalObjects.add(PostCategory.fromFakeDatabsePostCategory(item));
    }

    return ResponseDTO(statusCode: 200, data: finalObjects);
  }
}
