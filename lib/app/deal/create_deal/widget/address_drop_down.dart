import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressDropdown<T> extends StatelessWidget {
  const AddressDropdown(
      {Key? key,
      required this.onChanged,
      required this.items,
      required this.value})
      : super(key: key);

  final void Function(T? value) onChanged;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      items: items,
      value: value,
      isExpanded: true,
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: const Icon(
          Icons.arrow_drop_down,
          color: yrColorHint,
        ),
      ),
      onChanged: onChanged,
      style: kText14Weight400_Hint,
      dropdownColor: yrColorLight,
      underline: Container(),
    );
  }
}
