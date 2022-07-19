import '../../../user_credentials.dart';
import '../../entities/ViewModels/view_models.dart';
import '../../entities/entities.dart';
import '../../fake_data_source/fake_data_source.dart';
import '../repositories.dart';

class FakeCategoryRepository implements CategoryRepository {
  UserCredentials credentials = UserCredentials();
  FakeCategoryDataSource fakeCategoryDataSource = FakeCategoryDataSource();

  @override
  Future<ResponseModel<List<PostCategory>>> getCategories(
      {required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
      const Duration(seconds: 5),
      () => fakeCategoryDataSource.getCategories(
        userToken: credentials.authenticatedUser!.token,
        pagingOptionsVm: pagingOptionsVm,
      ),
    );
  }
}
