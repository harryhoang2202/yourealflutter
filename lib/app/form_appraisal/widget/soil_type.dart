import 'package:flutter/material.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/constants/enums.dart';

class LandType extends StatelessWidget {
  final AppraisalLandType landType;
  final labelText;
  final Function()? onTap;
  final bool enable;
  final TextStyle? style;
  const LandType({
    Key? key,
    required this.labelText,
    required this.landType,
    this.onTap,
    required this.enable,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Row(
        children: [
          Container(
            height: 20.h,
            width: 20.h,
            decoration: BoxDecoration(
                color: enable ? yrColorPrimary : yrColorLight,
                shape: BoxShape.circle,
                border: Border.all(color: yrColorPrimary)),
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            labelText,
            style: style ?? kText14Weight400_Light,
          ),
        ],
      ),
    );
  }
}
