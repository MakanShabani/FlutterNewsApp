import 'package:flutter/material.dart';

class ContentSection extends StatelessWidget {
  const ContentSection({
    Key? key,
    required this.content,
    this.leftMargin,
    this.topMargin,
    this.rightMargin,
    this.bottomtMargin,
  }) : super(key: key);

  final String content;
  final double? leftMargin;
  final double? topMargin;
  final double? rightMargin;
  final double? bottomtMargin;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      margin: EdgeInsets.fromLTRB(
        leftMargin ?? 0,
        topMargin ?? 0,
        rightMargin ?? 0,
        bottomtMargin ?? 0,
      ),
      child: Text(
        content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ));
  }
}
