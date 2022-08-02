import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../infrastructure/callback_functions.dart';
import './widgest.dart';
import '../../bloc/blocs.dart';
import '../../models/entities/entities.dart';
import '../../models/repositories/repo_fake_implementaion/fake_post_repository.dart';

class PostItemInVerticalList extends StatelessWidget {
  final Post item;
  final double borderRadious;
  final double leftPadding;
  final double topPadding;
  final double rightPadding;
  final double bottomPadding;
  final double bottoMargin;

  final CustomeValueSetterCallback<String, bool>? onTogglePostBookmark;

  const PostItemInVerticalList(
      {Key? key,
      required this.item,
      required this.borderRadious,
      required this.leftPadding,
      required this.topPadding,
      required this.rightPadding,
      required this.bottomPadding,
      required this.bottoMargin,
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
            margin: EdgeInsets.fromLTRB(0, 0, 0, bottoMargin),
            child: Padding(
              padding: EdgeInsets.fromLTRB(leftPadding, 0, rightPadding, 0),
              child: SizedBox(
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomeImage(
                      borderRadious: borderRadious,
                      imageUrl: item.imagesUrls!.first,
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
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
                                          fontSize: 12.0,
                                          color: Colors.black54),
                                    ),
                                    BlocBuilder<PostBloc, PostState>(
                                      buildWhen: (previous, current) =>
                                          current
                                              is PostTogglingBookmarkState ||
                                          current
                                              is PostTogglingPostBookmarkSuccessfullState ||
                                          current
                                              is PostTogglingPostBookmarkHasErrorState,
                                      builder: (context, state) {
                                        if (state
                                            is! PostTogglingBookmarkState) {
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
                    )
                  ],
                ),
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
