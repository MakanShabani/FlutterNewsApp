// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../infrastructure/shared_preferences_service.dart';
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
  final SharedPreferencesService sharedPreferencesService;

  AuthenticationBloc({
    required this.authenticationRepository,
    required this.loggedInUser,
    required this.sharedPreferencesService,
  }) : super(AuthenticationInitial()) {
    on<InitializeEvent>((event, emit) async {
      emit(AuthenticationInitializingState());

      AuthenticatedUserModel? user =
          await sharedPreferencesService.getUserInfo();

      if (user == null || user.expireAt.isBefore(DateTime.now())) {
        emit(Loggedout());
        return;
      }

      //TODO : we could contact server and
      //update user's proile , user's bookmarks etc here

      emit(LoggedIn(user: user));
    });

    on<LogoutEvent>((event, emit) async {
      await authenticationRepository.logout();

      //everything is ok

      //Remove user credentials to database, singleton or sharedprefrences
      loggedInUser.authenticatedUser = null;
      sharedPreferencesService.removeUserInfo();

      emit(Loggedout());
      return;
    });

    on<LoginEvent>((event, emit) async {
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
      sharedPreferencesService.saveUserInfo(loggedInUser.authenticatedUser!);

      emit(LoggedIn(user: response.data!));
      return;
    });

    on<RegisterEvent>((event, emit) async {
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
      sharedPreferencesService.saveUserInfo(loggedInUser.authenticatedUser!);

      emit(Registered(user: response.data!));
      return;
    });
  }
}
