import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key? key,
    required TextEditingController password,
    this.label = "Mật khẩu",
    this.validator,
    this.onChanged,
    this.onSubmit,
    this.focusNode,
  })  : _password = password,
        super(key: key);

  final TextEditingController _password;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Text(
            label,
            style: kText14_Dark,
          ),
        ),
        TextFormField(
          onChanged: onChanged,
          onFieldSubmitted: onSubmit,
          focusNode: focusNode,
          validator: validator ??
              (val) {
                if (val == null || val.isEmpty) {
                  return "Yêu cầu nhập mật khẩu";
                }
                if (!val.isPassword) {
                  return "Mật khẩu từ 6 ký tự, bao gồm ít nhất một ký tự số và một ký tự đặc biệt";
                }
                return null;
              },
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _password,
          style: kText18Weight400_Hint,
          textAlignVertical: TextAlignVertical.center,
          obscureText: true,
          decoration: InputDecoration(
            errorStyle: kText14Weight400_Error,
            errorMaxLines: 2,
            fillColor: yrColorLight,
            isCollapsed: true,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            isDense: true,
            hintText: label,
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
