import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeLeader extends StatelessWidget {
  const ChangeLeader({Key? key}) : super(key: key);

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
        height: 95.h,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        alignment: Alignment.center,
        child: Text(
          "Bạn muốn chuyển quyền Leader cho người khác trong nhóm không?",
          textAlign: TextAlign.center,
          style: kText14_Primary,
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          width: screenWidth,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 55.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: yrColorLight,
                        borderRadius: BorderRadius.circular(16.h),
                        border: Border.all(color: yrColorPrimary)),
                    child: Text(
                      "Hủy",
                      style: kText18Weight400_Primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    height: 55.h,
                    decoration: BoxDecoration(
                        color: yrColorPrimary,
                        borderRadius: BorderRadius.circular(16.h),
                        border: Border.all(color: yrColorPrimary)),
                    alignment: Alignment.center,
                    child: Text(
                      "Đồng ý",
                      style: kText18_Light,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Approval extends StatelessWidget {
  const Approval({Key? key}) : super(key: key);

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
          "Chuyển quyền Leader của bạn đã thành công. "
          "Vui lòng thông báo cho thành viên trong nhóm để đề cử leader mới.",
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
              "Đóng",
              style: kText18_Light,
            ),
          ),
        )
      ],
    );
  }
}
