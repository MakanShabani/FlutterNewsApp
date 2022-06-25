import '../entities/ViewModels/view_models.dart';
import '../entities/entities.dart';

abstract class UserRepository {
  Future<ResponseModel<List<User>>> getAuthors(
      {required PagingOptionsVm pagingOptionsVm});

  Future<ResponseModel<User>> getAuthor({required String authorId});

  Future<ResponseModel<User>> updateMyProfile({required UserUpdateVm updateVm});
}
