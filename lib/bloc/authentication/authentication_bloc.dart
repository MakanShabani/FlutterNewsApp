// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../infrastructure/shared_preferences_service.dart';
import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../repositories/repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final SharedPreferencesService sharedPreferencesService;

  AuthenticationBloc({
    required this.authenticationRepository,
    required this.sharedPreferencesService,
  }) : super(AuthenticationInitial()) {
    on<InitializeEvent>((event, emit) async {
      emit(AuthenticationInitializingState());

      AuthenticatedUserModel? user =
          await sharedPreferencesService.getUserInfo();

      if (user == null || user.expireAt.isBefore(DateTime.now())) {
        await sharedPreferencesService.removeUserInfo();
        emit(Loggedout());
        return;
      }

      //TODO : we could contact server and
      //update user's proile , user's bookmarks etc here

      emit(LoggedIn(user: user));
    });

    on<LogoutEvent>((event, emit) async {
      emit(LoggingOut(user: event.user));
      await authenticationRepository.logout(userToken: event.user.token);

      //everything is ok

      //Remove user credentials to database, singleton or sharedprefrences
      await sharedPreferencesService.removeUserInfo();

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
      await sharedPreferencesService.saveUserInfo(response.data!);

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
      await sharedPreferencesService.saveUserInfo(response.data!);

      emit(Registered(user: response.data!));
      return;
    });
  }
}
