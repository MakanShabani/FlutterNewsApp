import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blocs.dart';
import '../../infrastructure/callback_functions.dart';
import './widgest.dart';
import '../../models/entities/entities.dart';

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
  final Color? backgroundColor;
  final CustomeValueSetterCallback<String, bool>? onPostBookmarkPressed;
  final CustomeValueSetterCallback<String, bool>? onPostBookMarkUpdated;

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

  const PostItemInVerticalList({
    Key? key,
    required this.item,
    this.backgroundColor,
    this.onPostBookmarkPressed,
    this.onPostBookMarkUpdated,
    this.borderRadious,
    this.leftPadding,
    this.topPadding,
    this.rightPadding,
    this.bottomPadding,
    this.bottoMargin,
    this.topMargin,
    this.rightMargin,
    this.leftMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              margin: const EdgeInsets.fromLTRB(
                  textSectionLeftMargin, textSectionTopMargin, 0, 0),
              child: Card(
                margin: const EdgeInsets.all(0),
                color: backgroundColor,
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
                                onPostBookmarkUpdated: (postId,
                                        newBookmarkValue) =>
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
              height: imageHeight,
              width: imageWidth,
              fit: BoxFit.fill,
            ),
          ],
        ),
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
