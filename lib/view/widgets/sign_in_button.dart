import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton(
      {Key? key,
      required this.minimumWidth,
      required this.backgroundColor,
      required this.textColor,
      required this.borderRadious,
      required this.logoImageAsset,
      required this.text,
      required this.onPressed})
      : super(key: key);

  final double minimumWidth;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadious;
  final String logoImageAsset;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: 0.0,
          minimumSize: Size.fromHeight(minimumWidth),
          primary: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadious))),
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
                child: Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
