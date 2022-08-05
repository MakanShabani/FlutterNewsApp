import '../../../user_credentials.dart';
import '../../entities/ViewModels/view_models.dart';
import '../../entities/entities.dart';
import '../../fake_data_source/fake_data_source.dart';
import '../user_repository.dart';

class FakeUserRepository implements UserRepository {
  FakeUserRepository({required this.delayDurationInSeconds});

  UserCredentials credentials = UserCredentials();
  FakeUserDataSource fakeUserDataSource = FakeUserDataSource();
  final int delayDurationInSeconds;

  @override
  Future<ResponseModel<User>> getAuthor({required String authorId}) async {
    return await Future.delayed(
        Duration(seconds: delayDurationInSeconds),
        () => fakeUserDataSource.getUser(
            userToken: credentials.authenticatedUser!.token, userId: authorId));
  }

  @override
  Future<ResponseModel<List<User>>> getAuthors(
      {required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(
        Duration(seconds: delayDurationInSeconds),
        () => fakeUserDataSource.getusers(
            userToken: credentials.authenticatedUser!.token,
            pagingOptionsVm: pagingOptionsVm));
  }

  @override
  Future<ResponseModel<User>> updateMyProfile(
      {required UserUpdateVm updateVm}) async {
    return await Future.delayed(
        Duration(seconds: delayDurationInSeconds),
        () => fakeUserDataSource.updateUser(
            userToken: credentials.authenticatedUser!.token,
            updateVm: updateVm));
  }
}
