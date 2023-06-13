import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/features/posts/domain/posts_models.dart';
import 'package:responsive_admin_dashboard/src/router/app_router.dart';
import 'package:responsive_admin_dashboard/src/router/route_names.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../../common_widgets/common_widgest.dart';
import '../../../../../infrastructure/constants.dart/view_constants.dart';
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
}