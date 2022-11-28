import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final Color? backgroundColor;
  final double? backgroundBoxWidth;
  final double? backgroundHeight;
  final bool hasBackground;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;

  const LoadingIndicator(
      {Key? key,
      this.size,
      this.color,
      this.backgroundColor,
      this.backgroundBoxWidth,
      this.backgroundHeight,
      this.bottomPadding,
      this.leftPadding,
      this.rightPadding,
      this.topPadding,
      required this.hasBackground})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasBackground
        ? Container(
            width: backgroundBoxWidth,
            height: backgroundHeight,
            color: backgroundColor,
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(leftPadding ?? 0, topPadding ?? 0,
                    rightPadding ?? 0, bottomPadding ?? 0),
                child: SpinKitThreeBounce(
                  size: size ?? 12.0,
                  color: color ?? Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.fromLTRB(leftPadding ?? 0, topPadding ?? 0,
                rightPadding ?? 0, bottomPadding ?? 0),
            child: SpinKitThreeBounce(
              size: size ?? 12.0,
              color: color ?? Theme.of(context).primaryColor,
            ),
          );
  }
}
