import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookmarkButton extends StatelessWidget {
  final Color? bookmarkedColor;
  final Color? unBookmarkedColor;
  final bool isBoolmarked;
  final bool isLoading;
  final double? loadingSize;

  final VoidCallback? onPressed;

  const BookmarkButton({
    Key? key,
    required this.isBoolmarked,
    required this.isLoading,
    this.bookmarkedColor,
    this.unBookmarkedColor,
    this.loadingSize,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SpinKitThreeBounce(
            size: loadingSize ?? 12.0,
            color: bookmarkedColor ?? Theme.of(context).primaryColor,
          )
        : IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            icon: Icon(
              Icons.bookmark,
              color: isBoolmarked
                  ? bookmarkedColor ?? Theme.of(context).primaryColor
                  : unBookmarkedColor ?? Colors.white,
              size: 16.0,
            ));
  }
}
