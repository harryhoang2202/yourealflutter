import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/text_config.dart';

class RoleReqTextField extends StatelessWidget {
  const RoleReqTextField({
    Key? key,
    required this.controller,
    this.readOnly = false,
    required this.title,
    this.inputType = TextInputType.text,
    this.maxLine = 1,
  }) : super(key: key);

  final TextEditingController controller;
  final bool readOnly;
  final String title;
  final TextInputType inputType;
  final int? maxLine;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 104.w,
          child: Text(
            title,
            style: kText14_Dark,
          ),
        ),
        Expanded(
          child: TextField(
            readOnly: readOnly,
            controller: controller,
            keyboardType: inputType,
            maxLines: maxLine,
            decoration: const InputDecoration(
                border: InputBorder.none, isDense: true, isCollapsed: true),
            style: kText14Weight400_Hint,
          ),
        )
      ],
    );
  }
}
