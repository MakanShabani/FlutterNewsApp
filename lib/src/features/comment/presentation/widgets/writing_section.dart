import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/common_widgets/common_widgest.dart';
import 'package:responsive_admin_dashboard/src/features/comment/presentation/blocs/cubits.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';
import 'dart:math' as math;

class WritingSection extends StatefulWidget {
  const WritingSection({Key? key, this.hintText, this.onSendTap})
      : super(key: key);
  final String? hintText;
  final ValueSetter<String>? onSendTap;
  @override
  State<WritingSection> createState() => _WritingSectionState();
}

//use to save user's input
String _userInput = '';

class _WritingSectionState extends State<WritingSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              screenHorizontalPadding, 10.0, screenHorizontalPadding, 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  maxLines: 5,
                  minLines: 1,
                  onChanged: (value) => _userInput = value,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hintText,
                  ),
                ),
              ),
              BlocBuilder<SendCommentCubit, SendCommentState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 30.0,
                    child: state is SendCommentSendingState
                        ? const LoadingIndicator(
                            hasBackground: false,
                            size: 16.0,
                            topPadding: 20.0,
                          )
                        : Transform.rotate(
                            angle: -math.pi / 4,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.bottomCenter,
                              onPressed: () => widget.onSendTap != null
                                  ? widget.onSendTap!(_userInput)
                                  : null,
                              icon: Icon(
                                Icons.send,
                                size: 20.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
