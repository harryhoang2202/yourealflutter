// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:youreal/app/auth/login/widgets/custom_checkbox.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class OtpCheck extends StatefulWidget {
  final OtpCheckModel item;
  final bool isChecked;
  final Function() onCheck;

  const OtpCheck({
    Key? key,
    required this.item,
    this.isChecked = false,
    required this.onCheck,
  }) : super(key: key);

  @override
  _OtpCheckState createState() => _OtpCheckState();
}

class _OtpCheckState extends State<OtpCheck> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onCheck();
      },
      child: SizedBox(
        height: 33,
        child: Row(
          children: [
            SizedBox(
              height: 35.h,
              width: 35.h,
              child: CustomCheckbox(
                isChecked: widget.isChecked,
                size: 35.h,
                checkedFillColor: Colors.transparent,
                unCheckedBorderColor: yrColorLight,
              ),
            ),
            SizedBox(
              width: 11.w,
            ),
            Expanded(
              child: Text(
                widget.item.name,
                style: kText14Weight400_Light,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OtpCheckModel {
  final String id;
  final String name;

  OtpCheckModel({required this.id, required this.name});

  OtpCheckModel copyWith({
    String? id,
    String? name,
  }) {
    return OtpCheckModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
