import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';

class EmptyPostsList extends StatelessWidget {
  const EmptyPostsList({
    Key? key,
    this.primaryColor,
    this.title,
    this.subtitle,
    this.actionText,
    this.onActionClicked,
  }) : super(key: key);
  final Color? primaryColor;
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
          'assets/images/error_empty_list.png',
          width: double.infinity,
          height: 300.0,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          title ?? bookmarkListsEmpty,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            subtitle ?? bookmarkListsEmptySubtitle,
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
            child: Text(actionText ?? 'Refresh'),
          ),
        ),
      ],
    );
  }
}
