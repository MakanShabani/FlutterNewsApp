import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../domain/comment.dart';
import '../blocs/cubits.dart';
import 'comment_widgets.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsFetchingCubit, CommentsFetchingState>(
      //1. First Fetch -->> Show the list with fetched items
      //2. state is CommentsListIsEmpty --> Show the list empty is empty widget
      //3. we are in Fetching mode and we don't have any comments in our list yet --> show the loading indcicator in the center of the page
      buildWhen: (previous, current) =>
          (current is CommentsFetchingFetchedState &&
              previous.comments.isEmpty) ||
          current is CommentsFetchingListIsEmpty ||
          (current is CommentsFetchingFetchingState &&
              current.comments.isEmpty),
      builder: (context, state) {
        if (state is CommentsFetchingFetchedState) {
          //Build once only after First Fetch successfully fetched some new posts
          return SliverInfiniteAnimatedList<Comment>(
            items: state.comments,
            itemTopPadding: 20.0,
            itemLeftPadding: screenHorizontalPadding,
            itemRightPadding: screenHorizontalPadding,
            itemBottomPadding: 20.0,
            firstItemWithoutTopPadding: true,
            lastItemWithoutBottomPadding: false,
            showDivider: true,
            itemLayoutBuilder: (comment, index) =>
                CommentLayoutInVerticalList(comment: comment),
            loadingLayout: const ListDefaultLoadingIndicator(),
          );
        }

        if (state is CommentsFetchingListIsEmpty) {
          //Show Empty List Widget
          return SliverToBoxAdapter(
            child: EmptyCommentsList(
              onActionClicked: () => context
                  .read<CommentsFetchingCubit>()
                  .fetchComments(howManyShouldFetch: 50),
            ),
          );
        }

        if (state is CommentsFetchingFetchingState) {
          //Build only we have nothing in our comments list and start fetching
          return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: LoadingIndicator(hasBackground: false),
              ));
        }

        //default state (initialize)
        return SliverToBoxAdapter(child: Container());
      },
    );
  }
}
