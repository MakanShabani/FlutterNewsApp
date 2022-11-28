import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../server_impementation/databse_entities/databse_entities.dart';
import '../../../../server_impementation/fake_database.dart';
import '../../domain/post_category_models.dart';

class FakePostCategoryDataSource {
  FakePostCategoryDataSource({required FakeDatabase fakeDatabase})
      : _fakeDatabase = fakeDatabase;

  final FakeDatabase _fakeDatabase;

  Future<ResponseDTO<List<PostCategory>>> getCategories(
      {required PagingOptionsDTO pagingOptionsDTO}) async {
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
