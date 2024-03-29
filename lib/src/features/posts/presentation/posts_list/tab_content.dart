import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaspeaker_news_app/src/features/authentication/presentation/authentication_presentations.dart';
import 'package:shaspeaker_news_app/src/features/posts/data/repositories/posts_repositories.dart';
import 'package:shaspeaker_news_app/src/features/posts/presentation/posts_list/home_section/tab_bar_cubit/tab_bar_cubit.dart';
import 'package:shaspeaker_news_app/src/router/app_router.dart';
import 'package:shaspeaker_news_app/src/router/route_names.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/constants.dart/constants.dart';
import '../../../bookmark post/presentation/post_bookmark_button/post_bookmark_cubit/post_bookmark_cubit.dart';
import '../../../posts_category/domain/post_category_models.dart';
import '../../application/post_service.dart';
import '../../domain/posts_models.dart';
import 'blocs/posts_list_blocs.dart';

class TabContent extends StatefulWidget {
  final int categoryIndex;
  final PostCategory? category;

  const TabContent({Key? key, required this.categoryIndex, this.category})
      : super(key: key);

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  late PostsListCubit _postListsCubit;
  late ListNotifireCubit<Post> _postsListNotifireCubit;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListenrer);
    _postsListNotifireCubit = ListNotifireCubit();
    _postListsCubit = PostsListCubit(
      postsListService:
          PostService(postRepository: context.read<FakePostReposiory>()),
      haowManyPostFetchEachTime: 10,
    )..fetch(
        context.read<AuthenticationCubit>().state is AuthenticationLoggedIn
            ? (context.read<AuthenticationCubit>().state
                    as AuthenticationLoggedIn)
                .user
                .token
            : null,
        widget.category?.id,
        null);
  }

  @override
  void dispose() {
    _postsListNotifireCubit.close();
    _postListsCubit.close();
    _scrollController.removeListener(scrollListenrer);
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
          BlocProvider.value(
            value: _postListsCubit,
          ),
          BlocProvider.value(value: _postsListNotifireCubit),
        ],
        child: BlocListener<PostsListCubit, PostsListCubitState>(
          //listen to the fetching process after the first fetch
          listenWhen: (previous, current) =>
              current is PostsListCubitFetchedSuccessfully ||
              current is PostsListNoMorePostsToFetch ||
              (current is PostsListCubitFetching && current.posts.isNotEmpty) ||
              (current is PostsListCubitFetchingHasError &&
                  current.posts.isNotEmpty),
          listener: (context, state) {
            if (state is PostsListCubitFetching) {
              //tell the InifiniteAnimatedList widget to show loading indicator at the end of it
              _postsListNotifireCubit.showLoading();

              //smooth scroll to the loading indicator if we are at the end of the list
              if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent) {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent + 50,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }
            } else if (state is PostsListNoMorePostsToFetch) {
              //tell the InifiniteAnimatedList widget to hide loading indicator at the end of it
              _postsListNotifireCubit.resetState();
            } else if (state is PostsListCubitFetchedSuccessfully) {
              if (state.posts.length == state.fetchedPosts.length) {
                //it was first fetch
                //we notify HomeSection's Appbar to show post's category tabbar instead of Home title
                context.read<TabBarCubit>().showTabBar();
                return;
              }

              //After First successful fetch
              _postsListNotifireCubit.insertItems(state.fetchedPosts, false);

              if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent) {
                _scrollController.animateTo(_scrollController.offset + 100,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInBack);
              }
            } else if (state is PostsListCubitFetchingHasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                appSnackBar(
                  context: context,
                  message: state.error.message,
                  actionLabel: 'try again',
                  action: () => _postListsCubit.fetch(
                      context.read<AuthenticationCubit>().state
                              is AuthenticationLoggedIn
                          ? (context.read<AuthenticationCubit>().state
                                  as AuthenticationLoggedIn)
                              .user
                              .token
                          : null,
                      widget.category?.id,
                      null),
                ),
              );
              return;
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            slivers: [
              //Free Space Between Appbar and contents --> like Top padding
              //Show contents top padding when there are some posts in the list
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                buildWhen: (previous, current) =>
                    (current is PostsListCubitFetchedSuccessfully &&
                        previous.posts.isEmpty) ||
                    (current is PostsListCubitFetching &&
                        previous.posts.isEmpty) ||
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

              //Caurosel
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                // only rebuild on first fetch
                buildWhen: (previous, current) =>
                    current is PostsListCubitFetchedSuccessfully &&
                    previous.posts.isEmpty,
                builder: (context, state) {
                  if (state is PostsListCubitFetchedSuccessfully) {
                    return caouroselSection(state.posts.take(5).toList());
                  }

                  //initial state
                  return const SliverToBoxAdapter();
                },
              ),

              //Posts List Header
              //only rebuild after first successful fetch
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                  buildWhen: (previous, current) =>
                      current is PostsListCubitFetchedSuccessfully &&
                      previous.posts.isEmpty,
                  builder: (context, state) {
                    if (state is PostsListCubitFetchedSuccessfully) {
                      return postsListSectionHeader();
                    }

                    //initial state
                    return const SliverToBoxAdapter();
                  }),

              //Posts List
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                  //only rebuild widget after first fetch has completed
                  buildWhen: (previous, current) =>
                      (current is PostsListCubitFetching &&
                          current.posts.isEmpty) ||
                      (current is PostsListCubitFetchedSuccessfully &&
                          previous.posts.isEmpty) ||
                      (current is PostsListCubitFetchingHasError &&
                          current.posts.isEmpty) ||
                      current is PostsListCubitIsEmpty,
                  builder: (context, state) {
                    if (state is PostsListCubitFetching) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: LoadingIndicator(
                            hasBackground: false,
                          ),
                        ),
                      );
                    }
                    if (state is PostsListCubitFetchedSuccessfully) {
                      return SliverInfiniteAnimatedList<Post>(
                        items: state.posts,
                        firstItemWithoutTopPadding: true,
                        lastItemWithoutBottomPadding: true,
                        itemLayoutBuilder: (item, index) =>
                            PostItemInVerticalList(
                          itemHeight: 160,
                          rightMargin: screenHorizontalPadding,
                          bottoMargin: 20.0,
                          leftMargin: screenHorizontalPadding,
                          borderRadious: circularBorderRadious,
                          item: item,
                          onPostBookMarkUpdated: (post, newBookmarkValue) =>
                              onPostBookmarkUpdated(
                                  index, post, newBookmarkValue),
                          onPostBookmarkPressed:
                              (post, newBookmarkValueToSet) =>
                                  onPostBookMarkPressed(
                                      post, newBookmarkValueToSet),
                          onItemtapped: () => Navigator.pushNamed(
                              context, postRoute,
                              arguments: AppRouter.createPostRouteArguments(
                                  item.id, item.category.id)),
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

                    //First fetch Error
                    if (state is PostsListCubitFetchingHasError) {
                      return SliverToBoxAdapter(
                          child: ErrorInternal(
                        onActionClicked: fetchPosts,
                      ));
                    }

                    //init state
                    return const SliverToBoxAdapter();
                  }),
            ],
          ),
        ));
  }

// const SizedBox(
//           height: 15.0,
//         ),

  SliverList postsListSectionHeader() {
    return SliverList(
        delegate: SliverChildListDelegate([
      SizedBox(
        height: widget.category == null ? 10.0 : 0,
      ),
      widget.category == null
          ? Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: screenHorizontalPadding),
              child: Text(
                'Latest news',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : const SizedBox(
              height: 0,
            ),
      SizedBox(
        height: widget.category == null ? 15.0 : 0,
      ),
    ]));
  }

  SliverToBoxAdapter caouroselSection(List<Post> posts) {
    return SliverToBoxAdapter(
      child: widget.category == null
          ? PostCarouselWithIndicator(
              height: 210.0,
              borderRadious: circularBorderRadious,
              cauroselLeftPadding: screenHorizontalPadding,
              cauroselRightPadding: screenHorizontalPadding,
              items: posts,
              onPostBookmarkPressed: (post, newBookmarkStatus) =>
                  onPostBookMarkPressed(post, newBookmarkStatus),
              onPostBookMarkUpdated: (post, newBookmarkStatus) =>
                  _postListsCubit.updatePostsBookmarkStatus(
                      postId: post.id, newBookmarkStatus: newBookmarkStatus),
            )
          : const SizedBox(
              height: 0,
            ),
    );
  }

  void scrollListenrer() {
    if (_postListsCubit.state is! PostsListCubitFetchedSuccessfully) {
      return;
    }

    if (_postListsCubit.state is PostsListCubitFetching) {
      return;
    }

    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      //fetch new posts
      fetchPosts();
    }
  }

  //we use this fuction to update post's bookmark value locally
  void onPostBookmarkUpdated(int index, Post post, bool newBookmarkStatus) {
    _postListsCubit.updatePostsBookmarkStatus(
        postId: post.id, newBookmarkStatus: newBookmarkStatus);
    _postsListNotifireCubit.modifyItem(
        index, post..isBookmarked = newBookmarkStatus, false);
  }

  // we use this function to do stuff when bookmark button is pressed
  void onPostBookMarkPressed(Post post, bool newBookmarkStatusToSet) {
    if (context.read<AuthenticationCubit>().state is! AuthenticationLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
          context: context,
          message: error401SnackBar,
          actionLabel: 'Sign In',
          action: () => Navigator.pushNamed(context, loginRoute)));
      return;
    }

    //If bookmarking is locked -- we do nothing
    if (context.read<PostBookmarkCubit>().state.isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
        context: context,
        message: updatingBookmarksListSnackBar,
        action: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        actionLabel: 'OK',
      ));
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

  void fetchPosts() {
    _postListsCubit.fetch(
        context.read<AuthenticationCubit>().state is AuthenticationLoggedIn
            ? (context.read<AuthenticationCubit>().state
                    as AuthenticationLoggedIn)
                .user
                .token
            : null,
        widget.category?.id,
        null);
  }
}
