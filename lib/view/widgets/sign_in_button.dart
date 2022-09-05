import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton(
      {Key? key,
      this.minimumHeight,
      this.backgroundColor,
      this.elevation,
      this.textColor,
      this.borderRadious,
      required this.logoImageAsset,
      required this.text,
      required this.onPressed})
      : super(key: key);

  final double? elevation;
  final double? minimumHeight;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadious;
  final String logoImageAsset;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          elevation: elevation,
          minimumSize:
              minimumHeight != null ? Size.fromHeight(minimumHeight!) : null,
          shape: borderRadious != null
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadious!))
              : null,
          textStyle:
              Theme.of(context).textTheme.button!.copyWith(color: textColor)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 40.0, 0),
        child: Row(
          children: [
            SizedBox(
                width: 30.0,
                child: Image.asset(
                  'assets/images/google.png',
                )),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
