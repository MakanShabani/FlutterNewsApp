import 'package:flutter/material.dart';

import './widgets/widgets.dart';
import '../../../../view_constants.dart' as view_constants;

class SettingsSection extends StatelessWidget {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Settings'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: TextButton(
              onPressed: () => {},
              child: const Text('Sign In'),
            ),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildListDelegate([
            const Padding(
              padding: EdgeInsets.all(view_constants.horizontalPadding),
              child: FirstBox(),
            )
          ]),
          itemExtent: 140.0,
        )
      ],
    );
  }
}
