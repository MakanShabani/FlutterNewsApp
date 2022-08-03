import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/blocs.dart';
import '../../../widgets/widgest.dart';
import '../../../view_constants.dart' as view_constants;

class PostsListSection extends StatefulWidget {
  const PostsListSection({Key? key}) : super(key: key);

  @override
  State<PostsListSection> createState() => _PostsListSectionState();
}

class _PostsListSectionState extends State<PostsListSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeSectionTabContentBloc, HomeSectionTabContentState>(
      buildWhen: (previous, current) =>
          current is HomeSectionTabContentInitializingSuccessfullState &&
          current is HomeSectionTabContentFetchingMorePostSuccessfullState,
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state is HomeSectionTabContentInitializingSuccessfullState
              ? state.posts.length
              : (state as HomeSectionTabContentFetchingMorePostSuccessfullState)
                  .posts
                  .length,
          itemBuilder: (context, index) => PostItemInVerticalList(
              topPadding: 15,
              rightPadding: view_constants.screensContentsHorizontalPadding,
              bottoMargin: 10.0,
              leftPadding: view_constants.screensContentsHorizontalPadding,
              borderRadious: view_constants.circularBorderRadious,
              item: state is HomeSectionTabContentInitializingSuccessfullState
                  ? state.posts[index]
                  : (state
                          as HomeSectionTabContentFetchingMorePostSuccessfullState)
                      .posts[index]),
        );
      },
    );
  }
}
