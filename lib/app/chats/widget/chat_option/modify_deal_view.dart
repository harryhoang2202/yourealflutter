import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:youreal/app/deal/cost_incurred/widgets/information_text.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModifyDealView extends StatelessWidget {
  const ModifyDealView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Điều chỉnh phần trăm Deal",
              style: kText18Weight500_Light,
            ),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12.w),
                        child: Text(
                          "Phần trăm hiện tại",
                          style: kText14Weight400_Light,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: yrColorLight,
                        ),
                        width: 1.sw,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "10",
                              style: kText14Weight400_Hint,
                            ),
                            Text(
                              "%",
                              style: kText14Weight400_Hint,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                SvgPicture.asset("assets/icons/ic_arrow_right_1.svg"),
                SizedBox(width: 16.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12.w),
                        child: Text(
                          "Phần trăm thay đổi",
                          style: kText14Weight400_Light,
                        ),
                      ),
                      TextFormField(
                        style: kText14Weight400_Primary,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: yrColorLight,
                          isDense: true,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 12.w),
                          suffixText: "%",
                          suffixStyle: kText14Weight400_Hint,
                        ).allBorder(
                          OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            InformationText(
              title: "Thành tiền",
              affix: 'VNĐ',
              content: "15.000.000",
              contentStyle: kText14Weight400_Hint,
            ),
            SizedBox(height: 64.h)
          ],
        ),
      ),
    );
  }
}
