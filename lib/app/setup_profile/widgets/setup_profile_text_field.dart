import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

class SetupProfileTextField extends StatelessWidget {
  const SetupProfileTextField(
      {Key? key,
      this.controller,
      this.validator,
      required this.label,
      this.suffixIcon,
      this.suffixIconConstraints,
      this.hint,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.prefixText,
      this.prefixStyle,
      this.fillColor = yrColorLight,
      this.textColor = yrColorHint,
      this.border = BorderSide.none,
      this.labelColor = yrColorLight,
      this.readOnly = false,
      this.heightBoxInput})
      : super(key: key);
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final String? hint;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final Color fillColor;
  final Color textColor;
  final BorderSide border;
  final Color labelColor;
  final bool readOnly;
  final double? heightBoxInput;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Text(
            label,
            style: kText14Weight400_Light.copyWith(color: labelColor),
          ),
        ),
        Container(
          height: heightBoxInput,
          padding: EdgeInsets.only(top: 4.h),
          decoration: BoxDecoration(
            color: yrColorLight,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            style: kText14Weight400_Hint.copyWith(color: textColor),
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.center,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: readOnly,
            decoration: InputDecoration(
              errorStyle: kText14Weight400_Error,
              fillColor: fillColor,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.w,
                horizontal: 12.w,
              ),
              isDense: true,
              isCollapsed: true,
              hintText: hint ?? label,
              hintStyle: kText14Weight400_Hint,
              prefixIcon: prefixText == null
                  ? null
                  : Center(
                      child: Text(
                        prefixText!,
                        style: prefixStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
              prefixIconConstraints: BoxConstraints.loose(Size(48.w, 24.h)),
              suffixIcon: suffixIcon,
              suffixIconConstraints: suffixIconConstraints,
            ).allBorder(
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  8.r,
                ),
                borderSide: border,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
