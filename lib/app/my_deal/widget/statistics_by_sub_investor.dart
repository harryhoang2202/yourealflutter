import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';

class SubInvestor extends StatefulWidget {
  const SubInvestor({Key? key}) : super(key: key);

  @override
  _SubInvestorState createState() => _SubInvestorState();
}

class _SubInvestorState extends State<SubInvestor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 208.h,
      decoration: BoxDecoration(
        color: yrColorLight,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.h),
          bottomRight: Radius.circular(8.h),
          bottomLeft: Radius.circular(8.h),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 112.w,
                decoration: BoxDecoration(
                    color: yrColorPrimary,
                    borderRadius: BorderRadius.circular(8.w)),
                padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/ic_total_deal.svg",
                      width: 32.h,
                      height: 32.h,
                    ),
                    Text(
                      "Tổng dự án:",
                      style: kText14Weight400_Light,
                    ),
                    Text(
                      "4",
                      style: kText18_Light,
                    ),
                  ],
                ),
              ),
              16.horSp,
              Container(
                width: 112.w,
                decoration: BoxDecoration(
                    color: yrColorSuccess,
                    borderRadius: BorderRadius.circular(8.w)),
                padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/ic_paid.svg",
                      width: 32.h,
                      height: 32.h,
                    ),
                    Text(
                      "Đã thanh toán:",
                      style: kText14Weight400_Light,
                    ),
                    Text(
                      "4",
                      style: kText18_Light,
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dự án lớn nhất:",
                style: kText16Weight400_Secondary2,
              ),
              Text(
                "${Tools().convertMoneyToSymbolMoney("1160000000")} VNĐ",
                style: kText16_Accent,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng dự án:",
                style: kText16Weight400_Secondary2,
              ),
              Text(
                "${Tools().convertMoneyToSymbolMoney("1160000000")} VNĐ",
                style: kText16_Accent,
              )
            ],
          )
        ],
      ),
    );
  }
}
