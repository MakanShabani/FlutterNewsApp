import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/models/repositories/repo_fake_implementaion/fake_category_repository.dart';
import 'package:responsive_admin_dashboard/models/repositories/repo_fake_implementaion/fake_post_repository.dart';
import 'package:responsive_admin_dashboard/user_credentials.dart';

import 'bloc/blocs.dart';
import 'models/repositories/repo_fake_implementaion/fake_authetication_repository.dart';
import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (context) =>
                FakeAuthenticationRepository(delayDurationInSeconds: 2)),
        RepositoryProvider(
            create: (context) => FakePostReposiory(
                fetchDelayDurationInSeconds: 2, toggleBookmarkDelay: 10)),
        RepositoryProvider(
            create: (context) =>
                FakeCategoryRepository(delayDurationInSeconds: 1)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              lazy: false,
              create: (context) => AuthenticationBloc(
                  userCredentials: UserCredentials(),
                  authenticationRepository:
                      context.read<FakeAuthenticationRepository>())),
          BlocProvider(
              create: (context) => PostBookmarkCubit(
                  postRepository: context.read<FakePostReposiory>())),
        ],
        child: MaterialApp(
          title: 'News App',
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primarySwatch: Colors.orange,
            primaryColor: Colors.orange,
            appBarTheme: const AppBarTheme().copyWith(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData().copyWith(
                  color: Colors.orange,
                )),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData()
                .copyWith(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Colors.orange,
                    unselectedItemColor: Colors.black54),
            // Define the default font family.
            fontFamily: 'Georgia',

            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
          ),
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
