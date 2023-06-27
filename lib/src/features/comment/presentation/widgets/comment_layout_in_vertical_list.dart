import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/features/settings/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/utils/helper_methods.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../domain/comment.dart';

class CommentLayoutInVerticalList extends StatelessWidget {
  const CommentLayoutInVerticalList({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Profile Picture
        ProfilePicture(
          imageUrl: comment.userImageUrl,
          height: 60.0,
          width: 60.0,
          reservedIconSize: 30.0,
        ),
        //Free space between profile picture & other widgets
        const SizedBox(
          width: 18.0,
        ),
        //
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user's name and comment's sent time
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //user's name section
                    Text(
                      '${comment.userName} ${comment.userLastName}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                    //Space between user's name and sent time
                    const SizedBox(
                      width: 10.0,
                    ),
                    //Dot Icon
                    DotIcon(
                        size: 4.0,
                        color: context.read<ThemeCubit>().state
                                is ThemeLightModeState
                            ? Colors.black
                            : Colors.white),
                    //Space between Dot Icon and sent time
                    const SizedBox(
                      width: 10.0,
                    ),
                    //comment's sent time
                    Text(
                      HelperMethods.calculateTimeForRepresetingInUI(
                          comment.createdAt),
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 10.0,
              ),
              // comment's content

              Text(
                comment.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(
                height: 8.0,
              ),

              // reply Button
              BorderTextButton(
                onClicked: () => {},
                buttonText: 'Reply',
                bottomBorder: BorderSide(color: Theme.of(context).primaryColor),
              )
            ],
          ),
        )
      ],
    );
  }
}
