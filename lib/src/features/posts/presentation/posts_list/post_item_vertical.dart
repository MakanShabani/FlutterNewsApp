import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/utils/utils.dart';
import '../../../bookmark post/presentation/post_bookmark_button/post_bookmark_button.dart';
import '../../../settings/presentation/blocs/theme_cubit/theme_cubit.dart';
import '../../domain/post.dart';

class PostItemInVerticalList extends StatelessWidget {
  final Post item;
  final double? borderRadious;
  final double? bottoMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? leftMargin;
  final Color? backgroundColor;
  final double? itemHeight;
  final CustomeValueSetterCallback<Post, bool>? onPostBookmarkPressed;
  final CustomeValueSetterCallback<Post, bool>? onPostBookMarkUpdated;
  final VoidCallback? onItemtapped;

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
    this.onItemtapped,
  }) : super(key: key) {
    _itemFinalHeight = (itemHeight ?? itemDefaultHeight) - (bottoMargin ?? 0);
    _imageHeight = _itemFinalHeight - imageBottomMargin;
    _textContainerLeftPadding =
        _imageHeight - textContainerLeftMargin + textImageGap;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemtapped,
      child: Container(
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
                              TimeInText(dateTime: item.createdAt),
                              PostBookmarkButton(
                                bookmarkedColor: Colors.orange,
                                unBookmarkedColor: context
                                        .read<ThemeCubit>()
                                        .state is ThemeLightModeState
                                    ? Colors.black54
                                    : Colors.white,
                                initialBookmarkStatus: item.isBookmarked,
                                post: item,
                                onPostBookmarkUpdated: (_, newBookmarkValue) =>
                                    _onPostBookmarkUpdated(newBookmarkValue),
                                onBookmarkPressed: (_, newBookmarkValueToSet) =>
                                    _onPostBookmarkPressed(
                                        newBookmarkValueToSet),
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
      ),
    );
  }

  //we use this fuction to update post's bookmark value locally
  //if onPostBookMarkUpdated CallBack is provided the the post's bookmark will be updated in the parent widegt's post lists too.
  void _onPostBookmarkUpdated(bool newBookmarkStatus) {
    //update local list
    item.isBookmarked = newBookmarkStatus;

    //update parent widget's list
    if (onPostBookMarkUpdated != null) {
      onPostBookMarkUpdated!(item, newBookmarkStatus);
    }
  }

  void _onPostBookmarkPressed(bool newBookmarkValueToSet) {
    onPostBookmarkPressed != null
        ? onPostBookmarkPressed!(item, newBookmarkValueToSet)
        : null;
  }
}
