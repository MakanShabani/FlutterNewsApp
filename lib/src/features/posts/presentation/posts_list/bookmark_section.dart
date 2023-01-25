import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/src/common_widgets/common_widgest.dart';
import 'package:responsive_admin_dashboard/src/features/authentication/presentation/authentication_presentations.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';
import 'package:responsive_admin_dashboard/src/router/route_names.dart';
import '../../application/posts_list_service.dart';
import '../../data/repositories/fake_posts_list_repository.dart';
import 'blocs/posts_list_blocs.dart';

class BookmarkSection extends StatefulWidget {
  const BookmarkSection({Key? key}) : super(key: key);

  @override
  State<BookmarkSection> createState() => _BookmarkSectionState();
}

class _BookmarkSectionState extends State<BookmarkSection>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  late PostsListCubit _postsListCubit;
  late ListNotifireCubit _postslistNotifireCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListenrer);

    _postsListCubit = PostsListCubit(
        postsListService:
            PostsListService(postRepository: context.read<FakePostReposiory>()),
        haowManyPostFetchEachTime: 10);
    if (context.read<AuthenticationCubit>().state is AuthenticationLoggedIn) {
      _postsListCubit.fetch(
          (context.read<AuthenticationCubit>().state as AuthenticationLoggedIn)
              .user
              .token,
          null,
          true);
    }

    _postslistNotifireCubit = ListNotifireCubit();
  }

  @override
  void dispose() {
    _postslistNotifireCubit.close();
    _postsListCubit.close();
    _scrollController.removeListener(scrollListenrer);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //Notice the super-call here.
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _postsListCubit),
        BlocProvider.value(value: _postslistNotifireCubit),
      ],
      child: Container(),
    );
  }

  void scrollListenrer() {
    if (_postsListCubit.state is PostsListCubitFetchedSuccessfully ||
        (_postsListCubit.state is PostsListCubitFetchingHasError &&
            (_postsListCubit.state as PostsListCubitFetchingHasError)
                    .failedLoadPagingOptionsVm
                    .offset >
                0)) {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        //fetch new posts
        fetchPosts();
      }
    }
  }

  void fetchPosts() {
    if (context.read<AuthenticationCubit>().state is! AuthenticationLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
        context: context,
        message: error401SnackBar,
        actionLabel: 'Sign In',
        action: () => Navigator.pushNamed(context, loginRoute),
      ));
      return;
    }
    _postsListCubit.fetch(
        (context.read<AuthenticationCubit>().state as AuthenticationLoggedIn)
            .user
            .token,
        null,
        true);
  }
}
