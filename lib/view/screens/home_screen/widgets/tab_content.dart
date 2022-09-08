import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/blocs.dart';
import '../../../../models/entities/entities.dart';
import '../../../../repositories/repo_fake_implementaion/fake_repositories.dart';
import '../../../view_constants.dart' as view_constants;
import '../../../widgets/widgest.dart';

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
  late HomeSectionTabContentBloc _hSTCbloc;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListenrer);
    _hSTCbloc = HomeSectionTabContentBloc(
        postRepository: context.read<FakePostReposiory>(),
        haowManyPostToFetchEachTime: 10,
        categoryId: widget.category?.id)
      ..add(HomeSectionTabContentInitializeEvent(
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
      child: BlocBuilder<HomeSectionTabContentBloc, HomeSectionTabContentState>(
        buildWhen: (previous, current) =>
            current is HomeSectionTabContentInitializingHasErrorState ||
            current is HomeSectionTabContentInitializingState ||
            current is HomeSectionTabContentInitializingSuccessfullState,
        builder: (context, state) {
          if (state is HomeSectionTabContentInitializingHasErrorState) {
            //show error

            return Center(
              child: Text(
                state.error.message,
              ),
            );
          }

          if (state is HomeSectionTabContentInitializingSuccessfullState) {
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
                              cauroselLeftPadding: view_constants
                                  .screensContentsHorizontalPadding,
                              cauroselRightPadding: view_constants
                                  .screensContentsHorizontalPadding,
                              items: state.posts.take(5).toList(),
                              onPostBookMarkUpdated: (postId,
                                      newBookmarkStatus) =>
                                  context.read<HomeSectionTabContentBloc>().add(
                                      HomeSectionTabContentUpdatePostBookmarkEvent(
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
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: view_constants
                                      .screensContentsHorizontalPadding),
                              child: Text(
                                'Latest news',
                                style: TextStyle(fontSize: 22.0),
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
                  BlocBuilder<HomeSectionTabContentBloc,
                      HomeSectionTabContentState>(
                    buildWhen: (previous, current) => current
                        is HomeSectionTabContentFetchingMorePostSuccessfullState,
                    builder: (context, state) {
                      return PostsListSection(
                        items: state.posts,
                        onPostBookMarkUpdated: (postId, newBookmarkStatus) =>
                            context.read<HomeSectionTabContentBloc>().add(
                                  HomeSectionTabContentUpdatePostBookmarkEvent(
                                      postId: postId,
                                      newBookmarkStatus: newBookmarkStatus),
                                ),
                      );
                    },
                  ),
                  BlocBuilder<HomeSectionTabContentBloc,
                      HomeSectionTabContentState>(
                    buildWhen: (previous, current) =>
                        current is HomeSectionTabContentFetchingMorePostState ||
                        current
                            is HomeSectionTabContentFetchingMorePostSuccessfullState ||
                        current
                            is HomeSectionTabContentFetchingMorePostHasErrorState,
                    builder: (context, state) {
                      return SliverFixedExtentList(
                          delegate: SliverChildListDelegate.fixed([
                            state is HomeSectionTabContentFetchingMorePostState
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
    if (_hSTCbloc.state is! HomeSectionTabContentInitializingSuccessfullState &&
        _hSTCbloc.state
            is! HomeSectionTabContentFetchingMorePostSuccessfullState &&
        _hSTCbloc.state
            is! HomeSectionTabContentFetchingMorePostHasErrorState) {
      return;
    }

    if (_hSTCbloc.state is HomeSectionTabContentFetchingMorePostState) {
      return;
    }
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      _hSTCbloc.add(HomeSectionTabContentFetchMorePostsEvent(
          user: context.read<AuthenticationBloc>().state is LoggedIn
              ? (context.read<AuthenticationBloc>().state as LoggedIn).user
              : null));
    }
  }
}
