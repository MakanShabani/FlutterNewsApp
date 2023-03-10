import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../router/route_names.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/constants.dart/constants.dart';
import '../../../authentication/presentation/blocs/authentication_cubit.dart';
import '../../../bookmark post/presentation/post_bookmark_button/post_bookmark_cubit/post_bookmark_cubit.dart';
import '../../application/post_service.dart';
import '../../data/repositories/posts_repositories.dart';
import 'cubit/post_details_cubit.dart';
import 'widgets/appbar_section.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key, required this.postId}) : super(key: key);

  final String postId;

  // we use this function to do stuff when bookmark button is pressed
  void onPostBookMarkPressed(BuildContext context) {
    if (context.read<AuthenticationCubit>().state is! AuthenticationLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
          context: context,
          message: error401SnackBar,
          action: () => Navigator.pushNamed(context, loginRoute),
          actionLabel: 'Sign In'));
      return;
    }

    //If bookmarking is locked -- we do nothing
    if (context.read<PostBookmarkCubit>().state.isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
        context: context,
        message: updatingBookmarksListSnackBar,
      ));
      return;
    }

    context.read<PostBookmarkCubit>().toggleBookmark(
        userToken: (context.read<AuthenticationCubit>().state
                as AuthenticationLoggedIn)
            .user
            .token,
        post: context.read<PostDetailsCubit>().state
                is PostDetailsFetchedSuccessfully
            ? (context.read<PostDetailsCubit>().state
                    as PostDetailsFetchedSuccessfully)
                .post
            : (context.read<PostDetailsCubit>().state
                    as PostDetailsBookmarkHasUpdated)
                .post,
        newBookmarkValueToSet: context
                .read<PostDetailsCubit>()
                .state is PostDetailsFetchedSuccessfully
            ? !(context.read<PostDetailsCubit>().state
                    as PostDetailsFetchedSuccessfully)
                .post
                .isBookmarked
            : !(context.read<PostDetailsCubit>().state
                    as PostDetailsBookmarkHasUpdated)
                .post
                .isBookmarked);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostDetailsCubit>(
          create: (context) => PostDetailsCubit(
            postService:
                PostService(postRepository: context.read<FakePostReposiory>()),
          )..fetchPostDetails(
              userToken: context.read<AuthenticationCubit>().state
                      is AuthenticationLoggedIn
                  ? (context.read<AuthenticationCubit>().state
                          as AuthenticationLoggedIn)
                      .user
                      .token
                  : null,
              postId: postId),
        )
      ],
      child: MultiBlocListener(
        listeners: [
          //Update Post's bookmark value
          BlocListener<PostBookmarkCubit, PostBookmarkState>(
            listenWhen: (previous, current) =>
                current is PostBookmarkUpdatedSuccessfullyState &&
                current.post.id == postId,
            listener: (context, state) => context
                .read<PostDetailsCubit>()
                .updateBookmarkValue(
                    (state as PostBookmarkUpdatedSuccessfullyState)
                        .newBookmarkValue),
          ),
        ],
        child: Scaffold(
          body: SafeArea(
              child: BlocBuilder<PostDetailsCubit, PostDetailsState>(
            buildWhen: (previous, current) =>
                current is! PostDetailsBookmarkHasUpdated,
            builder: (context, state) {
              if (state is PostDetailsFetchedSuccessfully) {
                return CustomScrollView(
                  slivers: [
                    AppbarSection(
                      postId: postId,
                      onBookmarkedPressed: () => onPostBookMarkPressed(context),
                    ),
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
      ),
    );
  }
}
