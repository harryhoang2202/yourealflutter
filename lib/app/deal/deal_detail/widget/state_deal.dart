import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StateDeal extends StatelessWidget {
  final String tile;
  final Color? color;
  const StateDeal({Key? key, required this.tile, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      margin: EdgeInsets.only(left: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: color ?? yrColorLight,
        borderRadius: BorderRadius.circular(8.w),
      ),
      alignment: Alignment.center,
      child: Text(
        tile.toUpperCase(),
        style: kText14_Accent,
      ),
    );
  }
}
