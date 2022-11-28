import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/utils/utils.dart';
import '../../../authentication/presentation/blocs/authentication_cubit.dart';
import 'post_bookmark_cubit/post_bookmark_cubit.dart';

class PostBookmarkButton extends StatefulWidget {
  const PostBookmarkButton({
    Key? key,
    required this.initialBookmarkStatus,
    required this.postID,
    this.bookmarkedColor,
    this.unBookmarkedColor,
    this.loadingSize,
    this.onPostBookmarkUpdated,
    this.onnBookmarkButtonPressed,
  }) : super(key: key);

  final String postID;
  final bool initialBookmarkStatus;
  final Color? bookmarkedColor;
  final Color? unBookmarkedColor;
  final double? loadingSize;

  final CustomeValueSetterCallback<String, bool>? onPostBookmarkUpdated;
  final CustomeValueSetterCallback<String, bool>? onnBookmarkButtonPressed;
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
          whenListenToPostBookCubitStates(widget.postID, current),
      listener: (context, state) => onPostBookmarkUpdated(widget.postID,
          (state as PostBookmarkUpdatedSuccessfullyState).newBookmarkValue),
      buildWhen: (previous, current) =>
          whenPostItemShouldWidgetRebuild(widget.postID, current),
      builder: (context, state) {
        return BookmarkButton(
          unBookmarkedColor: widget.unBookmarkedColor,
          bookmarkedColor: widget.bookmarkedColor,
          isLoading: isItemBookmarking(widget.postID, state),
          isBoolmarked: isBookmarked,
          onPressed: onBookmarkButtonPressed,
        );
      },
    );
  }

  bool whenListenToPostBookCubitStates(String postId, PostBookmarkState state) {
    return state is PostBookmarkUpdatedSuccessfullyState &&
        state.postId == postId;
  }

  bool whenPostItemShouldWidgetRebuild(String postId, PostBookmarkState state) {
    return (state is PostBookmarkUpdatingPostBookmarkState &&
            state.postId == postId) ||
        (state is PostBookmarkUpdatedSuccessfullyState &&
            state.postId == postId) ||
        (state is PostBookmarkUpdateHasErrorState && state.postId == postId);
  }

  bool isItemBookmarking(String postId, PostBookmarkState state) {
    return state is PostBookmarkUpdatingPostBookmarkState &&
            state.postId == postId
        ? true
        : state is PostBookmarkUpdatedSuccessfullyState &&
                state.postId == postId
            ? false
            : state is PostBookmarkUpdateHasErrorState && state.postId == postId
                ? false
                : state.currentBookmarkingPosts.contains(postId);
  }

  void onPostBookmarkUpdated(String postId, bool newBookmarkStatus) {
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
          postId: widget.postID,
          newBookmarkValue: !isBookmarked,
        );

    widget.onnBookmarkButtonPressed != null
        ? widget.onPostBookmarkUpdated!(widget.postID, !isBookmarked)
        : null;
  }
}
