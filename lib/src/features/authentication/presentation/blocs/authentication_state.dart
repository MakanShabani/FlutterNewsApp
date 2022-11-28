part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoadingUserSavedCredentials extends AuthenticationState {}

class AuthenticationLoggedout extends AuthenticationState {}

class AuthenticationLoggingOut extends AuthenticationState {
  final User user;
  AuthenticationLoggingOut({required this.user});
}

class AuthenticationLoggingIn extends AuthenticationState {}

class AuthenticationRegistering extends AuthenticationState {}

class AuthenticationLoggedIn extends AuthenticationState {
  final User user;

  AuthenticationLoggedIn({required this.user});
}

class AuthenticationLoggingInError extends AuthenticationState {
  final ErrorModel error;

  AuthenticationLoggingInError({required this.error});
}

class AuthenticationRegistered extends AuthenticationState {
  final User user;

  AuthenticationRegistered({required this.user});
}

class AuthenticationRegisteringError extends AuthenticationState {
  final ErrorModel error;

  AuthenticationRegisteringError({required this.error});
}
