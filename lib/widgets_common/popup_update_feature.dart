import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class PopupUpdateFeature extends StatelessWidget {
  const PopupUpdateFeature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      contentPadding: EdgeInsets.zero,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "THÔNG BÁO",
          style: kText28_Light,
        ),
      ),
      content: Container(
        height: 50.h,
        alignment: Alignment.center,
        child: Text(
          "Tính năng sẽ được cập nhật trong thời gian tới!",
          textAlign: TextAlign.center,
          style: kText14_Light,
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      actions: [
        PrimaryButton(
          text: 'ĐÓNG',
          backgroundColor: yrColorLight,
          textColor: yrColorPrimary,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
