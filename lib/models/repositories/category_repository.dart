import '../entities/ViewModels/view_models.dart';
import '../entities/entities.dart';

abstract class CategoryRepository {
  Future<ResponseModel<List<PostCategory>>> getCategories(
      {required PagingOptionsVm pagingOptionsVm});
}
