import '../../data_source/fake_data_source/fake_data_source.dart';
import '../../models/ViewModels/view_models.dart';
import '../authentication_repository.dart';
import '../../models/entities/entities.dart';

class FakeAuthenticationRepository implements AuthenticationRepository {
  FakeAuthenticationRepository({required this.delayDurationInSeconds});

  FakeAuthenticationDataSource fakeAuthDataSource =
      FakeAuthenticationDataSource();

  final int delayDurationInSeconds;

  @override
  Future<ResponseModel<AuthenticatedUserModel>> login(
      {required UserLoginVm loginVm}) async {
    return await Future.delayed(Duration(seconds: delayDurationInSeconds),
        () => fakeAuthDataSource.loginUser(loginVm: loginVm));
  }

  @override
  Future<ResponseModel<AuthenticatedUserModel>> registerUser(
      {required UserRegisterVm registerVm}) async {
    return Future.delayed(Duration(seconds: delayDurationInSeconds),
        () => fakeAuthDataSource.registerUser(userRegisterVm: registerVm));
  }

  @override
  Future<ResponseModel<void>> logout({required String userToken}) {
    return Future.delayed(Duration(seconds: delayDurationInSeconds),
        () => fakeAuthDataSource.logoutUser(userToken: userToken));
  }
}
