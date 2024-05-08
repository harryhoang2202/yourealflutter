import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class TextInput2 extends StatefulWidget {
  final String labelText;
  final TextStyle? labelStyle;
  final TextEditingController? textInput;
  final TextStyle? inputTextStyle;
  final String? subText;
  final TextStyle? subStyle;
  final double? width;
  final void Function(String)? onChanged;
  final bool readOnly;
  final BoxBorder? border;
  final Color backgroundColor;

  const TextInput2({
    Key? key,
    this.textInput,
    required this.labelText,
    this.labelStyle,
    this.inputTextStyle,
    this.subText,
    this.subStyle,
    this.width,
    this.onChanged,
    this.readOnly = false,
    this.border,
    this.backgroundColor = yrColorSecondary,
  }) : super(key: key);

  @override
  _TextInput2State createState() => _TextInput2State();
}

class _TextInput2State extends State<TextInput2> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.labelText,
          style: widget.labelStyle ?? kText14Weight400_Dark,
        ),
        SizedBox(
          width: 8.w,
        ),
        Container(
          height: 20.h,
          width: widget.width ?? 54.w,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: widget.border,
          ),
          child: TextFormField(
            style: widget.inputTextStyle ?? kText14Weight400_Dark,
            controller: widget.textInput,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none),
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
          ),
        ),
        if (widget.subText != null)
          Text(
            widget.subText!,
            style: widget.subStyle ?? kText14Weight400_Dark,
          ),
      ],
    );
  }
}
