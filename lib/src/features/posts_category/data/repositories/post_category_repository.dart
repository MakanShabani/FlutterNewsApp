import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../domain/post_category_models.dart';

abstract class PostCategoryRepository {
  Future<ResponseDTO<List<PostCategory>>> getCategories(
      {required PagingOptionsDTO pagingOptionsDTO});
}
