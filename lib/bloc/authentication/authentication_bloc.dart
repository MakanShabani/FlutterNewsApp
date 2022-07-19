// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:responsive_admin_dashboard/user_credentials.dart';

import '../../models/entities/entities.dart';
import '../../models/entities/ViewModels/view_models.dart';
import '../../models/repositories/repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserCredentials userCredentials;
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({
    required this.authenticationRepository,
    required this.userCredentials,
  }) : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is LogoutEvent) {
        await authenticationRepository.logout();

        //everything is ok

        //Save user credentials to database, singleton or sharedprefrences
        userCredentials.authenticatedUser = null;

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
        userCredentials.authenticatedUser = response.data!;

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
        userCredentials.authenticatedUser = response.data!;

        emit(Registered(user: response.data!));
        return;
      }
    });
  }
}
