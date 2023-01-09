import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/features/authentication/presentation/authentication_presentations.dart';
import 'package:responsive_admin_dashboard/src/features/posts/application/posts_services.dart';
import 'package:responsive_admin_dashboard/src/features/posts/data/repositories/posts_repositories.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/constants.dart/constants.dart';
import '../../../posts_category/domain/post_category_models.dart';
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
  late PostsListCubit postListsCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListenrer);
    postListsCubit = PostsListCubit(
      postsListService:
          PostsListService(postRepository: context.read<FakePostReposiory>()),
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
    postListsCubit.close();
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
          BlocProvider(
            create: (context) => postListsCubit,
          ),
          BlocProvider(create: (context) => PostsListNotifireCubit())
        ],
        child: BlocListener<PostsListCubit, PostsListCubitState>(
          listenWhen: (previous, current) =>
              (current is PostsListCubitFetchedSuccessfully &&
                  current.posts.isNotEmpty) ||
              (current is PostsListCubitFetching &&
                  current.toLoadPagingOptionsVm.offset > 0),
          listener: (context, state) {
            if (state is PostsListCubitFetching) {
              if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent) {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent + 50,
                    duration: const Duration(microseconds: 1),
                    curve: Curves.easeIn);
              }
            } else if (state is PostsListCubitFetchedSuccessfully) {
              context.read<PostsListNotifireCubit>().insertPosts(state.posts
                  .skip(state.lastLoadedPagingOptionsDto.offset)
                  .toList());

              if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent) {
                _scrollController.animateTo(_scrollController.offset + 170,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInBack);
              }
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            slivers: [
              //Caurosel
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                buildWhen: (previous, current) =>
                    current is PostsListCubitFetchedSuccessfully &&
                    current.posts.isEmpty,
                builder: (context, state) {
                  if (state is PostsListCubitFetchedSuccessfully) {
                    return caouroselSection(state.posts.take(5).toList());
                  }

                  //initial state
                  return const SliverToBoxAdapter();
                },
              ),

              //Posts List Header
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                  buildWhen: (previous, current) =>
                      current is PostsListCubitFetchedSuccessfully &&
                      current.posts.isEmpty,
                  builder: (context, state) {
                    if (state is PostsListCubitFetchedSuccessfully) {
                      return postsListSectionHeader();
                    }

                    //initial state
                    return const SliverToBoxAdapter();
                  }),

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
                            (postId, newBookmarkStatus) => postListsCubit
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
                style: Theme.of(context).textTheme.labelLarge,
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
              onPostBookMarkUpdated: (postId, newBookmarkStatus) =>
                  postListsCubit.updatePostBookmarkStatusWithoutChangingState(
                      postId, newBookmarkStatus),
            )
          : const SizedBox(
              height: 0,
            ),
    );
  }

  void scrollListenrer() {
    if (postListsCubit.state is! PostsListCubitFetchedSuccessfully &&
        !(postListsCubit.state is PostsListCubitFetchingHasError &&
            isThisFirstFetching((postListsCubit.state)))) {
      return;
    }

    if (postListsCubit.state is PostsListCubitFetching) {
      return;
    }

    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      postListsCubit.fetch(
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

  bool isThisFirstFetching(PostsListCubitState state) {
    return state.posts.isEmpty;
  }
}
