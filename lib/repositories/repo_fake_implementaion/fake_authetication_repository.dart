import 'package:responsive_admin_dashboard/data_source/logged_in_user_info.dart';

import '../../data_source/fake_data_source/fake_data_source.dart';
import '../authentication_repository.dart';
import '../../models/entities/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';

class FakeAuthenticationRepository implements AuthenticationRepository {
  FakeAuthenticationRepository({required this.delayDurationInSeconds});

  LoggedInUserInfo user = LoggedInUserInfo();
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
  Future<ResponseModel<void>> logout() {
    return Future.delayed(
        Duration(seconds: delayDurationInSeconds),
        () => fakeAuthDataSource.logoutUser(
            userToken: user.authenticatedUser!.token));
  }
}
