import 'package:responsive_admin_dashboard/user_credentials.dart';

import '../../fake_data_source/fake_data_source.dart';
import '../authentication_repository.dart';
import '../../entities/ViewModels/view_models.dart';
import '../../entities/entities.dart';

class FakeAuthenticationRepository implements AuthenticationRepository {
  UserCredentials userCredentials = UserCredentials();
  FakeAuthenticationDataSource fakeAuthDataSource =
      FakeAuthenticationDataSource();

  @override
  Future<ResponseModel<AuthenticatedUserModel>> login(
      {required UserLoginVm loginVm}) async {
    return await Future.delayed(const Duration(seconds: 5),
        () => fakeAuthDataSource.loginUser(loginVm: loginVm));
  }

  @override
  Future<ResponseModel<AuthenticatedUserModel>> registerUser(
      {required UserRegisterVm registerVm}) async {
    return Future.delayed(const Duration(seconds: 5),
        () => fakeAuthDataSource.registerUser(userRegisterVm: registerVm));
  }

  @override
  Future<ResponseModel<void>> logout() {
    return Future.delayed(
        const Duration(seconds: 5),
        () => fakeAuthDataSource.logoutUser(
            userToken: userCredentials.credentials!.token));
  }
}
