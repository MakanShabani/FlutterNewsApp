import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/blocs.dart';
import '../../../../models/entities/ViewModels/view_models.dart';
import '../../../../models/entities/entities.dart';
import '../../../../models/repositories/repo_fake_implementaion/fake_post_repository.dart';
import '../../../view_constants.dart' as view_constants;
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
              current is HomeSectionTabContentInitializingState ||
              current is HomeSectionTabContentInitializingSuccessfullState ||
              current is HomeSectionTabContentInitializingHasErrorState,
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
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15.0,
                      ),
                      widget.category == null
                          ? PostCarouselWithIndicator(
                              height: 200.0,
                              borderRadious:
                                  view_constants.circularBorderRadious,
                              cauroselLeftPadding: view_constants
                                  .screensContentsHorizontalPadding,
                              cauroselRightPadding: view_constants
                                  .screensContentsHorizontalPadding,
                              onTogglePostBookmark: (postId, isBookmarked) =>
                                  context.read<HomeSectionTabContentBloc>().add(
                                      HomeSectionTabContentUpdatePostBookmarkStatus(
                                          postId: postId,
                                          isBookmarked: isBookmarked)),
                              items: state.posts.take(5).toList())
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
                                style: TextStyle(fontSize: 18.0),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      SizedBox(
                        height: widget.category == null ? 15.0 : 0,
                      ),
                      const PostsListSection(),
                    ]),
              );
            }

            //show loading
            return const Center(
              child: Text(
                'loading',
              ),
            );
          },
        ),
      ),
    );
  }
}
