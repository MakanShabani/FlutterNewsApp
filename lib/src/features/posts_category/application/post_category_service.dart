import '../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../data/repositories/post_category_repositories.dart';
import '../domain/post_category_models.dart';

class PostCategoryService {
  PostCategoryService({required PostCategoryRepository postCategoryRepository})
      : _postCategoryRepository = postCategoryRepository;

  final PostCategoryRepository _postCategoryRepository;

  Future<ResponseDTO<List<PostCategory>>> getCategories(
      {required PagingOptionsDTO pagingOptionsDTO}) async {
    return await _postCategoryRepository.getCategories(
        pagingOptionsDTO: pagingOptionsDTO);
  }
}
