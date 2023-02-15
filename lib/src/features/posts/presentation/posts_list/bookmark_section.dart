import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/src/common_widgets/common_widgest.dart';
import 'package:responsive_admin_dashboard/src/features/authentication/presentation/authentication_presentations.dart';
import 'package:responsive_admin_dashboard/src/features/posts/presentation/posts_list/empty_posts_list.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';
import 'package:responsive_admin_dashboard/src/router/route_names.dart';
import 'package:sliver_tools/sliver_tools.dart';
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

    _postslistNotifireCubit = ListNotifireCubit<Post>();

    _fetchPosts(false);
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

  BlocListener<PostsListCubit, PostsListCubitState> postsListCubitListener() {
    return BlocListener<PostsListCubit, PostsListCubitState>(
      listenWhen: (previous, current) =>
          (current is PostsListCubitFetchedSuccessfully &&
              current.posts.isNotEmpty) ||
          (current is PostsListCubitPostHasBeenAdded &&
              previous.posts.isNotEmpty) ||
          (current is PostsListCubitFetchingHasError &&
              current.posts.isNotEmpty) ||
          (current is PostsListCubitFetching && current.posts.isNotEmpty) ||
          current is PostsListCubitPostHasBeenRemoved ||
          current is PostsListNoMorePostsToFetch ||
          current is PostsListCubitIsEmpty,
      listener: (context, state) {
        //notify PostBookmarkCubit to unlock bookmarking feature, if it is locked
        context
            .read<PostBookmarkCubit>()
            .updateBookmarkingLockValue(lock: false);

        if (state is PostsListCubitFetchedSuccessfully) {
          //notify SliverInfiniteAnimatedList to show add new posts to its local list
          _postslistNotifireCubit.insertItems(state.fetchedPosts, false);
          if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
            _scrollController.animateTo(_scrollController.offset + 100,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInBack);
          }

          return;
        }

        if (state is PostsListCubitPostHasBeenAdded) {
          _postslistNotifireCubit.insertItems(state.addedPosts, true);
        }

        if (state is PostsListNoMorePostsToFetch) {
          if (state.posts.isNotEmpty) {
            //notify SliverInfiniteAnimatedList to hide its loading indicator
            _postslistNotifireCubit.resetState();

            //show snackbar --> no more bookmarks

            ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
                context: context, message: noMoreBookmarkToFetchSnackBar));

            return;
          }
        }

        if (state is PostsListCubitPostHasBeenRemoved) {
          //notify SlivierInfiniteAnimatedList to remove the post from its local list

          _postslistNotifireCubit.removeItems(state.removedPost);
          return;
        }

        if (state is PostsListCubitFetchingHasError) {
          //show snackbar when fetching ends with an error
          //for initial fetch we show an error widget in the screen >> go to the blocbuilder section
          ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar(
              context: context,
              message: state.error.message,
              actionLabel: 'Try Again',
              action: () => _fetchPosts(true),
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
          } else {
            //remove the post from bookmarks

            //remove the post from PostsListCubit
            _postsListCubit.removePostFromList(postId: state.post.id);
          }
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
          _fetchPosts(true);
          return;
        }

        if (state is AuthenticationLoggedout) {
          _postsListCubit.emptyList();
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

  void scrollListenrer() {
    if (_postsListCubit.state is PostsListCubitInitial ||
        _postsListCubit.state is PostsListCubitIsEmpty ||
        (_postsListCubit.state is PostsListCubitFetchingHasError &&
            _postsListCubit.state.posts.isEmpty) ||
        _postsListCubit.state is PostsListCubitFetching) {
      return;
    }

    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      //fetch new posts
      _fetchPosts(true);
    }
  }

  void _fetchPosts(bool checkAuthentication) {
    if (checkAuthentication) {
      if (context.read<AuthenticationCubit>().state
          is! AuthenticationLoggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
          context: context,
          message: error401SnackBar,
          actionLabel: 'Sign In',
          action: () => Navigator.pushNamed(context, loginRoute),
        ));
        return;
      }
    }

    //lock bookmarking feature to prevent user from bookmarking a post during refreshing or fetching for the first time
    //Notify PostBookmarkCubit
    //Unlock the Bookmarking feature aftre the fetching ends. --> See PostListCubitListener
    if (_postsListCubit.state.posts.isEmpty) {
      context.read<PostBookmarkCubit>().updateBookmarkingLockValue(lock: true);
    }
    _postsListCubit.fetch(
        context.read<AuthenticationCubit>().state is AuthenticationLoggedIn
            ? (context.read<AuthenticationCubit>().state
                    as AuthenticationLoggedIn)
                .user
                .token
            : null,
        null,
        true);
  }

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

        //Show contents top padding when there are some posts in the list
        BlocBuilder<PostsListCubit, PostsListCubitState>(
          buildWhen: (previous, current) =>
              (current.posts.isNotEmpty && previous.posts.isEmpty) ||
              current is PostsListCubitIsEmpty ||
              (current is PostsListCubitFetchingHasError &&
                  current.posts.isEmpty),
          builder: (context, state) {
            return SliverToBoxAdapter(
              child: SizedBox(
                height: state.posts.isEmpty ? 0 : screenTopPadding,
              ),
            );
          },
        ),

        //Posts list section
        BlocBuilder<PostsListCubit, PostsListCubitState>(
          buildWhen: (previous, current) =>
              (current is PostsListCubitFetching && current.posts.isEmpty) ||
              (current is PostsListCubitFetchedSuccessfully &&
                  previous.posts.isEmpty) ||
              (current is PostsListCubitPostHasBeenAdded &&
                  previous.posts.isEmpty) ||
              current is PostsListCubitIsEmpty ||
              (current is PostsListCubitFetchingHasError &&
                  current.posts.isEmpty),
          builder: (context, state) {
            return SliverAnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _mainContentListSection(state));
          },
        )
      ],
    );
  }

  Widget _mainContentListSection(PostsListCubitState state) {
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
            ? ErrorNotAuthorize(
                onActionClicked: () => Navigator.pushNamed(context, loginRoute))
            : ErrorInternal(
                onActionClicked: () => _fetchPosts(true),
              ),
      );
    }

    if (state is PostsListCubitFetchedSuccessfully ||
        state is PostsListCubitPostHasBeenAdded) {
      return SliverInfiniteAnimatedList<Post>(
        items: state.posts,
        itemLayoutBuilder: (item, index) => PostItemInVerticalList(
          key: UniqueKey(),
          itemHeight: 160,
          rightMargin: screenHorizontalPadding,
          bottoMargin: 20.0,
          leftMargin: screenHorizontalPadding,
          borderRadious: circularBorderRadious,
          item: item,
          onPostBookmarkPressed: (post, newBookmarkValueToSet) =>
              onPostBookMarkPressed(post, newBookmarkValueToSet),
        ),
        removeItemBuilder: (item, index) => PostItemInVerticalList(
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
      );
    }
    if (state is PostsListCubitIsEmpty) {
      return SliverToBoxAdapter(
        child: EmptyPostsList(
          onActionClicked: () => _fetchPosts(true),
        ),
      );
    }

    //default view
    return SliverToBoxAdapter(
      child: Container(),
    );
  }
}
