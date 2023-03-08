import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/utils/helper_methods.dart';

class TimeInText extends StatelessWidget {
  const TimeInText(
      {Key? key,
      required this.dateTime,
      this.textColor,
      this.textSize,
      this.customeStyle})
      : super(key: key);
  final DateTime dateTime;
  final Color? textColor;
  final double? textSize;
  final TextStyle? customeStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      HelperMethods.calculateTimeForRepresetingInUI(dateTime),
      style: customeStyle ??
          Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: textColor, fontSize: textSize) ??
          TextStyle(color: textColor, fontSize: textSize),
    );
  }
}
