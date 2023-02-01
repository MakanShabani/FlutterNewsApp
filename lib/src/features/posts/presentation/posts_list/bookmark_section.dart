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
        child: BlocListener<PostsListCubit, PostsListCubitState>(
          listenWhen: (previous, current) =>
              (current is PostsListCubitFetchingHasError &&
                  current.failedLoadPagingOptionsVm.offset == 0) ||
              (current is PostsListCubitFetching &&
                  current.toLoadPagingOptionsVm.offset > 0),
          listener: (context, state) {
            if (state is PostsListCubitFetchingHasError) {
              //show snackbar when fetching ends with an error
              //for initial fetch we show an error widget in the screen >> go to the blocbuilder section
              ScaffoldMessenger.of(context).showSnackBar(
                appSnackBar(
                  context: context,
                  message: state.error.message,
                  actionLabel: 'try again',
                  action: () => _fetchPosts(),
                ),
              );
              return;
            }

            if (state is PostsListCubitFetching) {
              //notify the list widget to show the loading indicator at the end of the list.
              //for initial fetch we show the loading in the center of the screen. >> go to the blocbuilder section

              _postslistNotifireCubit.showLoading();

              //smooth scroll to the loading indicator if we are at the end of the list
              if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent) {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent + 50,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }
              return;
            }
          },
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            buildWhen: (previous, current) =>
                current is AuthenticationLoggedIn ||
                current is AuthenticationLoggedout,
            builder: (context, state) {
              if (state is AuthenticationLoggedIn) {
                //show the bookmark lists
                return mainContents();
              }

              if (state is AuthenticationLoggedout) {
                //show 403 error
                return ErrorNotAuthorize(
                  onActionClicked: () =>
                      Navigator.pushNamed(context, loginRoute),
                );
              }

              //defualt widgets
              return Container();
            },
          ),
        ));
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
        _fetchPosts();
      }
    }
  }

  void _fetchPosts() {
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

  Widget mainContents() {
    return CustomScrollView(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      slivers: [],
    );
  }
}
