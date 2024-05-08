import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';

class PopupQuesion extends StatelessWidget {
  final String title;
  final String textOk;
  final String textCancel;
  const PopupQuesion(
      {Key? key,
      required this.title,
      this.textOk = "Đồng ý",
      this.textCancel = "Hủy"})
      : super(key: key);

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
          title,
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
                child: PrimaryButton(
                  text: textCancel,
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  borderRadius: 16,
                  backgroundColor: yrColorLight,
                  textColor: yrColorPrimary,
                  borderSide: const BorderSide(color: yrColorPrimary),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: PrimaryButton(
                  text: textOk,
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  borderRadius: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
