import '../../../user_credentials.dart';
import '../../entities/ViewModels/view_models.dart';
import '../../entities/entities.dart';
import '../../fake_data_source/fake_data_source.dart';
import '../user_repository.dart';

class FakeUserRepository implements UserRepository {
  UserCredentials credentials = UserCredentials();

  FakeUserDataSource fakeUserDataSource = FakeUserDataSource();

  @override
  Future<ResponseModel<User>> getAuthor({required String authorId}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakeUserDataSource.getUser(
            userToken: credentials.credentials!.token, userId: authorId));
  }

  @override
  Future<ResponseModel<List<User>>> getAuthors(
      {required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakeUserDataSource.getusers(
            userToken: credentials.credentials!.token,
            pagingOptionsVm: pagingOptionsVm));
  }

  @override
  Future<ResponseModel<User>> updateMyProfile(
      {required UserUpdateVm updateVm}) async {
    return await Future.delayed(
        const Duration(seconds: 5),
        () => fakeUserDataSource.updateUser(
            userToken: credentials.credentials!.token, updateVm: updateVm));
  }
}
