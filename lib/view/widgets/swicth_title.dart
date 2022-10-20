import 'package:flutter/material.dart';

class SwicthTitle extends StatelessWidget {
  const SwicthTitle({Key? key, required this.text, this.style, this.fontSize})
      : super(key: key);

  final String text;
  final TextStyle? style;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontSize: fontSize ?? 14.0) ??
          const TextStyle().copyWith(fontSize: fontSize ?? 14.0),
    );
  }
}
