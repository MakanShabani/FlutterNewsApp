import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:responsive_admin_dashboard/view/style.dart';

import 'bloc/blocs.dart';
import 'data_source/logged_in_user_info.dart';
import 'infrastructure/shared_preferences_service.dart';
import 'repositories/repo_fake_implementaion/fake_repositories.dart';
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
              create: (context) => ThemeCubit(
                  sharedPreferencesService: SharedPreferencesService())),
          BlocProvider(
              lazy: false,
              create: (context) => AuthenticationBloc(
                  sharedPreferencesService: SharedPreferencesService(),
                  loggedInUser: LoggedInUserInfo(),
                  authenticationRepository:
                      context.read<FakeAuthenticationRepository>())),
          BlocProvider(
              create: (context) => PostBookmarkCubit(
                  postRepository: context.read<FakePostReposiory>())),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (previous, current) =>
              current is ThemeDarkModeState || current is ThemeLightModeState,
          builder: (context, state) => MaterialApp(
            title: 'News App',
            theme: state is ThemeDarkModeState
                ? ThemeStyle.darkTheme()
                : ThemeStyle.lightTheme(),
            onGenerateRoute: AppRouter.generateRoute,
          ),
        ),
      ),
    );
  }
}
