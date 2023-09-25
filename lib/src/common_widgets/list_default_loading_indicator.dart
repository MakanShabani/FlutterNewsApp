import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class ListDefaultLoadingIndicator extends StatelessWidget {
  const ListDefaultLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
          height: 10.0,
          child: LoadingIndicator(
            hasBackground: false,
            size: 12.0,
          )),
    );
  }
}
