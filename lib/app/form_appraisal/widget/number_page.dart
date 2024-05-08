import 'package:flutter/material.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberPage extends StatelessWidget {
  final int page;
  final Color activeColor;
  const NumberPage(
      {Key? key, required this.page, this.activeColor = yrColorPrimary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: 6.w),
          height: 5.h,
          width: 63.w,
          color: page == 1 || page == 5 ? activeColor : yrColorHint,
        ),
        Container(
          margin: EdgeInsets.only(right: 6.w),
          height: 5.h,
          width: 63.w,
          color: page == 2 || page == 5 ? activeColor : yrColorHint,
        ),
        Container(
          margin: EdgeInsets.only(right: 6.w),
          height: 5.h,
          width: 63.w,
          color: page == 3 || page == 5 ? activeColor : yrColorHint,
        ),
        Container(
          margin: EdgeInsets.only(right: 6.w),
          height: 5.h,
          width: 63.w,
          color: page == 4 || page == 5 ? activeColor : yrColorHint,
        ),
      ],
    );
  }
}
