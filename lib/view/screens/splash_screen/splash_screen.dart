import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/view/widgets/loading_indicator.dart';

import '../../../bloc/blocs.dart';
import '../../../router/route_names.dart';

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
        () => context.read<AuthenticationBloc>().add(InitializeEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) =>
              current is LoggedIn || current is Loggedout,
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
