import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class ListDefaultLoadingIndicator extends StatelessWidget {
  const ListDefaultLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: const SizedBox(
          height: 10.0,
          child: LoadingIndicator(
            hasBackground: false,
            size: 12.0,
          )),
    );
  }
}
