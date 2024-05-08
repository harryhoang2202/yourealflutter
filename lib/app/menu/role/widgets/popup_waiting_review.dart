import 'package:flutter/material.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/size_config.dart';

class PopupWaitingReview extends StatefulWidget {
  final String? title;
  const PopupWaitingReview({Key? key, this.title}) : super(key: key);

  @override
  _PopupWaitingReviewState createState() => _PopupWaitingReviewState();
}

class _PopupWaitingReviewState extends State<PopupWaitingReview> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      insetPadding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 150.h,
        alignment: Alignment.center,
        child: Text(
          widget.title ??
              "Đề nghị của bạn đã được gửi tới Admin. "
                  "Vui lòng đợi được xét duyệt",
          style: kText14_Primary,
          textAlign: TextAlign.center,
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actions: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: screenWidth,
            height: 55.h,
            decoration: BoxDecoration(
                color: yrColorPrimary,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.h),
                    bottomRight: Radius.circular(15.h))),
            alignment: Alignment.center,
            child: Text(
              "Trở về Trang Chủ",
              style: kText18Weight400_Light,
            ),
          ),
        )
      ],
    );
  }
}
