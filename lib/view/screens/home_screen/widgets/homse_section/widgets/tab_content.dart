import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/bloc/posts_list_notifire_cubit/posts_list_notifire_cubit.dart';

import '../../../../../../bloc/blocs.dart';
import '../../../../../../models/entities/entities.dart';
import '../../../../../../repositories/repo_fake_implementaion/fake_repositories.dart';
import '../../../../../view_constants.dart' as view_constants;
import '../../../../../widgets/widgest.dart';

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
      postRepository: context.read<FakePostReposiory>(),
      haowManyPostToFetchEachTime: 10,
    )..fetch(
        context.read<AuthenticationBloc>().state is LoggedIn
            ? (context.read<AuthenticationBloc>().state as LoggedIn).user.token
            : null,
        widget.category?.id);
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
                  current.lastLoadedPagingOptionsVm.offset > 0 &&
                  current.newDownloadedPosts.isNotEmpty) ||
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
              context
                  .read<PostsListNotifireCubit>()
                  .insertPosts(state.newDownloadedPosts);

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
                    current.lastLoadedPagingOptionsVm.offset == 0,
                builder: (context, state) {
                  if (state is PostsListCubitFetchedSuccessfully) {
                    return caouroselSection(
                        state.newDownloadedPosts.take(5).toList());
                  }

                  //initial state
                  return const SliverToBoxAdapter();
                },
              ),

              //Posts List Header
              BlocBuilder<PostsListCubit, PostsListCubitState>(
                  buildWhen: (previous, current) =>
                      current is PostsListCubitFetchedSuccessfully &&
                      current.lastLoadedPagingOptionsVm.offset == 0,
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
                          current.lastLoadedPagingOptionsVm.offset == 0) ||
                      (current is PostsListCubitFetchingHasError &&
                          isThisFirtFetchingError(current)),
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
                        items:
                            postListsCubit.allPostsFetchedSuccessfully(state),
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
                  horizontal: view_constants.screenHorizontalPadding),
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
              borderRadious: view_constants.circularBorderRadious,
              cauroselLeftPadding: view_constants.screenHorizontalPadding,
              cauroselRightPadding: view_constants.screenHorizontalPadding,
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
            isThisFirtFetchingError(
                (postListsCubit.state as PostsListCubitFetchingHasError)))) {
      return;
    }

    if (postListsCubit.state is PostsListCubitFetching) {
      return;
    }

    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      postListsCubit.fetch(
          context.read<AuthenticationBloc>().state is LoggedIn
              ? (context.read<AuthenticationBloc>().state as LoggedIn)
                  .user
                  .token
              : null,
          widget.category?.id);
    }
  }

  bool isThisFirstFetching(PostsListCubitFetching state) {
    return state.lastLoadedPagingOptionsVm == null;
  }

  bool isThisFirtFetchingError(PostsListCubitFetchingHasError state) {
    return state.lastLoadedPagingOptionsVm == null;
  }
}
