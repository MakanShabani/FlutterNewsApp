import 'package:flutter/material.dart';

import '../../text_constants.dart';

class NotSigenIn extends StatelessWidget {
  const NotSigenIn({
    Key? key,
    this.primaryColor,
    this.icon,
    this.iconColor,
    this.title,
    this.subtitle,
    this.actionText,
    this.onActionClicked,
  }) : super(key: key);
  final IconData? icon;
  final Color? primaryColor;
  final Color? iconColor;
  final String? title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/error_401.png',
          width: double.infinity,
          height: 300.0,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          title ?? notSignedInTitle,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            subtitle ?? notSignedInSubtitle,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const SizedBox(
          height: 60.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: ElevatedButton(
            onPressed: onActionClicked,
            child: Text(actionText ?? 'Sign In'),
          ),
        ),
      ],
    );
  }
}
