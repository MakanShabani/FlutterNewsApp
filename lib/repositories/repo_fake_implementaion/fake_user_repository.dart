import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../data_source/fake_data_source/fake_data_source.dart';
import '../user_repository.dart';

class FakeUserRepository implements UserRepository {
  FakeUserRepository({required this.delayDurationInSeconds});

  FakeUserDataSource fakeUserDataSource = FakeUserDataSource();
  final int delayDurationInSeconds;

  @override
  Future<ResponseModel<User>> getAuthor({required String authorId}) async {
    return await Future.delayed(Duration(seconds: delayDurationInSeconds),
        () => fakeUserDataSource.getUser(userId: authorId));
  }

  @override
  Future<ResponseModel<List<User>>> getAuthors(
      {required PagingOptionsVm pagingOptionsVm}) async {
    return await Future.delayed(Duration(seconds: delayDurationInSeconds),
        () => fakeUserDataSource.getusers(pagingOptionsVm: pagingOptionsVm));
  }

  @override
  Future<ResponseModel<User>> updateMyProfile(
      {required String userToken, required UserUpdateVm updateVm}) async {
    return await Future.delayed(
        Duration(seconds: delayDurationInSeconds),
        () => fakeUserDataSource.updateUser(
            userToken: userToken, updateVm: updateVm));
  }
}
