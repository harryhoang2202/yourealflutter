import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;

  const ConfirmDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(16.w),
      titlePadding:
          EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w, bottom: 16.h),
      title: Center(
        child: Text(
          title,
          style: kText14Weight400_Primary,
          textAlign: TextAlign.center,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      children: [
        Row(
          children: [
            Flexible(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: false).pop(false);
                },
                child: Text(
                  'Hủy',
                  style: kText18Weight400_Primary,
                ),
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(screenWidth.w, 45.h),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: yrColorLight,
                  side: BorderSide(color: yrColorPrimary, width: 1.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Flexible(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: false).pop(true);
                },
                child: Text(
                  'Đồng ý',
                  style: kText18Weight400_Light,
                ),
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(screenWidth.w, 45.h),
                  backgroundColor: yrColorPrimary,
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
