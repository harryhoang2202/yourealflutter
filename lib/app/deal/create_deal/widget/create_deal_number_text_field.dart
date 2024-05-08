import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvt_input_keyboard/tvt_input_keyboard.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

class CreateDealNumberTextField extends StatelessWidget {
  const CreateDealNumberTextField({
    Key? key,
    this.controller,
    required this.prefixText,
    this.affixText = "",
    this.enabled = true,
    this.onChanged,
    this.contentStyle,
    this.suffixIconWidth,
    this.allowFraction = false,
    this.inputAction = TextInputAction.done,
    this.focusNode,
    this.onEditingComplete,
  }) : super(key: key);

  final TextEditingController? controller;
  final String prefixText;
  final String affixText;
  final bool enabled;
  final bool allowFraction;
  final ValueChanged<String>? onChanged;
  final TextStyle? contentStyle;
  final double? suffixIconWidth;
  final TextInputAction inputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 8.h, left: 12.w),
            child: Text(
              prefixText,
              style: kText14Weight400_Light,
            )),
        Container(
          height: 45.h,
          padding: EdgeInsets.only(top: 4.h),
          decoration: BoxDecoration(
            color: yrColorLight,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            onChanged: onChanged,
            textInputAction: inputAction,
            keyboardType:
                TextInputType.numberWithOptions(decimal: allowFraction),
            enabled: enabled,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            style: contentStyle ?? kText14Weight400_Dark,
            inputFormatters: [ThousandsFormatter(allowFraction: allowFraction)],
            onEditingComplete: () {
              if (inputAction == TextInputAction.done) {
                focus.unfocus();
              } else if (inputAction == TextInputAction.next) {
                focus.nextFocus();
              }
              if (onEditingComplete != null) {
                onEditingComplete!();
              }
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              labelStyle: kText14Weight400_Dark,
              hintText: "0",
              hintStyle: kText14Weight400_Hint,
              suffixIcon: Container(
                width: suffixIconWidth ?? 40.w,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 8.w),
                child: Text(
                  affixText,
                  style: kText14Weight400_Hint,
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: 20.h,
              ),
              isDense: true,
              isCollapsed: true,
              filled: true,
              fillColor: yrColorLight,
            ).allBorder(
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
