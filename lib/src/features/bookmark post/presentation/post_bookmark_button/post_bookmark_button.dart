import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/utils/utils.dart';
import '../../../posts/domain/posts_models.dart';
import 'post_bookmark_cubit/post_bookmark_cubit.dart';

class PostBookmarkButton extends StatefulWidget {
  const PostBookmarkButton({
    Key? key,
    required this.initialBookmarkStatus,
    required this.post,
    this.bookmarkedColor,
    this.unBookmarkedColor,
    this.loadingSize,
    this.onPostBookmarkUpdated,
    this.onBookmarkPressed,
  }) : super(key: key);

  final Post post;
  final bool initialBookmarkStatus;
  final Color? bookmarkedColor;
  final Color? unBookmarkedColor;
  final double? loadingSize;

  final CustomeValueSetterCallback<Post, bool>? onPostBookmarkUpdated;
  final CustomeValueSetterCallback<Post, bool>? onBookmarkPressed;
  @override
  State<PostBookmarkButton> createState() => _PostBookmarkButtonState();
}

class _PostBookmarkButtonState extends State<PostBookmarkButton> {
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.initialBookmarkStatus;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBookmarkCubit, PostBookmarkState>(
      listenWhen: (previous, current) =>
          current is PostBookmarkUpdatedSuccessfullyState &&
          current.post.id == widget.post.id,
      listener: (context, state) => onPostBookmarkUpdated(
          (state as PostBookmarkUpdatedSuccessfullyState).newBookmarkValue),
      buildWhen: (previous, current) => whenRebuild(current),
      builder: (context, state) {
        return BookmarkButton(
          unBookmarkedColor: widget.unBookmarkedColor,
          bookmarkedColor: widget.bookmarkedColor,
          isLoading: isItemBookmarking(state),
          isBoolmarked: isBookmarked,
          onPressed: () => widget.onBookmarkPressed != null
              ? widget.onBookmarkPressed!(widget.post, !isBookmarked)
              : null,
        );
      },
    );
  }

  bool whenRebuild(PostBookmarkState state) {
    return (state is PostBookmarkUpdatingPostBookmarkState &&
            state.post.id == widget.post.id) ||
        (state is PostBookmarkUpdatedSuccessfullyState &&
            state.post.id == widget.post.id) ||
        (state is PostBookmarkUpdateHasErrorState &&
            state.post.id == widget.post.id);
  }

  bool isItemBookmarking(PostBookmarkState state) {
    return state.currentBookmarkingPosts.contains(widget.post.id);
  }

  void onPostBookmarkUpdated(bool newBookmarkStatus) {
    isBookmarked = newBookmarkStatus;

    widget.onPostBookmarkUpdated != null
        ? widget.onPostBookmarkUpdated!(widget.post, newBookmarkStatus)
        : null;
  }
}
