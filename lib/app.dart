import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/features/posts/application/posts_services.dart';

import 'src/features/authentication/application/authentication_services.dart';
import 'src/features/authentication/data/repositories/authentciation_repositories.dart';
import 'src/features/authentication/presentation/authentication_presentations.dart';
import 'src/features/posts/data/data_sources/fake_posts_data_source.dart';
import 'src/features/posts/data/repositories/posts_repositories.dart';
import 'src/features/posts/presentation/post_bookmark_button/post_bookmark_cubit/post_bookmark_cubit.dart';
import 'src/features/posts_category/data/data_sources/fake_post_category_data_source.dart';
import 'src/features/posts_category/data/repositories/post_category_repositories.dart';
import 'src/features/settings/application/settings_services.dart';
import 'src/features/settings/presentation/blocs/settings_blocs.dart';
import 'src/router/app_router.dart';
import 'src/server_impementation/fake_database.dart';
import 'src/style.dart';

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
                fakePostsDataSource: FakePostsDataSource(),
                fetchDelayDurationInSeconds: 2,
                toggleBookmarkDelay: 10)),
        RepositoryProvider(
            create: (context) => FakePostCategoryRepository(
                delayDurationInSeconds: 1,
                fakePostCategoryDataSource:
                    FakePostCategoryDataSource(fakeDatabase: FakeDatabase()))),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ThemeCubit(themeService: ThemeService())),
          BlocProvider(
            lazy: false,
            create: (context) => AuthenticationCubit(
              authenticationService: AuthenticationService(
                  authenticationRepository:
                      context.read<FakeAuthenticationRepository>(),
                  authenticateduserService: AuthenticatedUserService()),
            ),
          ),
          BlocProvider(
              create: (context) => PostBookmarkCubit(
                  postService: PostService(
                      postRepository: context.read<FakePostReposiory>()))),
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
