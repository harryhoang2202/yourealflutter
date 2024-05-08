import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.titleStyle,
    this.padding,
  }) : super(key: key);

  final String title;
  final String icon;
  final GestureTapCallback onTap;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/ic_$icon.svg",
              height: 20.w,
              width: 20.w,
              color: iconColor ?? yrColorDark,
            ),
            16.horSp,
            Text(
              title,
              style: titleStyle ?? kText14Weight400_Dark,
            ),
          ],
        ),
      ),
    );
  }
}
