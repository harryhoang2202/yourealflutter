import 'package:flutter/material.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/size_config.dart';

class PopupSendSuggestion extends StatefulWidget {
  const PopupSendSuggestion({Key? key}) : super(key: key);

  @override
  _PopupSendSuggestionState createState() => _PopupSendSuggestionState();
}

class _PopupSendSuggestionState extends State<PopupSendSuggestion> {
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
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        alignment: Alignment.center,
        child: Text(
          "Bạn muốn gửi đề nghị này không?",
          textAlign: TextAlign.center,
          style: kText14_Primary,
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actions: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: Container(
                height: 55.h,
                width: screenWidth / 2 - 20.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: yrColorHint,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(15.h))),
                child: Text(
                  "Không",
                  style: kText14Weight400_Dark,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Container(
                height: 55.h,
                width: screenWidth / 2 - 20.w,
                decoration: BoxDecoration(
                    color: yrColorPrimary,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(15.h))),
                alignment: Alignment.center,
                child: Text(
                  "Có",
                  style: kText14Weight400_Dark,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
