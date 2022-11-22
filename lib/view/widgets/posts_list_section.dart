import 'package:flutter/material.dart';
import '../../../../infrastructure/callback_functions.dart';
import '../../../../models/entities/entities.dart';
import './widgest.dart';
import '../view_constants.dart' as view_constants;

class PostsListSection extends StatefulWidget {
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
  State<PostsListSection> createState() => _PostsListSectionState();
}

class _PostsListSectionState extends State<PostsListSection> {
  /// Will used to access the Animated list
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  /// This holds the items
  List<Post> _items = [];

  @override
  void initState() {
    super.initState();

    _items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: listKey,
      initialItemCount: widget.items.length,
      itemBuilder: (context, index, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: PostItemInVerticalList(
          itemHeight: widget.itemHeight ?? 160,
          rightMargin:
              widget.itemRightMargin ?? view_constants.screenHorizontalPadding,
          bottoMargin: widget.spaceBetweenItems ?? 20.0,
          leftMargin:
              widget.itemLeftMargin ?? view_constants.screenHorizontalPadding,
          borderRadious: view_constants.circularBorderRadious,
          item: widget.items[index],
          onPostBookMarkUpdated: (postId, newBookmarkValue) =>
              onPostBookmarkUpdated(index, postId, newBookmarkValue),
          onPostBookmarkPressed: (postId, newBookmarkStatusToSet) =>
              onPostBookMarkPressed(postId, newBookmarkStatusToSet),
        ),
      ),
    );
  }

  //we use this fuction to update post's bookmark value locally
  void onPostBookmarkUpdated(int index, String postId, bool newBookmarkStatus) {
    widget.items[index].isBookmarked = newBookmarkStatus;

    //update parent widget's list
    if (widget.onPostBookMarkUpdated != null) {
      widget.onPostBookMarkUpdated!(postId, newBookmarkStatus);
    }
  }

  // we use this function to do stuff when bookmark button is pressed
  void onPostBookMarkPressed(String postId, bool newBookmarkStatusToSet) {
    widget.onPostBookmarkPressed != null
        ? () => widget.onPostBookmarkPressed!(postId, newBookmarkStatusToSet)
        : null;
  }

  void insertItem(Post post) {
    listKey.currentState?.insertItem(_items.length - 1,
        duration: const Duration(milliseconds: 500));
    _items = [post, ..._items];
  }

  void removeItem(index) {
    listKey.currentState?.removeItem(
        index,
        (_, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: const Offset(0, 0),
              ).animate(animation),
              child: PostItemInVerticalList(
                itemHeight: widget.itemHeight ?? 160,
                rightMargin: widget.itemRightMargin ??
                    view_constants.screenHorizontalPadding,
                bottoMargin: widget.spaceBetweenItems ?? 20.0,
                leftMargin: widget.itemLeftMargin ??
                    view_constants.screenHorizontalPadding,
                borderRadious: view_constants.circularBorderRadious,
                item: _items[index],
                onPostBookMarkUpdated: (postId, newBookmarkValue) =>
                    onPostBookmarkUpdated(index, postId, newBookmarkValue),
                onPostBookmarkPressed: (postId, newBookmarkStatusToSet) =>
                    onPostBookMarkPressed(postId, newBookmarkStatusToSet),
              ),
            ),
        duration: const Duration(milliseconds: 500));
    _items.removeAt(index);
  }
}
