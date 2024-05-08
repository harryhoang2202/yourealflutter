import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorDialog extends StatelessWidget {
  final String error;

  const ErrorDialog({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(16.w),
      titlePadding:
          EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w, bottom: 16.h),
      title: Center(
        child: Text(
          error,
          style: kText14Weight400_Primary,
          textAlign: TextAlign.center,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.w),
      ),
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            'Đóng',
            style: kText18Weight400_Light,
          ),
          style: OutlinedButton.styleFrom(
            fixedSize: Size(screenWidth.w, 45.h),
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
            backgroundColor: yrColorPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.w),
            ),
          ),
        ),
      ],
    );
  }
}
