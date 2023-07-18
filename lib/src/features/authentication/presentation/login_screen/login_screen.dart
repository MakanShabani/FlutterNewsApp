import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common_widgets/common_widgest.dart';
import '../../data/dtos/authenticate_dtos.dart';
import '../blocs/authentication_cubit.dart';
import 'widgets/login_screen_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String emailInputText = '';
  String passwordInputText = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: (previous, current) =>
          current is AuthenticationLoggingInError ||
          current is AuthenticationLoggedIn,
      listener: (context, state) {
        if (state is AuthenticationLoggingInError) {
          ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar(
              message: state.error.message,
              isFloating: false,
              isTop: false,
              context: context,
              action: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              actionLabel: 'OK',
            ),
          );
          return;
        }
        if (state is AuthenticationLoggedIn) {
          Navigator.pop(context);
          return;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 25.0, 40.0, 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/login.png',
                    width: double.infinity,
                    height: 220.0,
                  ),
                  InputSections(
                    emailTextChanged: (val) => emailInputText = val,
                    passwordTextChanged: (val) => passwordInputText = val,
                  ),
                  ButtonSections(
                    signInOnPressed: () =>
                        context.read<AuthenticationCubit>().login(
                                loginVm: UserLoginDTO(
                              email: emailInputText,
                              password: passwordInputText,
                            )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
