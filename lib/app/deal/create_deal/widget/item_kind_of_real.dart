import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

import '../../../../common/constants/enums.dart';

class ItemKindOfReal extends StatelessWidget {
  ///Chọn loại BĐS
  const ItemKindOfReal({
    Key? key,
    required this.type,
    required this.name,
    required this.icon,
    required this.onTap,
    required this.value,
  }) : super(key: key);
  final RealEstateType type;
  final RealEstateType value;
  final String name;
  final String icon;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Material(
        color: yrColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.w),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 213.h,
            width: 168.w,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.h,
                      ),
                      SizedBox(
                        height: 94.h,
                        child: getImage(
                          icon.toString(),
                          isAsset: true,
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      Text(
                        name.toString(),
                        style: kText14Weight400_Dark,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 48.h,
                  width: 48.h,
                  alignment: Alignment.center,
                  child: Container(
                    height: 24.h,
                    width: 24.h,
                    decoration: BoxDecoration(
                        color: type == value ? yrColorPrimary : yrColorLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: yrColorPrimary, width: 2)),
                    child: type == value
                        ? SvgPicture.asset(
                            getIcon("check.svg"),
                            color: yrColorPrimary,
                          )
                        : Container(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
