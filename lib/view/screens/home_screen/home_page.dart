import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.red),
      child: const Center(
          child: Text(
        'Hello World',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          decoration: TextDecoration.none,
        ),
      )),
    );
  }
}
