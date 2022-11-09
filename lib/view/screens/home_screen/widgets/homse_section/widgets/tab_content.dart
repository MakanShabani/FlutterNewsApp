import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late PostsListBloc _hSTCbloc;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListenrer);
    _hSTCbloc = PostsListBloc(
        postRepository: context.read<FakePostReposiory>(),
        haowManyPostToFetchEachTime: 10,
        categoryId: widget.category?.id)
      ..add(PostsListInitializeEvent(
          user: context.read<AuthenticationBloc>().state is LoggedIn
              ? (context.read<AuthenticationBloc>().state as LoggedIn).user
              : null));
  }

  @override
  void dispose() {
    _hSTCbloc.close();
    _scrollController.removeListener(scrollListenrer);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //Notice the super-call here.
    super.build(context);

    return BlocProvider(
      create: (context) => _hSTCbloc,
      child: BlocBuilder<PostsListBloc, PostsListState>(
        buildWhen: (previous, current) =>
            current is PostsListInitializingHasErrorState ||
            current is PostsListInitializingState ||
            current is PostsListInitializingSuccessfulState,
        builder: (context, state) {
          if (state is PostsListInitializingHasErrorState) {
            //show error

            return Center(
              child: Text(
                state.error.message,
              ),
            );
          }

          if (state is PostsListInitializingSuccessfulState) {
            //show contents
            return CustomScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(
                        height: 15.0,
                      ),
                      widget.category == null
                          ? PostCarouselWithIndicator(
                              height: 210.0,
                              borderRadious:
                                  view_constants.circularBorderRadious,
                              cauroselLeftPadding:
                                  view_constants.screenHorizontalPadding,
                              cauroselRightPadding:
                                  view_constants.screenHorizontalPadding,
                              items: state.posts.take(5).toList(),
                              onPostBookMarkUpdated:
                                  (postId, newBookmarkStatus) => context
                                      .read<PostsListBloc>()
                                      .add(PostsListUpdatePostBookmarkEvent(
                                          postId: postId,
                                          newBookmarkStatus:
                                              newBookmarkStatus)),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      SizedBox(
                        height: widget.category == null ? 10.0 : 0,
                      ),
                      widget.category == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      view_constants.screenHorizontalPadding),
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
                    ]),
                  ),
                  BlocBuilder<PostsListBloc, PostsListState>(
                    buildWhen: (previous, current) =>
                        current is PostsListFetchingMorePostSuccessfulState,
                    builder: (context, state) {
                      return PostsListSection(
                        items: state.posts,
                        onPostBookMarkUpdated: (postId, newBookmarkStatus) =>
                            context.read<PostsListBloc>().add(
                                  PostsListUpdatePostBookmarkEvent(
                                      postId: postId,
                                      newBookmarkStatus: newBookmarkStatus),
                                ),
                      );
                    },
                  ),
                  BlocBuilder<PostsListBloc, PostsListState>(
                    buildWhen: (previous, current) =>
                        current is PostsListFetchingMorePostState ||
                        current is PostsListFetchingMorePostSuccessfulState ||
                        current is PostsListFetchingMorePostHasErrorState,
                    builder: (context, state) {
                      return SliverFixedExtentList(
                          delegate: SliverChildListDelegate.fixed([
                            state is PostsListFetchingMorePostState
                                ? const LoadingIndicator(
                                    hasBackground: true,
                                    backgroundHeight: 20.0,
                                  )
                                : const SizedBox(
                                    height: 20.0,
                                  )
                          ]),
                          itemExtent: 20.0);
                    },
                  )
                ]);
          }

          //show loading
          return const Center(
            child: Text(
              'loading',
            ),
          );
        },
      ),
    );
  }

  void scrollListenrer() {
    if (_hSTCbloc.state is! PostsListInitializingSuccessfulState &&
        _hSTCbloc.state is! PostsListFetchingMorePostSuccessfulState &&
        _hSTCbloc.state is! PostsListFetchingMorePostHasErrorState) {
      return;
    }

    if (_hSTCbloc.state is PostsListFetchingMorePostState) {
      return;
    }
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      _hSTCbloc.add(PostsListFetchMorePostsEvent(
          user: context.read<AuthenticationBloc>().state is LoggedIn
              ? (context.read<AuthenticationBloc>().state as LoggedIn).user
              : null));
    }
  }
}
