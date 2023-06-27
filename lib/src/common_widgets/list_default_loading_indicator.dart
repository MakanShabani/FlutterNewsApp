import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class ListDefaultLoadingIndicator extends StatelessWidget {
  const ListDefaultLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: 50.0,
        child: LoadingIndicator(
          hasBackground: false,
          size: 15.0,
        ));
  }
}
