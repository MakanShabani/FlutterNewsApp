import '../models/ViewModels/view_models.dart';
import '../models/entities/entities.dart';

abstract class CategoryRepository {
  Future<ResponseModel<List<PostCategory>>> getCategories(
      {required PagingOptionsVm pagingOptionsVm});
}
