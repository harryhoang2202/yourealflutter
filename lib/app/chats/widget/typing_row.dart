import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';

class TypingRow extends StatelessWidget {
  final List<Image> images;

  const TypingRow({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      width: screenWidth.w,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 55.w),
              child: Stack(
                children: [
                  ...images
                      .asMap()
                      .map((i, e) => MapEntry(
                            i,
                            Positioned(
                              left: i == 0 ? 0 : (i * 14).w,
                              child: Container(
                                width: 24.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.r)),
                                  border:
                                      Border.all(width: 1, color: yrColorLight),
                                ),
                                child: SizedBox.fromSize(
                                  size: Size(24.w, 20.h),
                                  child: ClipRRect(
                                    child: e,
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .values
                      .toList()
                ],
              ),
            ),
            Text(
              '   +2 others are typing',
              style: kText14Weight400_Light,
            ),
          ],
        ),
      ),
    );
  }
}
