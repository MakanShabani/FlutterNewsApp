import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/src/common_widgets/common_widgest.dart';
import 'package:responsive_admin_dashboard/src/features/authentication/presentation/authentication_presentations.dart';
import 'package:responsive_admin_dashboard/src/features/posts/presentation/posts_list/empty_posts_list.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';
import 'package:responsive_admin_dashboard/src/router/route_names.dart';
import '../../../bookmark post/presentation/post_bookmark_button/post_bookmark_cubit/post_bookmark_cubit.dart';
import '../../application/posts_list_service.dart';
import '../../data/repositories/fake_posts_list_repository.dart';
import '../../domain/posts_models.dart';
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
                return CustomScrollView(slivers: [
                  const SliverAppBar(
                    title: Text('Bookmarks'),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorNotAuthorize(
                      onActionClicked: () =>
                          Navigator.pushNamed(context, loginRoute),
                    ),
                  ),
                ]);
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

  //we use this fuction to update post's bookmark value locally
  void onPostBookmarkUpdated(int index, Post post, bool newBookmarkStatus) {
    _postsListCubit.updatePostBookmarkStatusWithoutChangingState(
        post, newBookmarkStatus);
    _postslistNotifireCubit.modifyItem(
        index, post..isBookmarked = newBookmarkStatus, false);
  }

  Widget mainContents() {
    return CustomScrollView(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      slivers: [
        //Appbar section
        const SliverAppBar(
          centerTitle: true,
          title: Text('Bookmarks'),
        ),

        //Posts list section
        BlocBuilder<PostsListCubit, PostsListCubitState>(
          buildWhen: (previous, current) =>
              (current is PostsListCubitFetchedSuccessfully &&
                  current.lastLoadedPagingOptionsDto.offset == 0) ||
              (current is PostsListCubitFetchingHasError &&
                  current.failedLoadPagingOptionsVm.offset == 0) ||
              (current is PostsListCubitFetching &&
                  current.toLoadPagingOptionsVm.offset == 0),
          builder: (context, state) {
            if (state is PostsListCubitFetching) {
              //show the loading indicator for the inital fetch
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: LoadingIndicator(hasBackground: false),
                ),
              );
            }

            if (state is PostsListCubitFetchingHasError) {
              //show the error widget for the inital fetch
              //TODO:: show appropriate error with respect to the error code
              return SliverToBoxAdapter(
                child: ErrorInternal(
                  onActionClicked: () => _fetchPosts(),
                ),
              );
            }

            if (state is PostsListCubitFetchedSuccessfully) {
              return state.posts.isNotEmpty
                  ? SliverInfiniteAnimatedList(
                      items: state.posts,
                      itemLayout: (item, index) => PostItemInVerticalList(
                        itemHeight: 160,
                        rightMargin: screenHorizontalPadding,
                        bottoMargin: 20.0,
                        leftMargin: screenHorizontalPadding,
                        borderRadious: circularBorderRadious,
                        item: item as Post,
                        onPostBookMarkUpdated: (postId, newBookmarkValue) =>
                            onPostBookmarkUpdated(
                                index, postId, newBookmarkValue),
                      ),
                      loadingLayout: const SizedBox(
                        height: 50.0,
                        child: LoadingIndicator(
                          hasBackground: true,
                          backgroundHeight: 20.0,
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: EmptyPostsList(
                        onActionClicked: () => _fetchPosts(),
                      ),
                    );
              ;
            }

            //default view
            return Container();
          },
        )
      ],
    );
  }
}
