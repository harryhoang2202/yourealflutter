import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/color_config.dart';
import '../../../../common/config/text_config.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {Key? key,
      required this.onTap,
      this.backgroundColor = yrColorLight,
      this.textColor = yrColorPrimary,
      this.title = "Thêm chứng chỉ",
      this.icon = Icons.add_circle_outline})
      : super(key: key);

  final GestureTapCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: yrColorPrimary),
          SizedBox(width: 8.w),
          Text(
            title,
            style: kText18Weight400_Primary.copyWith(color: textColor),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
