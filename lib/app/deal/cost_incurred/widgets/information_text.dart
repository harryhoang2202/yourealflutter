import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class InformationText extends StatelessWidget {
  const InformationText({
    Key? key,
    required this.title,
    required this.content,
    required this.affix,
    this.contentStyle,
  }) : super(key: key);

  final String title;
  final String content;
  final String affix;
  final TextStyle? contentStyle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Text(
            title,
            style: kText14Weight400_Light,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: yrColorLight,
          ),
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                content,
                style: contentStyle ?? kText14Weight400_Dark,
              ),
              Text(
                affix,
                style: kText14Weight400_Hint,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
