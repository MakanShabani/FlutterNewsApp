import 'package:flutter/material.dart';

import 'widgets/comment_widgets.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);
  final String postId;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [AppbarSection(title: 'Comments')],
      ),
    );
  }
}
