import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'text_input2.dart';

class Form5TextFields extends StatelessWidget {
  const Form5TextFields({
    Key? key,
    required this.donGiaUBND,
    required this.heSoK,
    required this.donGiaThamDinh,
    required this.dienTich,
    required this.thanhTien,
    this.primary = yrColorDark,
  }) : super(key: key);

  final Color primary;
  final TextEditingController donGiaUBND;
  final TextEditingController heSoK;
  final TextEditingController donGiaThamDinh;
  final TextEditingController dienTich;
  final TextEditingController thanhTien;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextInput2(
                  labelText: "Đơn giá UBND",
                  labelStyle: kText14Weight400_Dark,
                  textInput: donGiaUBND,
                  width: 95.w,
                  subText: " đồng/m²",
                  subStyle: kText14Weight400_Dark),
              TextInput2(
                labelText: "Hệ số K",
                labelStyle: kText14Weight400_Dark,
                textInput: heSoK,
                width: 91.w,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextInput2(
                  labelText: "Đơn giá thẩm định",
                  labelStyle: kText14Weight400_Dark,
                  textInput: donGiaThamDinh,
                  width: 95.w,
                  subText: " đồng/m²",
                  subStyle: kText14Weight400_Dark),
              TextInput2(
                  labelText: "Diện tích",
                  labelStyle: kText14Weight400_Dark,
                  textInput: dienTich,
                  width: 91.w,
                  subText: " m²",
                  subStyle: kText14Weight400_Dark),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            children: [
              TextInput2(
                  labelText: "Thành tiền",
                  labelStyle: kText14Weight400_Dark,
                  textInput: thanhTien,
                  width: 143.w,
                  subText: " đồng",
                  subStyle: kText14Weight400_Dark),
            ],
          ),
        ),
      ],
    );
  }
}
