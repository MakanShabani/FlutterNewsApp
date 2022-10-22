import 'package:flutter/material.dart';

import '../../../../../widgets/widgest.dart';
import 'widgets.dart';

class ThirdBox extends StatelessWidget {
  const ThirdBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OptionBoxTitle(title: 'Privacy and Security'),
        const SizedBox(
          height: 12.0,
        ),
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const OptionTitle(text: 'Private Account'),
                trailing: SizedBox(
                  width: 40.0,
                  child: Switch(
                    value: false,
                    onChanged: (_) => {},
                  ),
                ),
              ),
              const ListTile(
                title: OptionTitle(text: 'Privacy and Security Help'),
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
