import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    this.onChanged,
    this.onSubmit,
    this.readOnly = false,
    this.onTap,
    this.controller,
    this.focusNode,
    this.hintText = "Tìm kiếm",
    this.prefixText,
  }) : super(key: key);
  final ValueChanged<String>? onChanged;
  final void Function(String)? onSubmit;
  final bool readOnly;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final String? prefixText;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 50.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            style: kText14Weight400_Hint,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: onSubmit,
            textInputAction: TextInputAction.search,
            onChanged: onChanged,
            decoration: InputDecoration(
              errorStyle: kText14Weight400_Error,
              fillColor: yrColorGrey2,
              filled: true,
              prefixText: prefixText,
              suffixIcon: SizedBox(
                height: 24.w,
                width: 24.w,
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkResponse(
                    onTap: () {
                      if (controller != null && onSubmit != null) {
                        onSubmit!(controller!.text);
                      }
                    },
                    radius: 13.w,
                    child: Center(
                      child: SizedBox.fromSize(
                        size: Size(24.w, 24.w),
                        child: SvgPicture.asset(
                          "assets/icons/ic_search.svg",
                          color: yrColorPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              isDense: true,
              isCollapsed: true,
              hintText: hintText,
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
        ),
      ),
    );
  }
}
