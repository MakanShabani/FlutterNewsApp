import 'package:flutter/material.dart';

import '../../../../common_widgets/common_widgest.dart';
import 'widgets.dart';

class SecondBox extends StatelessWidget {
  const SecondBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OptionBoxTitle(title: 'Account'),
        SizedBox(
          height: 12.0,
        ),
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: OptionTitle(text: 'Edit Account'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                ),
              ),
              ListTile(
                title: OptionTitle(text: 'Change Password'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                ),
              ),
              ListTile(
                title: OptionTitle(text: 'Language'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
