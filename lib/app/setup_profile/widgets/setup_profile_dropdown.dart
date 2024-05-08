import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class SetupProfileDropdown<T> extends StatelessWidget {
  const SetupProfileDropdown({
    Key? key,
    required this.onChanged,
    required this.items,
    this.value,
    required this.label,
    this.labelColor = yrColorLight,
    this.fillColor = yrColorLight,
    this.border = BorderStyle.none,
    this.textColor = yrColorHint,
    this.heightBoxInput,
  }) : super(key: key);

  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String label;
  final Color labelColor;
  final Color fillColor;
  final BorderStyle border;
  final Color textColor;
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
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(style: border, color: textColor),
          ),
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 10.h),
          child: DropdownButton<T>(
            isDense: true,
            isExpanded: true,
            onChanged: onChanged,
            underline: const SizedBox.shrink(),
            style: kText14Weight400_Hint.copyWith(color: textColor),
            value: value,
            items: items,
          ),
        ),
      ],
    );
  }
}
