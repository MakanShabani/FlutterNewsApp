import 'package:flutter/material.dart';

class TextHandleOverflow extends StatefulWidget {
  const TextHandleOverflow(
      {Key? key,
      required this.content,
      required this.maxLine,
      this.textStyle,
      this.textOverflow})
      : super(key: key);

  final int maxLine;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;
  final String content;

  @override
  State<TextHandleOverflow> createState() => _TextHandleOverflowState();
}

class _TextHandleOverflowState extends State<TextHandleOverflow> {
  bool _showFullContent = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _showFullContent = !_showFullContent;
      }),
      child: Text(
        widget.content,
        maxLines: _showFullContent ? widget.maxLine * 10 : widget.maxLine,
        overflow: _showFullContent
            ? TextOverflow.visible
            : widget.textOverflow ?? TextOverflow.ellipsis,
        style: widget.textStyle,
      ),
    );
  }
}
