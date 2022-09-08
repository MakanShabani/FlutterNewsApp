import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../data_source/fake_data_source/fake_data_source.dart';
import '../repositories.dart';

class FakeCategoryRepository implements CategoryRepository {
  FakeCategoryRepository({required this.delayDurationInSeconds});

  FakeCategoryDataSource fakeCategoryDataSource = FakeCategoryDataSource();
  final int delayDurationInSeconds;

  @override
  Future<ResponseModel<List<PostCategory>>> getCategories(
      {required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
      Duration(seconds: delayDurationInSeconds),
      () => fakeCategoryDataSource.getCategories(
        pagingOptionsVm: pagingOptionsVm,
      ),
    );
  }
}
