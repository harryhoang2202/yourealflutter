import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

Widget timelineStartBuild(String time, String event) {
  var dt = DateTime.parse(time.replaceFirst("Z", ""));
  return SizedBox(
    height: 45.h,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 45.w,
          child: Text(
            "${dt.day < 10 ? '0' : ''}${dt.day}/${dt.month < 10 ? '0' : ''}${dt.month}",
            style: kText14Weight700_Accent,
          ),
        ),
        SizedBox(
          width: 20.w,
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 25.h,
                height: 20.h,
                decoration: const BoxDecoration(
                  color: yrColorAccent,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: yrColorLight,
                ),
              ),
            ],
          ),
        ),
        5.horSp,
        Expanded(
          child: Text(
            event,
            maxLines: 2,
            style: kText14Weight700_Accent,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    ),
  );
}

Widget timelineBuild(String time, String event) {
  var dt = DateTime.parse(time);
  return SizedBox(
    height: 45.h,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 45.w,
          child: Text(
            "${dt.day < 10 ? '0' : ''}${dt.day}/${dt.month < 10 ? '0' : ''}${dt.month}",
            style: kText14Weight400_Light,
          ),
        ),
        SizedBox(
          width: 20.w,
          height: 45.h,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: 1,
                  color: yrColorLight,
                ),
              ),
              Container(
                height: 20.h,
                width: 20.h,
                decoration: const BoxDecoration(
                  color: yrColorLight,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: yrColorLight,
                ),
              ),
            ],
          ),
        ),
        5.horSp,
        Expanded(
          child: Text(
            event,
            style: kText14Weight400_Light,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    ),
  );
}

Widget timelineEndBuild(String time, String event) {
  var dt = DateTime.parse(time);
  return SizedBox(
    height: 45.h,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 45.w,
          child: Text(
            "${dt.day < 10 ? '0' : ''}${dt.day}/${dt.month < 10 ? '0' : ''}${dt.month}",
            style: kText14Weight400_Light,
          ),
        ),
        SizedBox(
          width: 20.w,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: 1,
                  color: yrColorLight,
                ),
              ),
              Container(
                height: 20.h,
                width: 25.h,
                decoration: const BoxDecoration(
                  color: yrColorLight,
                  shape: BoxShape.circle,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        5.horSp,
        Expanded(
          child: Text(
            event,
            style: kText14Weight400_Light,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
