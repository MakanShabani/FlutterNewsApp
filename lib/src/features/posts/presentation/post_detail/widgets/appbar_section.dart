import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';

import '../../../../../common_widgets/common_widgest.dart';
import '../../../../../custome_icons/custome_icons_icons.dart';
import '../../../../bookmark post/presentation/post_bookmark_button/post_bookmark_cubit/post_bookmark_cubit.dart';
import '../../../domain/posts_models.dart';
import '../cubit/post_details_cubit.dart';

class AppbarSection extends StatelessWidget {
  const AppbarSection({
    Key? key,
    this.onBookmarkedPressed,
    required this.postId,
  }) : super(key: key);
  final VoidCallback? onBookmarkedPressed;
  final String postId;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      stretch: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20.0,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.share),
          iconSize: 20.0,
        ),
        BlocBuilder<PostDetailsCubit, PostDetailsState>(
          buildWhen: (previous, current) =>
              current is PostDetailsFetchedSuccessfully ||
              current is PostDetailsBookmarkHasUpdated,
          builder: (context, state) {
            return BookmarkButton(
              size: 20.0,
              isBoolmarked: context.read<PostDetailsCubit>().state
                      is PostDetailsFetchedSuccessfully
                  ? (context.read<PostDetailsCubit>().state
                          as PostDetailsFetchedSuccessfully)
                      .post
                      .isBookmarked
                  : (context.read<PostDetailsCubit>().state
                          as PostDetailsBookmarkHasUpdated)
                      .post
                      .isBookmarked,
              isLoading: context
                  .watch<PostBookmarkCubit>()
                  .state
                  .currentBookmarkingPosts
                  .contains(postId),
              onPressed: onBookmarkedPressed,
            );
          },
        ),
        const SizedBox(
          width: screenHorizontalPadding,
        ),
      ],
      flexibleSpace: Image.network(
        fit: BoxFit.cover,
        (context.read<PostDetailsCubit>().state
                        as PostDetailsFetchedSuccessfully)
                    .post
                    .imagesUrls ==
                null
            ? 'null_image'
            : (context.read<PostDetailsCubit>().state
                    as PostDetailsFetchedSuccessfully)
                .post
                .imagesUrls!
                .first,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: screenHorizontalPadding,
              vertical: appbarBottomVerticalPadding),
          child: Row(
            children: [
              TimeInText(
                dateTime: (context.read<PostDetailsCubit>().state
                        as PostDetailsFetchedSuccessfully)
                    .post
                    .createdAt,
                textColor: Colors.white,
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    CustomeIcons.comment,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    (context.read<PostDetailsCubit>().state
                            as PostDetailsFetchedSuccessfully)
                        .post
                        .commentsCountToString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                width: 16.0,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    (context.read<PostDetailsCubit>().state
                            as PostDetailsFetchedSuccessfully)
                        .post
                        .viewsCountToString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
