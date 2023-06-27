import 'package:flutter/material.dart';

class DotIcon extends StatelessWidget {
  const DotIcon({Key? key, required this.color, this.size}) : super(key: key);
  final Color color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 2.0,
      height: size ?? 2.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
