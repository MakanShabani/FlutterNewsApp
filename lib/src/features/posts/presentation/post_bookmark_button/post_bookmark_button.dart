import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/utils/utils.dart';
import '../../../authentication/presentation/blocs/authentication_cubit.dart';
import '../../domain/posts_models.dart';
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
    this.onnBookmarkButtonPressed,
  }) : super(key: key);

  final Post post;
  final bool initialBookmarkStatus;
  final Color? bookmarkedColor;
  final Color? unBookmarkedColor;
  final double? loadingSize;

  final CustomeValueSetterCallback<Post, bool>? onPostBookmarkUpdated;
  final CustomeValueSetterCallback<Post, bool>? onnBookmarkButtonPressed;
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
          whenListenToPostBookCubitStates(widget.post.id, current),
      listener: (context, state) => onPostBookmarkUpdated(widget.post,
          (state as PostBookmarkUpdatedSuccessfullyState).newBookmarkValue),
      buildWhen: (previous, current) =>
          whenPostItemShouldWidgetRebuild(widget.post.id, current),
      builder: (context, state) {
        return BookmarkButton(
          unBookmarkedColor: widget.unBookmarkedColor,
          bookmarkedColor: widget.bookmarkedColor,
          isLoading: isItemBookmarking(widget.post.id, state),
          isBoolmarked: isBookmarked,
          onPressed: onBookmarkButtonPressed,
        );
      },
    );
  }

  bool whenListenToPostBookCubitStates(String postId, PostBookmarkState state) {
    return state is PostBookmarkUpdatedSuccessfullyState &&
        state.post.id == postId;
  }

  bool whenPostItemShouldWidgetRebuild(String postId, PostBookmarkState state) {
    return (state is PostBookmarkUpdatingPostBookmarkState &&
            state.post.id == postId) ||
        (state is PostBookmarkUpdatedSuccessfullyState &&
            state.post.id == postId) ||
        (state is PostBookmarkUpdateHasErrorState && state.post.id == postId);
  }

  bool isItemBookmarking(String postId, PostBookmarkState state) {
    return state is PostBookmarkUpdatingPostBookmarkState &&
            state.post.id == postId
        ? true
        : state is PostBookmarkUpdatedSuccessfullyState &&
                state.post.id == postId
            ? false
            : state is PostBookmarkUpdateHasErrorState &&
                    state.post.id == postId
                ? false
                : state.currentBookmarkingPosts.contains(postId);
  }

  void onPostBookmarkUpdated(Post postId, bool newBookmarkStatus) {
    isBookmarked = newBookmarkStatus;

    widget.onPostBookmarkUpdated != null
        ? widget.onPostBookmarkUpdated!(postId, newBookmarkStatus)
        : null;
  }

  void onBookmarkButtonPressed() {
    if (context.read<AuthenticationCubit>().state is! AuthenticationLoggedIn) {
      //TODO:
      //Show a snackbar or a dialog to notify user that they have to login first
      //in order to use this feature.
      return;
    }
    context.read<PostBookmarkCubit>().toggleBookmark(
          userToken: (context.read<AuthenticationCubit>().state
                  as AuthenticationLoggedIn)
              .user
              .token,
          post: widget.post,
          newBookmarkValue: !isBookmarked,
        );

    widget.onnBookmarkButtonPressed != null
        ? widget.onPostBookmarkUpdated!(widget.post, !isBookmarked)
        : null;
  }
}
