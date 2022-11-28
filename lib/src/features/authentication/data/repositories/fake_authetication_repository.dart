import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../domain/authentication_models.dart';
import '../data_sources/authentciation_data_sources.dart';
import '../dtos/authenticate_dtos.dart';
import 'authentication_repository.dart';

class FakeAuthenticationRepository implements AuthenticationRepository {
  FakeAuthenticationRepository({required this.delayDurationInSeconds});

  FakeAuthenticationDataSource fakeAuthDataSource =
      FakeAuthenticationDataSource();

  final int delayDurationInSeconds;

  @override
  Future<ResponseDTO<User>> login({required UserLoginDTO loginVm}) async {
    return await Future.delayed(Duration(seconds: delayDurationInSeconds),
        () => fakeAuthDataSource.loginUser(loginVm: loginVm));
  }

  @override
  Future<ResponseDTO<User>> registerUser(
      {required UserRegisterDTO registerVm}) async {
    return Future.delayed(Duration(seconds: delayDurationInSeconds),
        () => fakeAuthDataSource.registerUser(userRegisterVm: registerVm));
  }

  @override
  Future<ResponseDTO<void>> logout({required String userToken}) {
    return Future.delayed(Duration(seconds: delayDurationInSeconds),
        () => fakeAuthDataSource.logoutUser(userToken: userToken));
  }
}
