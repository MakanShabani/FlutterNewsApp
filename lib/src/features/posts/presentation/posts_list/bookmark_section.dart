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
  late ListNotifireCubit<Post> _postslistNotifireCubit;

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

    _postslistNotifireCubit = ListNotifireCubit<Post>();
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
        child: MultiBlocListener(
          listeners: [
            authenticationListener(),
            postsListCubitListener(),
            bookmarkCubitListener(),
          ],
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
        _postsListCubit.state is PostsListCubitPostHasBeenAdded ||
        (_postsListCubit.state is PostsListCubitFetchingHasError &&
            (_postsListCubit.state as PostsListCubitFetchingHasError)
                .posts
                .isNotEmpty)) {
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
      slivers: [
        //Appbar section
        const SliverAppBar(
          centerTitle: true,
          title: Text('Bookmarks'),
        ),

        //Posts list section
        BlocBuilder<PostsListCubit, PostsListCubitState>(
          buildWhen: (previous, current) =>
              (current is PostsListCubitPostHasBeenAdded &&
                  (previous.posts.isEmpty &&
                      previous is! PostsListCubitFetching)) ||
              (current is PostsListCubitFetchedSuccessfully &&
                  current.posts.isEmpty) ||
              (current is PostsListCubitFetchingHasError &&
                  current.posts.isEmpty) ||
              (current is PostsListCubitFetching && current.posts.isEmpty),
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
                child: state.error.statusCode == 401
                    ? ErrorNotAuthorize(onActionClicked: () => _fetchPosts())
                    : ErrorInternal(
                        onActionClicked: () => _fetchPosts(),
                      ),
              );
            }

            if (state is PostsListCubitFetchedSuccessfully ||
                state is PostsListCubitPostHasBeenAdded) {
              return state.posts.isNotEmpty
                  ? SliverInfiniteAnimatedList<Post>(
                      items: state.posts,
                      itemLayoutBuilder: (item, index) =>
                          PostItemInVerticalList(
                        itemHeight: 160,
                        rightMargin: screenHorizontalPadding,
                        bottoMargin: 20.0,
                        leftMargin: screenHorizontalPadding,
                        borderRadious: circularBorderRadious,
                        item: item,
                        onPostBookmarkPressed: (post, newBookmarkValueToSet) =>
                            onPostBookMarkPressed(post, newBookmarkValueToSet),
                      ),
                      removeItemBuilder: (item, index) =>
                          PostItemInVerticalList(
                        key: UniqueKey(),
                        itemHeight: 160,
                        rightMargin: screenHorizontalPadding,
                        bottoMargin: 20.0,
                        leftMargin: screenHorizontalPadding,
                        borderRadious: circularBorderRadious,
                        item: item,
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
            return SliverToBoxAdapter(
              child: Container(),
            );
          },
        )
      ],
    );
  }

  BlocListener<PostsListCubit, PostsListCubitState> postsListCubitListener() {
    return BlocListener<PostsListCubit, PostsListCubitState>(
      listenWhen: (previous, current) =>
          (current is PostsListCubitFetchedSuccessfully &&
              current.posts.isNotEmpty) ||
          (current is PostsListCubitFetchingHasError &&
              current.posts.isNotEmpty) ||
          (current is PostsListCubitFetching && current.posts.isNotEmpty),
      listener: (context, state) {
        if (state is PostsListCubitFetchedSuccessfully) {
          //After First successful fetch
          //notify SliverInfiniteAnimatedList to show new posts
          List<Post> newPosts =
              state.posts.skip(state.previousPostsLenght).toList();
          _postslistNotifireCubit.insertItems(newPosts, false);

          if (newPosts.isNotEmpty) {
            if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent) {
              _scrollController.animateTo(_scrollController.offset + 100,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInBack);
            }
          } else {
            //if there is no new posts, we show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
                appSnackBar(context: context, message: noMoreBookmarkToFetch));
          }

          return;
        }

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
    );
  }

  BlocListener<PostBookmarkCubit, PostBookmarkState> bookmarkCubitListener() {
    return BlocListener<PostBookmarkCubit, PostBookmarkState>(
      listenWhen: (previous, current) =>
          current is PostBookmarkUpdatedSuccessfullyState,
      listener: (context, state) {
        if (state is PostBookmarkUpdatedSuccessfullyState) {
          if (state.newBookmarkValue) {
            //notify the postListCubit item to add the bookmark post to its list
            _postsListCubit.addPostToTheList(
                post: state.post..isBookmarked = state.newBookmarkValue);

            //notify SliverInfiniteAnimatedList to add post to the bookmark list

            _postslistNotifireCubit.insertItems(
                [state.post..isBookmarked = state.newBookmarkValue], true);
            // if (_scrollController.offset ==
            //     _scrollController.position.maxScrollExtent) {
            //   _scrollController.animateTo(_scrollController.offset + 100,
            //       duration: const Duration(milliseconds: 800),
            //       curve: Curves.easeInBack);
            // }
          } else {}
          return;
        }
      },
    );
  }

  BlocListener<AuthenticationCubit, AuthenticationState>
      authenticationListener() {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: ((previous, current) =>
          current is AuthenticationLoggedIn ||
          current is AuthenticationLoggedout),
      listener: (context, state) {
        if (state is AuthenticationLoggedIn) {
          _fetchPosts();
          return;
        }

        if (state is AuthenticationLoggedout) {
          _postsListCubit.resetToInitial();
        }
      },
    );
  }

  // we use this function to do stuff when bookmark button is pressed
  void onPostBookMarkPressed(Post post, bool newBookmarkStatusToSet) {
    if (context.read<AuthenticationCubit>().state is! AuthenticationLoggedIn) {
      return;
    }

    context.read<PostBookmarkCubit>().toggleBookmark(
        userToken: (context.read<AuthenticationCubit>().state
                as AuthenticationLoggedIn)
            .user
            .token,
        post: post,
        newBookmarkValueToSet: newBookmarkStatusToSet);
  }
}
