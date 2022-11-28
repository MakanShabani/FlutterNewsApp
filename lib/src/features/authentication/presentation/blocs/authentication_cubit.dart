// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../infrastructure/shared_models/shared_model.dart';
import '../../../../infrastructure/utils/dual_data.dart';
import '../../application/authentication_services.dart';
import '../../data/dtos/authenticate_dtos.dart';
import '../../domain/authentication_models.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required AuthenticationService authenticationService,
  })  : _authenticationService = authenticationService,
        super(AuthenticationInitial());

  final AuthenticationService _authenticationService;

  void loadUserSavedCredentials() async {
    emit(AuthenticationLoadingUserSavedCredentials());

    DualData<bool, User> result =
        await _authenticationService.checkUserIsAlreadySigendIn();

    if (result.data1 == null || !result.data1!) {
      //user has not signed In or user's token has been expired

      emit(AuthenticationLoggedout());
      return;
    }

    emit(AuthenticationLoggedIn(user: result.data2!));
  }

  void login({required UserLoginDTO loginVm}) async {
    emit(AuthenticationLoggingIn());

    ResponseDTO<User> response =
        await _authenticationService.login(loginVm: loginVm);

    if (response.statusCode != 200) {
      emit(AuthenticationLoggingInError(error: response.error!));
      return;
    }
    //everything is ok
    emit(AuthenticationLoggedIn(user: response.data!));
    return;
  }

  void register({required UserRegisterDTO registerVm}) async {
    emit(AuthenticationRegistering());
    ResponseDTO<User> response =
        await _authenticationService.register(registerVm: registerVm);

    if (response.statusCode != 200) {
      emit(AuthenticationRegisteringError(error: response.error!));
      return;
    }
    //everything is ok

    emit(AuthenticationRegistered(user: response.data!));
    return;
  }

  void logout({required User user}) async {
    emit(AuthenticationLoggingOut(user: user));

    await _authenticationService.logout(userToken: user.token);

    //everything is ok

    emit(AuthenticationLoggedout());
    return;
  }
}
