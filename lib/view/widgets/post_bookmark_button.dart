import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostBookmarkButton extends StatelessWidget {
  final Color? bookmarkedColor;
  final Color? unBookmarkedColor;
  final bool isBookmarked;
  final bool isBookmarking;
  final double? loadingSize;
  final VoidCallback? onPressed;
  const PostBookmarkButton(
      {Key? key,
      required this.isBookmarking,
      required this.isBookmarked,
      this.bookmarkedColor,
      this.unBookmarkedColor,
      this.loadingSize,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isBookmarking
        ? SpinKitThreeBounce(
            size: loadingSize != null ? loadingSize! : 12.0,
            color: bookmarkedColor,
          )
        : IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            icon: Icon(
              Icons.bookmark,
              color: isBookmarked
                  ? bookmarkedColor ?? Colors.orange
                  : unBookmarkedColor ?? Colors.white,
              size: 16.0,
            ));
  }
}
