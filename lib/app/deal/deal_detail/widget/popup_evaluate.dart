import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/common/config/size_config.dart';

class Evaluate extends StatefulWidget {
  final String title;
  const Evaluate({Key? key, required this.title}) : super(key: key);

  @override
  _EvaluateState createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  TextEditingController note = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      insetPadding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "Đánh giá ${widget.title}".toUpperCase(),
          style: kText18_Primary,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 200.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
              child: RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                unratedColor: yrColorPrimary,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star_rate, color: yrColorPrimary),
                onRatingUpdate: (rating) {},
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: screenWidth,
              height: 100.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              alignment: AlignmentDirectional.topStart,
              child: TextFormField(
                controller: note,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText:
                      "Gửi lời nhận xét tới ${widget.title.toLowerCase()}",
                  hintStyle: kText14Weight400_Hint,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: yrColorPrimary,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: screenWidth,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 55.h,
            decoration: BoxDecoration(
                color: yrColorPrimary,
                borderRadius: BorderRadius.circular(15.h)),
            alignment: Alignment.center,
            child: Text(
              "Gửi",
              style: kText18_Light,
            ),
          ),
        )
      ],
    );
  }
}
