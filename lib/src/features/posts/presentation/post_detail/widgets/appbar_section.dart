import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';

import '../../../../../common_widgets/common_widgest.dart';
import '../../../../../custome_icons/custome_icons_icons.dart';
import '../cubit/post_details_cubit.dart';

class AppbarSection extends StatelessWidget {
  const AppbarSection({Key? key}) : super(key: key);
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
        BookmarkButton(
            size: 20.0,
            isBoolmarked: (context.read<PostDetailsCubit>().state
                    as PostDetailsFetchedSuccessfully)
                .post
                .isBookmarked,
            isLoading: false),
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
                        .commentsCount
                        .toString(),
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
                        .viewsCount
                        .toString(),
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
