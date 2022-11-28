import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';
import '../../../../infrastructure/utils/utils.dart';
import '../../domain/posts_models.dart';
import 'blocs/posts_list_blocs.dart';
import 'post_item_vertical.dart';

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
  State<PostsListSection> createState() => PostsListSectionState();
}

class PostsListSectionState extends State<PostsListSection> {
  /// Will used to access the Animated list
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  /// This holds the items
  late List<Post> _items;

  @override
  void initState() {
    super.initState();

    _items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostsListNotifireCubit, PostsListNotifireCubitState>(
      listener: (context, state) {
        if (state is PostsListNotifireCubitInsertPosts) {
          _insertMultipleItems(state.posts);
        }
      },
      child: SliverAnimatedList(
        key: _listKey,
        initialItemCount: widget.items.length,
        itemBuilder: (context, index, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: const Offset(0, 0),
          ).animate(animation),
          child: PostItemInVerticalList(
            itemHeight: widget.itemHeight ?? 160,
            rightMargin: widget.itemRightMargin ?? screenHorizontalPadding,
            bottoMargin: widget.spaceBetweenItems ?? 20.0,
            leftMargin: widget.itemLeftMargin ?? screenHorizontalPadding,
            borderRadious: circularBorderRadious,
            item: _items[index],
            onPostBookMarkUpdated: (postId, newBookmarkValue) =>
                onPostBookmarkUpdated(index, postId, newBookmarkValue),
            onPostBookmarkPressed: (postId, newBookmarkStatusToSet) =>
                onPostBookMarkPressed(postId, newBookmarkStatusToSet),
          ),
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

  void _insertSingleItem(Post item) {
    int insertIndex = _items.length;
    _items.insert(insertIndex, item);
    _listKey.currentState
        ?.insertItem(insertIndex, duration: const Duration(milliseconds: 500));
  }

  void _insertMultipleItems(List<Post> newItems) {
    int insertIndex = _items.length;
    _items = _items + newItems;
    // This is a bit of a hack because currentState doesn't have
    // an insertAll() method.
    for (int offset = 0; offset < newItems.length; offset++) {
      _listKey.currentState?.insertItem(insertIndex + offset,
          duration: const Duration(seconds: 1));
    }
  }

  void insertItem(List<Post> newPosts) {
    int insertIndex = _items.length - 1;
    for (int offset = 0; offset < _items.length + newPosts.length; offset++) {
      _listKey.currentState?.insertItem(insertIndex + offset,
          duration: const Duration(milliseconds: 500));
      _items = _items + newPosts;
    }
  }

  void removeItem(index) {
    _listKey.currentState?.removeItem(
        index,
        (_, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: const Offset(0, 0),
              ).animate(animation),
              child: PostItemInVerticalList(
                itemHeight: widget.itemHeight ?? 160,
                rightMargin: widget.itemRightMargin ?? screenHorizontalPadding,
                bottoMargin: widget.spaceBetweenItems ?? 20.0,
                leftMargin: widget.itemLeftMargin ?? screenHorizontalPadding,
                borderRadious: circularBorderRadious,
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
