import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/post_service.dart';
import '../../data/repositories/posts_repositories.dart';
import 'cubit/post_details_cubit.dart';
import 'widgets/appbar_section.dart';

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
        body: SafeArea(child: BlocBuilder<PostDetailsCubit, PostDetailsState>(
          builder: (context, state) {
            if (state is PostDetailsFetchedSuccessfully) {
              return const CustomScrollView(
                slivers: [
                  AppbarSection(),
                ],
              );
            } else if (state is PostDetailsFetchingHasError) {
              //Show error
              return Container();
            } else {
              //Show Loading
              return Container();
            }
          },
        )),
      ),
    );
  }
}
