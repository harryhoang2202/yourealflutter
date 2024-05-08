import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/common/config/color_config.dart';

class RowButton extends StatelessWidget {
  const RowButton({
    Key? key,
    required this.onLeftTap,
    required this.onRightTap,
    required this.leftText,
    required this.rightText,
    this.leftTheme = defaultLeftTheme,
    this.rightTheme = defaultRightTheme,
  }) : super(key: key);

  final GestureTapCallback onLeftTap;
  final GestureTapCallback onRightTap;
  final String leftText;
  final String rightText;
  final RowButtonTheme leftTheme;
  final RowButtonTheme rightTheme;
  static const defaultLeftTheme = RowButtonTheme(
    textColor: yrColorLight,
    backgroundColor: yrColorPrimary,
    borderSide: BorderSide(color: yrColorLight),
  );
  static const defaultRightTheme = RowButtonTheme(
    textColor: yrColorPrimary,
    backgroundColor: yrColorLight,
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            onTap: onLeftTap,
            text: leftText,
            textColor: leftTheme.textColor,
            backgroundColor: leftTheme.backgroundColor,
            borderSide: leftTheme.borderSide,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: PrimaryButton(
            onTap: onRightTap,
            text: rightText,
            textColor: rightTheme.textColor,
            backgroundColor: rightTheme.backgroundColor,
            borderSide: rightTheme.borderSide,
          ),
        ),
      ],
    );
  }
}

class RowButtonTheme {
  final Color textColor;
  final Color backgroundColor;
  final BorderSide borderSide;

  const RowButtonTheme({
    required this.textColor,
    required this.backgroundColor,
    required this.borderSide,
  });

  RowButtonTheme copyWith({
    Color? textColor,
    Color? backgroundColor,
    BorderSide? borderSide,
  }) {
    return RowButtonTheme(
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderSide: borderSide ?? this.borderSide,
    );
  }
}
