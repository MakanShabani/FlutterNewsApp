import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaspeaker_news_app/src/features/posts/domain/posts_models.dart';
import 'package:shaspeaker_news_app/src/router/app_router.dart';
import 'package:shaspeaker_news_app/src/router/route_names.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../../common_widgets/common_widgest.dart';
import '../../../../../infrastructure/constants.dart/text_constants.dart';
import '../../../../../infrastructure/constants.dart/view_constants.dart';
import '../../../../authentication/presentation/blocs/authentication_cubit.dart';
import '../../../../bookmark post/presentation/post_bookmark_button/post_bookmark_cubit/post_bookmark_cubit.dart';
import '../../posts_list/blocs/posts_list_cubit/posts_list_cubit.dart';

class RelatedPostsSection extends StatelessWidget {
  const RelatedPostsSection(
      {Key? key,
      this.leftMargin,
      this.topMargin,
      this.rightMargin,
      this.bottomtMargin})
      : super(key: key);
  final double? leftMargin;
  final double? topMargin;
  final double? rightMargin;
  final double? bottomtMargin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsListCubit, PostsListCubitState>(
      builder: (context, state) {
        if (state is PostsListCubitFetchedSuccessfully) {
          return MultiSliver(children: [
            SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.fromLTRB(
                      leftMargin ?? 0, topMargin ?? 0, rightMargin ?? 0, 20.0),
                  child: Text(
                    'Related Posts',
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
            ),
            SliverInfiniteAnimatedList<Post>(
              items: state.fetchedPosts,
              firstItemWithoutTopPadding: true,
              lastItemWithoutBottomPadding: true,
              itemLayoutBuilder: (item, index) => PostItemInVerticalList(
                itemHeight: 160,
                rightMargin: screenHorizontalPadding,
                bottoMargin: 20.0,
                leftMargin: screenHorizontalPadding,
                borderRadious: circularBorderRadious,
                item: item,
                onItemtapped: () => Navigator.pushNamed(context, postRoute,
                    arguments: AppRouter.createPostRouteArguments(
                        item.id, item.category.id)),
                onPostBookmarkPressed: (post, newBookmarkStatus) =>
                    onPostBookMarkPressed(context, post, newBookmarkStatus),
                onPostBookMarkUpdated: (post, newBookmarkStatus) =>
                    onPostBookmarkUpdated(context, post, newBookmarkStatus),
              ),
              loadingLayout: const SizedBox(
                height: 50.0,
                child: LoadingIndicator(
                  hasBackground: true,
                  backgroundHeight: 20.0,
                ),
              ),
            ),
          ]);
        } else if (state is PostsListCubitFetching) {
          //shod loading
          return const SliverToBoxAdapter(
              child: LoadingIndicator(hasBackground: false));
        }

        //if we have error or the state == initial we show nothing
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 0,
          ),
        );
      },
    );
  }

  //---------------functions----------------------------

  // we use this function to do stuff when bookmark button is pressed
  void onPostBookMarkPressed(
      BuildContext context, Post post, bool newBookmarkStatus) {
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
        post: post,
        newBookmarkValueToSet: newBookmarkStatus);
  }

  void onPostBookmarkUpdated(
      BuildContext context, Post post, bool newBookmarkStatus) {
    context.read<PostsListCubit>().updatePostsBookmarkStatus(
        postId: post.id, newBookmarkStatus: newBookmarkStatus);
  }
}
