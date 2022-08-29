import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final Color? backgroundColor;
  final double? backgroundBoxWidth;
  final double? backgroundHeight;
  final bool hasBackground;

  const LoadingIndicator(
      {Key? key,
      this.size,
      this.color,
      this.backgroundColor,
      this.backgroundBoxWidth,
      this.backgroundHeight,
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
              child: SpinKitThreeBounce(
                size: size ?? 14.0,
                color: color ?? Theme.of(context).primaryColor,
              ),
            ),
          )
        : SpinKitThreeBounce(
            size: size ?? 14.0,
            color: color ?? Theme.of(context).primaryColor,
          );
  }
}
