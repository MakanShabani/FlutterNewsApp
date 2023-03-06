import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/features/posts/application/post_service.dart';
import 'package:responsive_admin_dashboard/src/features/posts/data/repositories/fake_posts_list_repository.dart';
import 'package:responsive_admin_dashboard/src/features/posts/presentation/post_detail/cubit/post_details_cubit.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key, required this.postId}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostDetailsCubit>(
          create: (context) => PostDetailsCubit(
            postService:
                PostService(postRepository: context.read<FakePostReposiory>()),
          )..fetchPostDetails(postId: postId),
        )
      ],
      child: Scaffold(
        body: SafeArea(
            child: CustomScrollView(
          slivers: [],
        )),
      ),
    );
  }
}
