import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blocs.dart';
import '../../infrastructure/callback_functions.dart';
import './widgest.dart';
import '../../models/entities/entities.dart';

class PostItemInVerticalList extends StatelessWidget {
  final Post item;
  final double? borderRadious;
  final double? bottoMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? leftMargin;
  final Color? backgroundColor;
  final double? itemHeight;
  final CustomeValueSetterCallback<String, bool>? onPostBookmarkPressed;
  final CustomeValueSetterCallback<String, bool>? onPostBookMarkUpdated;

  static double _imageHeight = 0;
  static double _itemFinalHeight = 0;
  static double _textContainerLeftPadding = 0;
  static double itemDefaultHeight = 160;
  static const double textImageGap = 10.0;
  static const double textContainerLeftMargin = 15.0;
  static const double textContainerTopMargin = 12.0;
  static const double textContainerTopPadding = 15.0;
  static const double textContainerBottomPadding = 15.0;
  static const double imageBottomMargin = 15.0;

  PostItemInVerticalList({
    Key? key,
    required this.item,
    this.itemHeight,
    this.backgroundColor,
    this.onPostBookmarkPressed,
    this.onPostBookMarkUpdated,
    this.borderRadious,
    this.bottoMargin,
    this.topMargin,
    this.rightMargin,
    this.leftMargin,
  }) : super(key: key) {
    _itemFinalHeight = (itemHeight ?? itemDefaultHeight) - (bottoMargin ?? 0);
    _imageHeight = _itemFinalHeight - imageBottomMargin;
    _textContainerLeftPadding =
        _imageHeight - textContainerLeftMargin + textImageGap;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _itemFinalHeight,
      margin: EdgeInsets.fromLTRB(
        leftMargin ?? 0,
        topMargin ?? 0,
        rightMargin ?? 0,
        bottoMargin ?? 0,
      ),
      child: Stack(
        children: [
          //Text Container
          Container(
            height: itemHeight ?? itemDefaultHeight,
            margin: const EdgeInsets.fromLTRB(
              textContainerLeftMargin,
              textContainerTopMargin,
              0,
              0,
            ),
            child: Card(
              color: backgroundColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  _textContainerLeftPadding,
                  textContainerTopPadding,
                  0,
                  imageBottomMargin,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      SizedBox(
                        height: 22.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '15 minutes ago',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            PostBookmarkSection(
                              bookmarkedColor: Colors.orange,
                              unBookmarkedColor: context
                                      .read<ThemeCubit>()
                                      .state is ThemeLightModeState
                                  ? Colors.black54
                                  : Colors.white,
                              initialBookmarkStatus: item.isBookmarked,
                              postID: item.id,
                              onPostBookmarkUpdated:
                                  (postId, newBookmarkValue) =>
                                      onPostBookmarkUpdated(
                                          postId, newBookmarkValue),
                              onnBookmarkButtonPressed:
                                  (postId, newBookmarkValueToSet) =>
                                      onPostBookMarkPressed(
                                          postId, newBookmarkValueToSet),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          CustomeImage(
            borderRadious: borderRadious ?? 0,
            imageUrl: item.imagesUrls!.first,
            height: _imageHeight,
            width: _imageHeight,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  //we use this fuction to update post's bookmark value locally
  //if onPostBookMarkUpdated CallBack is provided the the post's bookmark will be updated in the parent widegt's post lists too.
  void onPostBookmarkUpdated(String postId, bool newBookmarkStatus) {
    //update local list
    item.isBookmarked = newBookmarkStatus;

    //update parent widget's list
    if (onPostBookMarkUpdated != null) {
      onPostBookMarkUpdated!(postId, newBookmarkStatus);
    }
  }

  // we use this function to do stuff when bookmark button is pressed
  //if onPostBookmarkPressed is provided , parent widget's demands as function will be call
  void onPostBookMarkPressed(String postId, bool newBookmarkStatusToSet) {
    //call parent widget's function
    if (onPostBookmarkPressed != null) {
      onPostBookmarkPressed!(postId, newBookmarkStatusToSet);
    }
  }
}
