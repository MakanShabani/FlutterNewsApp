import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/constants.dart/constants.dart';
import '../../../../router/route_names.dart';
import '../../../authentication/presentation/blocs/authentication_cubit.dart';
import '../../application/posts_list_service.dart';
import '../../data/repositories/posts_repositories.dart';
import '../post_bookmark_button/post_bookmark_cubit/post_bookmark_cubit.dart';
import 'blocs/posts_list_blocs.dart';

class BookmarkSection extends StatefulWidget {
  const BookmarkSection({Key? key}) : super(key: key);

  @override
  State<BookmarkSection> createState() => _BookmarkSectionState();
}

class _BookmarkSectionState extends State<BookmarkSection>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListenrer);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //Notice the super-call here.
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => PostsListCubit(
                postsListService: PostsListService(
                    postRepository: context.read<FakePostReposiory>()),
                haowManyPostFetchEachTime: 10)),
        BlocProvider(
          create: (context) => PostsListNotifireCubit(),
        )
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationCubit, AuthenticationState>(
            listenWhen: (previous, current) =>
                current is AuthenticationLoggedIn,
            listener: (context, state) {
              if (state is AuthenticationLoggedIn) {
                context
                    .read<PostsListCubit>()
                    .fetch(state.user.token, null, true);
              }
            },
          ),
          BlocListener<PostBookmarkCubit, PostBookmarkState>(
            listenWhen: (previous, current) =>
                current is PostBookmarkUpdatedSuccessfullyState,
            listener: (context, state) {
              if (state is PostBookmarkUpdatedSuccessfullyState) {
                if (state.newBookmarkValue) {
                  //add the porst to actual list of posts in state
                  context
                      .read<PostsListCubit>()
                      .updatePostBookmarkStatusWithoutChangingState(
                          state.post.id, state.newBookmarkValue);
                  //update animatedList list if its posts
                  context
                      .read<PostsListNotifireCubit>()
                      .insertPosts([state.post]);
                } else {
                  //add the porst to actual list of posts in state
                  context
                      .read<PostsListCubit>()
                      .updatePostBookmarkStatusWithoutChangingState(
                          state.post.id, state.newBookmarkValue);

                  //update animatedList list if its posts
                  context
                      .read<PostsListNotifireCubit>()
                      .removePost(state.post.id);
                }
              }
            },
          )
        ],
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
          if (state is AuthenticationLoggedIn) {
            //Show user's bookmarks

            return CustomScrollView(controller: _scrollController, slivers: [
              const SliverAppBar(
                title: Text('Bookmarks'),
                stretch: true,
                pinned: true,
              ),
              //Posts List
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                  buildWhen: (previous, current) =>
                      (current is PostsListCubitFetching &&
                          isThisFirstFetching(current)) ||
                      (current is PostsListCubitFetchedSuccessfully &&
                          current.posts.isEmpty) ||
                      (current is PostsListCubitFetchingHasError &&
                          isThisFirstFetching(current)),
                  builder: (context, state) {
                    if (state is PostsListCubitFetching) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text('First Loading'),
                        ),
                      );
                    }
                    if (state is PostsListCubitFetchedSuccessfully) {
                      return PostsListSection(
                        items: state.posts,
                        onPostBookMarkUpdated: (postId, newBookmarkStatus) =>
                            (postId, newBookmarkStatus) => context
                                .read<PostsListCubit>()
                                .updatePostBookmarkStatusWithoutChangingState(
                                    postId, newBookmarkStatus),
                      );
                    }

                    if (state is PostsListCubitFetchingHasError) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text('Error in first Fetching'),
                        ),
                      );
                    }

                    //init state
                    return const SliverToBoxAdapter();
                  }),

              //Show loading indicator at the end of the list
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                  buildWhen: (previous, current) =>
                      (current is PostsListCubitFetching &&
                          !isThisFirstFetching(current)) ||
                      current is PostsListCubitFetchedSuccessfully ||
                      current is PostsListCubitFetchingHasError,
                  builder: (context, state) {
                    if (state is PostsListCubitFetching) {
                      return const SliverFixedExtentList(
                          delegate: SliverChildListDelegate.fixed([
                            LoadingIndicator(
                              hasBackground: true,
                              backgroundHeight: 20.0,
                            )
                          ]),
                          itemExtent: 50.0);
                    }
                    //init state
                    return const SliverToBoxAdapter();
                  })
            ]);
          } else {
            //Show warning widget that user must be signed in to use bookmark section
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text('Bookmarks'),
                  stretch: true,
                  pinned: true,
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(0, 0, 0, screenBottomPadding),
                    child: NotSigenIn(
                      onActionClicked: () =>
                          Navigator.pushNamed(context, loginRoute),
                    ),
                  ),
                )
              ],
            );
          }
        }),
      ),
    );
  }

  bool isThisFirstFetching(PostsListCubitState state) {
    return state.posts.isEmpty;
  }

  void scrollListenrer() {
    if (context.read<PostsListCubit>().state
            is! PostsListCubitFetchedSuccessfully &&
        !(context.read<PostsListCubit>().state
                is PostsListCubitFetchingHasError &&
            isThisFirstFetching((context.read<PostsListCubit>().state)))) {
      return;
    }

    if (context.read<PostsListCubit>().state is PostsListCubitFetching) {
      return;
    }

    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      context.read<PostsListCubit>().fetch(
          context.read<AuthenticationCubit>().state is AuthenticationLoggedIn
              ? (context.read<AuthenticationCubit>().state
                      as AuthenticationLoggedIn)
                  .user
                  .token
              : null,
          null,
          true);
    }
  }
}
