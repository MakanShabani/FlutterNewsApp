// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:responsive_admin_dashboard/infrastructure/shared_preferences_service.dart';

import '../../models/entities/entities.dart';
import '../../models/entities/ViewModels/view_models.dart';
import '../../data_source/logged_in_user_info.dart';
import '../../repositories/repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoggedInUserInfo loggedInUser;
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({
    required this.authenticationRepository,
    required this.loggedInUser,
  }) : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is LogoutEvent) {
        await authenticationRepository.logout();

        //everything is ok

        //Remove user credentials to database, singleton or sharedprefrences
        loggedInUser.authenticatedUser = null;
        SharedPreferencesService.removeUserInfo();

        emit(Loggedout());
        return;
      }

      if (event is LoginEvent) {
        emit(LoggingIn());
        ResponseModel<AuthenticatedUserModel> response =
            await authenticationRepository.login(loginVm: event.loginVm);

        if (response.data == null) {
          emit(LoggingInError(error: response.error!));
          return;
        }

        //everything is ok

        //Save user credentials to database, singleton or sharedprefrences
        loggedInUser.authenticatedUser = response.data!;
        SharedPreferencesService.saveUserInfo(loggedInUser.authenticatedUser!);

        emit(LoggedIn(user: response.data!));
        return;
      }

      if (event is RegisterEvent) {
        ResponseModel<AuthenticatedUserModel> response =
            await authenticationRepository.registerUser(
                registerVm: event.registerVm);

        if (response.data == null) {
          emit(RegisteringError(error: response.error!));
          return;
        }
        //everything is ok

        //Save user credentials to database, singleton or sharedprefrences
        loggedInUser.authenticatedUser = response.data!;
        SharedPreferencesService.saveUserInfo(loggedInUser.authenticatedUser!);

        emit(Registered(user: response.data!));
        return;
      }
    });
  }
}
