import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/blocs.dart';
import 'models/repositories/repo_fake_implementaion/fake_authetication_repository.dart';
import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FakeAuthenticationRepository(),
      child: BlocProvider(
        lazy: false,
        create: (context) => AuthenticationBloc(
            authenticationRepository:
                context.read<FakeAuthenticationRepository>()),
        child: MaterialApp(
          title: 'Admin Dashboard',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
