import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    this.imageUrl,
    this.height,
    this.width,
    this.leftMargin,
    this.topMargin,
    this.righttMargin,
    this.bottomMargin,
    this.reservedIcon,
    this.reservedIconSize,
    this.reservedIconColor,
    this.reservedbackgroundColor,
  }) : super(key: key);
  final String? imageUrl;
  final double? height;
  final double? width;
  final double? leftMargin;
  final double? topMargin;
  final double? righttMargin;
  final double? bottomMargin;
  final IconData? reservedIcon;
  final double? reservedIconSize;
  final Color? reservedIconColor;
  final Color? reservedbackgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(leftMargin ?? 0.0, topMargin ?? 0.0,
          righttMargin ?? 0.0, bottomMargin ?? 0.0),
      child: SizedBox(
        height: height ?? 100.0,
        width: width ?? 100.0,
        child: imageUrl != null
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(imageUrl!),
              )
            : CircleAvatar(
                backgroundColor: reservedbackgroundColor ?? Colors.blue,
                child: Icon(
                  size: reservedIconSize ?? 50.0,
                  reservedIcon ?? Icons.person,
                  color: reservedIconColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}
