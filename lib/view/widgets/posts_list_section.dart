import 'package:flutter/material.dart';
import '../../../../infrastructure/callback_functions.dart';
import '../../../../models/entities/entities.dart';
import './widgest.dart';
import '../view_constants.dart' as view_constants;

class PostsListSection extends StatefulWidget {
  const PostsListSection({
    Key? key,
    this.onPostBookmarkPressed,
    required this.items,
    this.onPostBookMarkUpdated,
  }) : super(key: key);

  final CustomeValueSetterCallback<String, bool>? onPostBookMarkUpdated;
  final CustomeValueSetterCallback<String, bool>? onPostBookmarkPressed;

  final List<Post> items;

  @override
  State<PostsListSection> createState() => _PostsListSectionState();
}

class _PostsListSectionState extends State<PostsListSection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) => PostItemInVerticalList(
        topPadding: 15,
        rightPadding: view_constants.screensContentsHorizontalPadding,
        bottoMargin: 10.0,
        leftPadding: view_constants.screensContentsHorizontalPadding,
        borderRadious: view_constants.circularBorderRadious,
        item: widget.items[index],
        onPostBookMarkUpdated: (postId, newBookmarkValue) =>
            onPostBookmarkUpdated(index, postId, newBookmarkValue),
        onPostBookmarkPressed: (postId, newBookmarkStatusToSet) =>
            onPostBookMarkPressed(postId, newBookmarkStatusToSet),
      ),
    );
  }

  //we use this fuction to update post's bookmark value locally
  //if onPostBookMarkUpdated CallBack is provided the the post's bookmark will be updated in the parent widegt's post lists too.
  void onPostBookmarkUpdated(int index, String postId, bool newBookmarkStatus) {
    widget.items[index].isBookmarked = newBookmarkStatus;

    //update parent widget's list
    if (widget.onPostBookMarkUpdated != null) {
      widget.onPostBookMarkUpdated!(postId, newBookmarkStatus);
    }
  }

  // we use this function to do stuff when bookmark button is pressed
  //if widget.onPostBookmarkPressed is provided , parent widget's demands as function will be call
  void onPostBookMarkPressed(String postId, bool newBookmarkStatusToSet) {
    widget.onPostBookmarkPressed != null
        ? () => widget.onPostBookmarkPressed!(postId, newBookmarkStatusToSet)
        : null;
  }
}