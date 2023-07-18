import 'package:flutter/material.dart';
import '../../../../../common_widgets/common_widgest.dart';

class SeeCommentsButton extends StatelessWidget {
  const SeeCommentsButton(
      {Key? key,
      required this.text,
      this.onClicked,
      this.leftMargin,
      this.topMargin,
      this.rightMargin,
      this.bottomMargin})
      : super(key: key);

  final String text;
  final VoidCallback? onClicked;
  final double? leftMargin;
  final double? topMargin;
  final double? rightMargin;
  final double? bottomMargin;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(leftMargin ?? 0, topMargin ?? 0,
            rightMargin ?? 0, bottomMargin ?? 0),
        child: CustomeButton(
          onPressed: onClicked,
          text: text,
        ),
      ),
    );
  }
}
