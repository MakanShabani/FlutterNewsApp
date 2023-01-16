import 'package:flutter/material.dart';

SnackBar appSnackBar(
    {required BuildContext context,
    required String message,
    bool? showCloseButton,
    bool? isTop,
    bool? isFloating,
    Color? bacgroundColor,
    Color? textColor,
    double? fontSize,
    VoidCallback? action,
    String? actionLabel}) {
  return SnackBar(
    backgroundColor: bacgroundColor,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    behavior: isFloating == null || isFloating
        ? SnackBarBehavior.floating
        : SnackBarBehavior.fixed,
    shape: isFloating == null || isFloating
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
            10.0,
          ))
        : null,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ),
        action != null
            ? TextButton(
                onPressed: action,
                child: Text(
                  '$actionLabel',
                  style: TextStyle(
                      fontSize: 16.0, color: Theme.of(context).primaryColor),
                ))
            : const SizedBox(
                width: 0,
              ),
      ],
    ),
    margin: isFloating == null || isFloating
        ? (isTop != null && isTop)
            ? EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 140,
                right: 10,
                left: 10)
            : null
        : null,
  );
}
