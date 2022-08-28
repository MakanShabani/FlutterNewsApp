import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/view/widgets/app_snack_bar.dart';
import '../../../bloc/blocs.dart';
import '../../../models/ViewModels/view_models.dart';
import '../../../router/route_names.dart';
import './widgets/widgets.dart';

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
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) =>
          current is LoggingInError || current is LoggedIn,
      listener: (context, state) {
        if (state is LoggingInError) {
          ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
              message: state.error.message,
              isFloating: false,
              isTop: false,
              deviceHeight: MediaQuery.of(context).size.height));
        }
        if (state is LoggedIn) {
          Navigator.pushReplacementNamed(context, homeRoute);
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
                        context.read<AuthenticationBloc>().add(LoginEvent(
                                loginVm: UserLoginVm(
                              email: emailInputText,
                              password: passwordInputText,
                            ))),
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
