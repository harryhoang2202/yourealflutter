import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/auth/login/widgets/custom_checkbox.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/common/constants/extensions.dart';

class RoleReqBottom extends StatelessWidget {
  const RoleReqBottom({
    Key? key,
    required this.agreed,
    required this.onAgreeTap,
    required this.onSubmit,
  }) : super(key: key);

  final bool agreed;
  final GestureTapCallback onAgreeTap;
  final GestureTapCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        24.verSp,
        InkWell(
          onTap: onAgreeTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 32.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomCheckbox(
                    isChecked: agreed,
                    size: 20.w,
                    margin: EdgeInsets.only(right: 8.w),
                    checkedFillColor: Colors.transparent,
                    unCheckedBorderColor: yrColorLight,
                    icon: SvgPicture.asset(
                      "assets/icons/ic_check.svg",
                      color: yrColorLight,
                      height: 10.h,
                    ),
                  ),
                  Text(
                    "Tôi cam kết các thông tin trên đều là thật",
                    style: kText14Weight400_Light,
                  ),
                ],
              ),
            ),
          ),
        ),

        8.verSp,

        ///Button gửi đề nghị
        PrimaryButton(
          text: "Gửi đề nghị",
          onTap: agreed ? onSubmit : null,
          backgroundColor: agreed ? yrColorLight : yrColorHint,
          textColor: yrColorPrimary,
        ),
        32.verSp,
      ],
    );
  }
}
