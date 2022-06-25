import 'package:flutter/material.dart';

SnackBar appSnackBar(
    {required String message,
    bool? showCloseButton,
    bool? isTop,
    double? deviceHeight,
    required bool isFloating,
    Color? bacgroundColor,
    Color? textColor,
    double? fontSize}) {
  return SnackBar(
    backgroundColor: bacgroundColor,
    behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    shape: isFloating
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
            10.0,
          ))
        : null,
    content: Text(
      message,
      style: TextStyle(color: textColor, fontSize: fontSize),
    ),
    margin: isFloating
        ? (isTop != null && isTop && deviceHeight != null && deviceHeight > 0)
            ? EdgeInsets.only(bottom: deviceHeight - 90, right: 20, left: 20)
            : null
        : null,
  );
}
