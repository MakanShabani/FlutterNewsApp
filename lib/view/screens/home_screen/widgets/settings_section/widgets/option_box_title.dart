import 'package:flutter/material.dart';

class OptionBoxTitle extends StatelessWidget {
  const OptionBoxTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18.0),
    );
  }
}
