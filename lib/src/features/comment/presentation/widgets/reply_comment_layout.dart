import 'package:flutter/material.dart';
import 'package:shaspeaker_news_app/src/infrastructure/utils/helper_methods.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../domain/comment.dart';

class ReplyCommentLayout extends StatefulWidget {
  const ReplyCommentLayout({
    Key? key,
    required this.reply,
    this.dotIconColor,
    required this.bottomPadding,
  }) : super(key: key);

  final Comment reply;
  final Color? dotIconColor;
  final double bottomPadding;
  @override
  State<ReplyCommentLayout> createState() => _ReplyCommentLayoutState();
}

class _ReplyCommentLayoutState extends State<ReplyCommentLayout> {
  bool fullContent = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Profile Picture
        ProfilePicture(
          imageUrl: widget.reply.userImageUrl,
          height: 55.0,
          width: 55.0,
          reservedIconSize: 25.0,
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
                      '${widget.reply.userName} ${widget.reply.userLastName}',
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
                        color: widget.dotIconColor ??
                            Theme.of(context).primaryColor),
                    //Space between Dot Icon and sent time
                    const SizedBox(
                      width: 10.0,
                    ),
                    //comment's sent time
                    Text(
                      HelperMethods.calculateTimeForRepresetingInUI(
                          widget.reply.createdAt),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 12.0),
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 10.0,
              ),
              // comment's content

              TextHandleOverflow(
                content: widget.reply.content,
                maxLine: 5,
                textStyle: Theme.of(context).textTheme.bodyLarge,
              ),

              //Bottom Padding
              SizedBox(
                height: widget.bottomPadding,
              )
            ],
          ),
        )
      ],
    );
  }
}
