import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import 'fake_database.dart';

class FakeCategoryDataSource {
  FakeDatabase fakeDatabase = FakeDatabase();

  ResponseModel<List<PostCategory>> getCategories(
      {required PagingOptionsVm pagingOptionsVm}) {
    return ResponseModel(
        statusCode: 200,
        data: fakeDatabase.categories
            .skip(pagingOptionsVm.offset)
            .take(pagingOptionsVm.limit)
            .toList());
  }
}
