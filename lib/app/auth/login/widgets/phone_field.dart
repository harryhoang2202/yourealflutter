import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    Key? key,
    required TextEditingController phoneNumber,
    this.onChanged,
  })  : _phoneNumber = phoneNumber,
        super(key: key);

  final TextEditingController _phoneNumber;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Text(
            "Số điện thoại",
            style: kText14_Dark,
          ),
        ),
        TextFormField(
          onChanged: onChanged,
          controller: _phoneNumber,
          style: kText18Weight400_Hint,
          keyboardType: TextInputType.phone,
          textAlignVertical: TextAlignVertical.center,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Yêu cầu nhập số điện thoại";
            }
            if (!val.isPhoneNumber) {
              return "Số điện thoại không hợp lệ";
            }
            return null;
          },
          decoration: InputDecoration(
            errorStyle: kText14Weight400_Error,
            fillColor: yrColorLight,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            isDense: true,
            isCollapsed: true,
            hintText: "Số điện thoại",
            hintStyle: kText14Weight400_Hint,
          ).allBorder(
            OutlineInputBorder(
              borderSide: const BorderSide(color: yrColorPrimary),
              borderRadius: BorderRadius.circular(
                8.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
