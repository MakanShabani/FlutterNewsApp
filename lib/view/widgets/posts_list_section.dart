import 'package:flutter/material.dart';
import '../../../../infrastructure/callback_functions.dart';
import '../../../../models/entities/entities.dart';
import './widgest.dart';
import '../view_constants.dart' as view_constants;

class PostsListSection extends StatelessWidget {
  const PostsListSection({
    Key? key,
    required this.items,
    this.itemHeight,
    this.spaceBetweenItems,
    this.onPostBookmarkPressed,
    this.onPostBookMarkUpdated,
    this.itemLeftMargin,
    this.itemRightMargin,
    this.itemTopMargin,
  }) : super(key: key);

  final CustomeValueSetterCallback<String, bool>? onPostBookMarkUpdated;
  final CustomeValueSetterCallback<String, bool>? onPostBookmarkPressed;

  final double? itemHeight;
  final double? spaceBetweenItems;
  final double? itemLeftMargin;
  final double? itemRightMargin;
  final double? itemTopMargin;
  final List<Post> items;

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: itemHeight ?? 160.0,
      delegate: SliverChildBuilderDelegate(
          childCount: items.length,
          (context, index) => PostItemInVerticalList(
                itemHeight: itemHeight ?? 160,
                rightMargin:
                    itemRightMargin ?? view_constants.screenHorizontalPadding,
                bottoMargin: spaceBetweenItems ?? 20.0,
                leftMargin:
                    itemLeftMargin ?? view_constants.screenHorizontalPadding,
                borderRadious: view_constants.circularBorderRadious,
                item: items[index],
                onPostBookMarkUpdated: (postId, newBookmarkValue) =>
                    onPostBookmarkUpdated(index, postId, newBookmarkValue),
                onPostBookmarkPressed: (postId, newBookmarkStatusToSet) =>
                    onPostBookMarkPressed(postId, newBookmarkStatusToSet),
              )),
    );
  }

  //we use this fuction to update post's bookmark value locally
  //if onPostBookMarkUpdated CallBack is provided the the post's bookmark will be updated in the parent widegt's post lists too.
  void onPostBookmarkUpdated(int index, String postId, bool newBookmarkStatus) {
    items[index].isBookmarked = newBookmarkStatus;

    //update parent widget's list
    if (onPostBookMarkUpdated != null) {
      onPostBookMarkUpdated!(postId, newBookmarkStatus);
    }
  }

  // we use this function to do stuff when bookmark button is pressed
  //if widget.onPostBookmarkPressed is provided , parent widget's demands as function will be call
  void onPostBookMarkPressed(String postId, bool newBookmarkStatusToSet) {
    onPostBookmarkPressed != null
        ? () => onPostBookmarkPressed!(postId, newBookmarkStatusToSet)
        : null;
  }
}
