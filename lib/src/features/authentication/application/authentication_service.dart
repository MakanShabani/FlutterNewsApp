import '../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../infrastructure/utils/dual_data.dart';
import '../data/dtos/authenticate_dtos.dart';
import '../data/repositories/authentciation_repositories.dart';
import '../domain/authentication_models.dart';
import 'authentication_services.dart';

class AuthenticationService {
  AuthenticationService(
      {required AuthenticationRepository authenticationRepository,
      required AuthenticatedUserService authenticateduserService})
      : _authenticationRepository = authenticationRepository,
        _authenticatedUserService = authenticateduserService;

  final AuthenticationRepository _authenticationRepository;
  final AuthenticatedUserService _authenticatedUserService;

  Future<ResponseDTO<User>> login({required UserLoginDTO loginVm}) async {
    ResponseDTO<User> response =
        await _authenticationRepository.login(loginVm: loginVm);

    //everything is ok

    //Save user credentials to database, singleton or sharedprefrences
    //if user logging in was successful
    if (response.statusCode == 200) {
      await _authenticatedUserService.saveUserInfo(response.data!);
    }
    return response;
  }

  Future<ResponseDTO<void>> logout({required String userToken}) async {
    ResponseDTO<void> response =
        await _authenticationRepository.logout(userToken: userToken);

    //Remove user credentials to database, singleton or sharedprefrences
    await _authenticatedUserService.removeUserInfo();

    return response;
  }

  Future<ResponseDTO<User>> register(
      {required UserRegisterDTO registerVm}) async {
    ResponseDTO<User> response =
        await _authenticationRepository.registerUser(registerVm: registerVm);

    //Save user credentials to database, singleton or sharedprefrences
    //if user registration was successful
    if (response.statusCode == 200) {
      await _authenticatedUserService.saveUserInfo(response.data!);
    }

    return response;
  }

  Future<DualData<bool, User>> checkUserIsAlreadySigendIn() async {
    return await _authenticatedUserService.loadAndCheckUserCredentials();
  }
}
