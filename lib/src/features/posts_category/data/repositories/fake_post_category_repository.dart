import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../server_impementation/data_sources/fake_post_category_data_source.dart';
import '../../domain/post_category_models.dart';
import 'post_category_repository.dart';

class FakePostCategoryRepository implements PostCategoryRepository {
  FakePostCategoryRepository(
      {required this.delayDurationInSeconds,
      required FakePostCategoryDataSource fakePostCategoryDataSource})
      : _fakeCategoryDataSource = fakePostCategoryDataSource;

  final FakePostCategoryDataSource _fakeCategoryDataSource;
  final int delayDurationInSeconds;

  @override
  Future<ResponseDTO<List<PostCategory>>> getCategories(
      {required PagingOptionsDTO pagingOptionsDTO}) async {
    return await Future.delayed(
      Duration(seconds: delayDurationInSeconds),
      () => _fakeCategoryDataSource.getCategories(
        pagingOptionsDTO: pagingOptionsDTO,
      ),
    );
  }
}
