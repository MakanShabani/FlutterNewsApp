import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaspeaker_news_app/src/features/posts/domain/post.dart';
import 'package:shaspeaker_news_app/src/features/posts/presentation/post_detail/widgets/widgets.dart';
import 'package:shaspeaker_news_app/src/features/posts/presentation/posts_list/blocs/posts_list_blocs.dart';
import 'package:shaspeaker_news_app/src/router/app_router.dart';
import '../../../../router/route_names.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/constants.dart/constants.dart';
import '../../../authentication/presentation/blocs/authentication_cubit.dart';
import '../../../bookmark post/presentation/post_bookmark_button/post_bookmark_cubit/post_bookmark_cubit.dart';
import '../../application/post_service.dart';
import '../../data/repositories/posts_repositories.dart';
import 'cubit/post_details_cubit/post_details_cubit.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({
    Key? key,
    required this.postId,
    required this.categoryId,
  }) : super(key: key);

  final String postId;
  final String categoryId;

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
        action: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        actionLabel: 'OK',
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
                  postService: PostService(
                      postRepository: context.read<FakePostReposiory>()),
                )..fetchPostDetails(
                    userToken: context.read<AuthenticationCubit>().state
                            is AuthenticationLoggedIn
                        ? (context.read<AuthenticationCubit>().state
                                as AuthenticationLoggedIn)
                            .user
                            .token
                        : null,
                    postId: postId)),
        BlocProvider<PostsListCubit>(
          create: (context) => PostsListCubit(
              postsListService: PostService(
                  postRepository: context.read<FakePostReposiory>()),
              haowManyPostFetchEachTime: 10)
            ..fetch(
                context.read<AuthenticationCubit>().state
                        is AuthenticationLoggedIn
                    ? (context.read<AuthenticationCubit>().state
                            as AuthenticationLoggedIn)
                        .user
                        .token
                    : null,
                categoryId,
                false),
        ),
        BlocProvider<ListNotifireCubit<Post>>(
            create: (context) => ListNotifireCubit())
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
                    //Appbar Section
                    AppbarSection(
                      postId: postId,
                      onBookmarkedPressed: () => onPostBookMarkPressed(context),
                    ),

                    //Title Section
                    TitileSection(
                      leftMargin: screenHorizontalPadding,
                      topMargin: 20.0,
                      rightMargin: screenHorizontalPadding,
                      title: state.post.title,
                    ),

                    //Summary Section
                    SummarySection(
                      summary: state.post.summary,
                      leftMargin: screenHorizontalPadding,
                      rightMargin: screenHorizontalPadding,
                      topMargin: 20.0,
                    ),

                    //Content Section
                    ContentSection(
                      content: state.post.content,
                      leftMargin: screenHorizontalPadding,
                      rightMargin: screenHorizontalPadding,
                      topMargin: 20.0,
                    ),

                    //See Comments button
                    SeeCommentsButton(
                      text: 'See Comments (${state.post.commentsCount})',
                      leftMargin: screenHorizontalPadding,
                      rightMargin: screenHorizontalPadding,
                      topMargin: 20.0,
                      onClicked: () => Navigator.pushNamed(
                          context, commentsRoute,
                          arguments:
                              AppRouter.createCommentsRouteArguments(postId)),
                    ),

                    //Related Posts section
                    const RelatedPostsSection(
                      leftMargin: screenHorizontalPadding,
                      rightMargin: screenHorizontalPadding,
                      topMargin: 40.0,
                    )
                  ],
                );
              } else if (state is PostDetailsFetchingHasError) {
                //Show error
                return ErrorInternal(
                  onActionClicked: () => context
                      .read<PostDetailsCubit>()
                      .fetchPostDetails(postId: postId),
                );
              } else {
                //Show Loading
                return const Center(
                  child: LoadingIndicator(hasBackground: false),
                );
              }
            },
          )),
        ),
      ),
    );
  }
}
