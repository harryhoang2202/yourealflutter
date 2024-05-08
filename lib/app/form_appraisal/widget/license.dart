import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/edit_for_resale/yr_dialog.dart' as yr;
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

class LicenseBuild extends StatelessWidget {
  final AppraisalDocType kindLicense;
  final labelText;
  final Function()? onTap;
  final bool enable;

  const LicenseBuild({
    Key? key,
    required this.labelText,
    required this.kindLicense,
    this.onTap,
    required this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              onTap!();
            },
            child: Row(
              children: [
                Container(
                  height: 20.h,
                  width: 20.h,
                  decoration: BoxDecoration(
                      color: enable ? yrColorLight : yrColorSecondary,
                      border: Border.all(color: yrColorPrimary),
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(
                  labelText,
                  style: kText14Weight400_Light,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          InkResponse(
            radius: 10.r,
            onTap: () {
              RenderBox box = context.findRenderObject() as RenderBox;

              Offset position = box.localToGlobal(Offset.zero);
              double currentWidgetPosition = position.dy;
              final dialogHeight = 53.h;
              showDialog(
                  context: context,
                  builder: (context) => yr.YrDialog(
                        insetPadding: EdgeInsets.zero,
                        top: currentWidgetPosition - dialogHeight * 2,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          height: dialogHeight,
                          width: 330.w,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: yrColorLight,
                            borderRadius: BorderRadius.circular(10.h),
                          ),
                          child: Text(
                            kindLicense == AppraisalDocType.LegalDocument
                                ? "Các chứng từ thực hiện theo quy định/ quy trình của Ngân hàng"
                                : "Các chứng từ liên quan đến BĐS thẩm định do cơ quan Nhà nước cấp",
                            style: kText14Weight400_Primary,
                          ),
                        ),
                      ));
            },
            child: Container(
              width: 20.h,
              height: 20.h,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                getIcon("note.svg"),
                width: 20.h,
                height: 20.h,
                color: yrColorAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
