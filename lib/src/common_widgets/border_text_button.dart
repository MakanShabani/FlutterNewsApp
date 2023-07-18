import 'package:flutter/material.dart';

class BorderTextButton extends StatelessWidget {
  const BorderTextButton(
      {Key? key,
      this.overallBorder,
      this.leftBorder,
      this.topBorder,
      this.rightBorder,
      this.bottomBorder,
      required this.buttonText,
      this.textSize,
      this.textColor,
      this.onClicked})
      : super(key: key);
  final BorderSide? overallBorder;
  final BorderSide? leftBorder;
  final BorderSide? topBorder;
  final BorderSide? rightBorder;
  final BorderSide? bottomBorder;
  final String buttonText;
  final double? textSize;
  final Color? textColor;
  final VoidCallback? onClicked;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: overallBorder != null
              ? Border.fromBorderSide(overallBorder!)
              : Border(
                  left: leftBorder ?? BorderSide.none,
                  top: topBorder ?? BorderSide.none,
                  right: rightBorder ?? BorderSide.none,
                  bottom: bottomBorder ?? BorderSide.none,
                )),
      child: TextButton(
          onPressed: onClicked,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
            ),
          )),
    );
  }
}
