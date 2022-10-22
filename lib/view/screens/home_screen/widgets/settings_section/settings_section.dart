import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/view/screens/home_screen/widgets/settings_section/widgets/third_box.dart';

import './widgets/widgets.dart';
import '../../../../view_constants.dart' as view_constants;

class SettingsSection extends StatelessWidget {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Settings'),
          stretch: true,
          pinned: true,
          expandedHeight: 190.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
              child: UserInfoSummarySection(),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(
              height: view_constants.screenTopPadding,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: view_constants.screenHorizontalPadding),
              child: FirstBox(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: view_constants.screenHorizontalPadding),
              child: SecondBox(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: view_constants.screenHorizontalPadding),
              child: ThirdBox(),
            ),
            const SizedBox(
              height: view_constants.screenBottomPadding,
            ),
          ]),
        ),
      ],
    );
  }
}
