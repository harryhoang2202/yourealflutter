import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class DealOptionButton extends StatelessWidget {
  const DealOptionButton({
    Key? key,
    this.onTap,
    this.isActive = true,
    required this.text,
    required this.iconName,
  }) : super(key: key);

  final GestureTapCallback? onTap;
  final bool isActive;
  final String text;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: yrColorSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        minimumSize: Size(182.w, 36.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/icons/$iconName.svg",
            color: isActive ? yrColorLight : yrColorPrimary,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: isActive ? kText18Weight400_Light : kText18Weight400_Primary,
          ),
        ],
      ),
    );
  }
}
