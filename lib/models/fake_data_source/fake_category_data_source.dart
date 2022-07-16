import '../entities/ViewModels/view_models.dart';
import '../entities/entities.dart';
import 'fake_database.dart';

class FakeCategoryDataSource {
  FakeDatabase fakeDatabase = FakeDatabase();

  ResponseModel<List<PostCategory>> getCategories(
      {required String userToken, required PagingOptionsVm pagingOptionsVm}) {
    //user token is not valid -- Unauthorized
    if (!fakeDatabase.isUserTokenValid(token: userToken)) {
      return ResponseModel(
          statusCode: 401, error: fakeDatabase.unAuthorizedError);
    }

    //everything is ok

    return ResponseModel(
        statusCode: 200,
        data: fakeDatabase.categories
            .skip(pagingOptionsVm.offset!)
            .take(pagingOptionsVm.limit!)
            .toList());
  }
}
