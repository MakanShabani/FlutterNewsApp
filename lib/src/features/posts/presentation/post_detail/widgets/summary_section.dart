import 'package:flutter/material.dart';

class SummarySection extends StatelessWidget {
  const SummarySection(
      {Key? key,
      required this.summary,
      this.leftMargin,
      this.rightMargin,
      this.topMargin,
      this.bottomMargin})
      : super(key: key);

  final String summary;
  final double? topMargin;
  final double? rightMargin;
  final double? bottomMargin;
  final double? leftMargin;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(
          leftMargin ?? 0,
          topMargin ?? 0,
          rightMargin ?? 0,
          bottomMargin ?? 0,
        ),
        child: Text(
          summary,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
