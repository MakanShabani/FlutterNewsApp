import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/blocs.dart';
import '../../../../models/entities/ViewModels/view_models.dart';
import '../../../../models/entities/entities.dart';
import '../../../../models/repositories/repo_fake_implementaion/fake_post_repository.dart';
import '../../../view_constants.dart' as viewConstants;
import './widgets.dart';

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
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //Notice the super-call here.
    super.build(context);

    return RepositoryProvider(
      create: (context) => FakePostReposiory(),
      child: BlocProvider(
        create: (context) => HomeSectionTabContentBloc(
            postRepository: context.read<FakePostReposiory>())
          ..add(HomeSectionTabContentInitializeEvent(
              categoryToLoad: widget.category,
              pagingOptions: PagingOptionsVm(offset: 0, limit: 10))),
        child:
            BlocBuilder<HomeSectionTabContentBloc, HomeSectionTabContentState>(
          buildWhen: (previous, current) =>
              current is! HomeSectionTabContentFetchingMorePostHasErrorState,
          builder: (context, state) {
            if (state is HomeSectionTabContentInitializingState) {
              //show loading
              return const Center(
                child: Text(
                  'loading',
                ),
              );
            }

            if (state is HomeSectionTabContentInitializingHasErrorState) {
              //show error

              return Center(
                child: Text(
                  state.error.message,
                ),
              );
            }

            if (state is HomeSectionTabContentInitializingSuccessfullState ||
                state
                    is HomeSectionTabContentFetchingMorePostSuccessfullState ||
                state is HomeSectionTabContentFetchingMorePostState) {
              //show contents
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    widget.category == null
                        ? PostCarouselWithIndicator(
                            height: 200.0,
                            cauroselLeftPadding:
                                viewConstants.screensContentsPadding,
                            cauroselRightPadding:
                                viewConstants.screensContentsPadding,
                            onTogglePostBookmark: (postId, isBookmarked) =>
                                context.read<HomeSectionTabContentBloc>().add(
                                    HomeSectionTabContentUpdatePostBookmarkStatus(
                                        postId: postId,
                                        isBookmarked: isBookmarked)),
                            items: state
                                    is HomeSectionTabContentInitializingSuccessfullState
                                ? state.posts.take(5).toList()
                                : state
                                        is HomeSectionTabContentFetchingMorePostSuccessfullState
                                    ? state.posts.take(5).toList()
                                    : (state
                                            as HomeSectionTabContentFetchingMorePostState)
                                        .posts
                                        .take(5)
                                        .toList(),
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: viewConstants.screensContentsPadding),
                      child: Text(
                        'Latest news',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  ]);
            }

            //default
            return Container(
              color: Colors.red,
            );
          },
        ),
      ),
    );
  }
}
