part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class InitializeEvent extends AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final UserLoginVm loginVm;

  const LoginEvent({required this.loginVm});
}

class LogoutEvent extends AuthenticationEvent {}

class RegisterEvent extends AuthenticationEvent {
  final UserRegisterVm registerVm;

  const RegisterEvent({required this.registerVm});
}
