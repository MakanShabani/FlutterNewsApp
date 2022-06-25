part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {}

class Loggedout extends AuthenticationState {}

class LoggingIn extends AuthenticationState {}

class Registering extends AuthenticationState {}

class LoggedIn extends AuthenticationState {
  final AuthenticatedUserModel user;

  const LoggedIn({required this.user});
}

class LoggingInError extends AuthenticationState {
  final ErrorModel error;

  const LoggingInError({required this.error});
}

class Registered extends AuthenticationState {
  final AuthenticatedUserModel user;

  const Registered({required this.user});
}

class RegisteringError extends AuthenticationState {
  final ErrorModel error;

  const RegisteringError({required this.error});
}
