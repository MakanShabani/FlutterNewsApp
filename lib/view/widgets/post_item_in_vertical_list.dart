import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../infrastructure/callback_functions.dart';
import './widgest.dart';
import '../../bloc/blocs.dart';
import '../../models/entities/entities.dart';
import '../../models/repositories/repo_fake_implementaion/fake_post_repository.dart';

class PostItemInVerticalList extends StatelessWidget {
  final Post item;
  final double? borderRadious;
  final double? leftPadding;
  final double? topPadding;
  final double? rightPadding;
  final double? bottomPadding;
  final double? bottoMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? leftMargin;

  final CustomeValueSetterCallback<String, bool>? onTogglePostBookmark;

  static const double imageHeight = 120.0;
  static const double imageWidth = 120.0;
  static const double textSectionHeight = 120;
  static const double textSectionLeftMargin = 15.0;
  static const double imageTextSectionGap = 10.0;
  static const double textLeftSectionPadding =
      imageHeight - textSectionLeftMargin + imageTextSectionGap;
  static const double textSectionTopMargin = 12.0;
  static const double textSectionTopPadding = 15.0;
  static const double textSectionBottomPadding = textSectionTopMargin;

  const PostItemInVerticalList(
      {Key? key,
      required this.item,
      this.borderRadious,
      this.leftPadding,
      this.topPadding,
      this.rightPadding,
      this.bottomPadding,
      this.bottoMargin,
      this.topMargin,
      this.rightMargin,
      this.leftMargin,
      this.onTogglePostBookmark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FakePostReposiory(),
      child: BlocProvider(
        create: (context) => PostBloc(
          postRepository: context.read<FakePostReposiory>(),
        ),
        child: BlocListener<PostBloc, PostState>(
          listenWhen: (previous, current) =>
              current is PostTogglingPostBookmarkSuccessfullState,
          listener: (context, state) => togglePostBookmarkStatus(
              (state as PostTogglingPostBookmarkSuccessfullState).postId),
          child: Container(
            margin: EdgeInsets.fromLTRB(
              leftMargin ?? 0,
              topMargin ?? 0,
              rightMargin ?? 0,
              bottoMargin ?? 0,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                leftPadding ?? 0,
                topPadding ?? 0,
                rightPadding ?? 0,
                bottomPadding ?? 0,
              ),
              child: Stack(
                children: [
                  Container(
                    height: textSectionHeight,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(borderRadious ?? 0)),
                    margin: const EdgeInsets.fromLTRB(
                        textSectionLeftMargin, textSectionTopMargin, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        textLeftSectionPadding,
                        textSectionTopPadding,
                        0,
                        textSectionBottomPadding,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title),
                            SizedBox(
                              height: 22.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '15 minutes ago',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black54),
                                  ),
                                  BlocBuilder<PostBloc, PostState>(
                                    buildWhen: (previous, current) =>
                                        current is PostTogglingBookmarkState ||
                                        current
                                            is PostTogglingPostBookmarkSuccessfullState ||
                                        current
                                            is PostTogglingPostBookmarkHasErrorState,
                                    builder: (context, state) {
                                      if (state is! PostTogglingBookmarkState) {
                                        return PostBookmarkButton(
                                            onPressed: () => context
                                                .read<PostBloc>()
                                                .add(PostToggleBookmarkEvent(
                                                    postId: item.id)),
                                            unBookmarkedColor: Colors.black54,
                                            bookmarkedColor: Colors.orange,
                                            isBookmarking: false,
                                            isBookmarked: item.isBookmarked);
                                      }

                                      //PostTogglingBookmarkState
                                      return PostBookmarkButton(
                                          onPressed: () => context
                                              .read<PostBloc>()
                                              .add(PostToggleBookmarkEvent(
                                                  postId: item.id)),
                                          unBookmarkedColor: Colors.black54,
                                          bookmarkedColor: Colors.orange,
                                          isBookmarking: true,
                                          isBookmarked: item.isBookmarked);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                  CustomeImage(
                    borderRadious: borderRadious ?? 0,
                    imageUrl: item.imagesUrls!.first,
                    height: imageHeight,
                    width: imageWidth,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void togglePostBookmarkStatus(String postId) {
    item.isBookmarked ? item.isBookmarked = false : item.isBookmarked = true;

    onTogglePostBookmark != null
        ? onTogglePostBookmark!(
            postId,
            item.isBookmarked,
          )
        : null;
  }
}
