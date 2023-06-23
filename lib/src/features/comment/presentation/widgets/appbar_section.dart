import 'package:flutter/material.dart';

import '../../../../style.dart';

class AppbarSection extends StatelessWidget {
  const AppbarSection({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title == null ? null : const Text('Comments'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        iconSize: ThemeStyle.appbarbuttonIconsSize,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
