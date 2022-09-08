part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class InitializeEvent extends AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final UserLoginVm loginVm;

  LoginEvent({required this.loginVm});
}

class LogoutEvent extends AuthenticationEvent {
  final AuthenticatedUserModel user;

  LogoutEvent({required this.user});
}

class RegisterEvent extends AuthenticationEvent {
  final UserRegisterVm registerVm;

  RegisterEvent({required this.registerVm});
}
