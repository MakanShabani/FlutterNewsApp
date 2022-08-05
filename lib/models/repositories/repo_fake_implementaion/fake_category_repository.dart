import '../../../user_credentials.dart';
import '../../entities/ViewModels/view_models.dart';
import '../../entities/entities.dart';
import '../../fake_data_source/fake_data_source.dart';
import '../repositories.dart';

class FakeCategoryRepository implements CategoryRepository {
  FakeCategoryRepository({required this.delayDurationInSeconds});

  UserCredentials credentials = UserCredentials();
  FakeCategoryDataSource fakeCategoryDataSource = FakeCategoryDataSource();
  final int delayDurationInSeconds;

  @override
  Future<ResponseModel<List<PostCategory>>> getCategories(
      {required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
      Duration(seconds: delayDurationInSeconds),
      () => fakeCategoryDataSource.getCategories(
        userToken: credentials.authenticatedUser!.token,
        pagingOptionsVm: pagingOptionsVm,
      ),
    );
  }
}
