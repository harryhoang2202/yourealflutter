import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

class TextInput1 extends StatefulWidget {
  final String labelText;
  final TextStyle? labelStyle;
  final TextEditingController? textInput;
  final TextStyle? inputTextStyle;
  final InputDecoration? decoration;
  final double? height;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool readOnly;
  final bool enabled;

  const TextInput1({
    Key? key,
    this.textInput,
    required this.labelText,
    this.labelStyle,
    this.inputTextStyle,
    this.decoration,
    this.height,
    this.keyboardType,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  _TextInput1State createState() => _TextInput1State();
}

class _TextInput1State extends State<TextInput1> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Text(
            widget.labelText,
            style: widget.labelStyle ?? kText14Weight400_Dark,
          ),
        ),
        TextFormField(
          controller: widget.textInput ?? controller,
          style: widget.inputTextStyle ?? kText14Weight400_Dark,
          maxLines: null,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          decoration: widget.decoration ??
              InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                border: InputBorder.none,
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
        )
      ],
    );
  }
}
