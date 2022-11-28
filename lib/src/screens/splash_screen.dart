import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/settings/presentation/blocs/settings_blocs.dart';
import '../common_widgets/common_widgest.dart';
import '../features/authentication/presentation/blocs/authentication_cubit.dart';
import '../router/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    //initialize app theme mode according to the user's saved settings.
    context.read<ThemeCubit>().initialize();

    Future.delayed(const Duration(seconds: 3),
        () => context.read<AuthenticationCubit>().loadUserSavedCredentials());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) =>
              current is AuthenticationLoggedIn ||
              current is AuthenticationLoggedout,
          listener: (context, state) {
            Navigator.pushReplacementNamed(context, homeRoute);
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/splash_logo_orange.png',
                height: 100.0,
              ),
              Text(
                'All the news you need and more',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.0),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                child: LoadingIndicator(
                  hasBackground: false,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
