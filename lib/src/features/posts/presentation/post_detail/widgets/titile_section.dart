import 'package:flutter/material.dart';

class TitileSection extends StatelessWidget {
  const TitileSection({
    Key? key,
    required this.title,
    this.bottomMargin,
    this.topMargin,
    this.leftMargin,
    this.rightMargin,
  }) : super(key: key);

  final String title;
  final double? topMargin;
  final double? bottomMargin;
  final double? leftMargin;
  final double? rightMargin;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(
          leftMargin ?? 0.0,
          topMargin ?? 0.0,
          rightMargin ?? 0.0,
          bottomMargin ?? 0.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 8.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          textWidthBasis: TextWidthBasis.parent,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
