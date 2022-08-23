import '../../../logged_in_user_info.dart';
import '../../entities/ViewModels/view_models.dart';
import '../../entities/entities.dart';
import '../../fake_data_source/fake_data_source.dart';
import '../repositories.dart';

class FakeCategoryRepository implements CategoryRepository {
  FakeCategoryRepository({required this.delayDurationInSeconds});

  LoggedInUserInfo credentials = LoggedInUserInfo();
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
