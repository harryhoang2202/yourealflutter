import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class PrimaryButton extends StatefulWidget {
  PrimaryButton({
    Key? key,
    required this.text,
    this.onTap,
    this.verticalPadding,
    this.backgroundColor = yrColorPrimary,
    this.borderSide = BorderSide.none,
    this.textColor = yrColorLight,
    this.minWidth,
    this.enable = true,
    this.borderRadius,
    this.horizontalMargin,
    int debounceTime = 200,
  })  : _duration = Duration(milliseconds: debounceTime),
        super(key: key);

  final String text;
  final GestureTapCallback? onTap;
  final double? verticalPadding;
  final double? horizontalMargin;
  final Color backgroundColor;
  final BorderSide borderSide;
  final Color textColor;
  final double? minWidth;
  final bool enable;
  final double? borderRadius;
  final Duration _duration;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  late ValueNotifier<bool> _isEnabled;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isEnabled = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isEnabled,
      builder: (context, isEnabled, child) => OutlinedButton(
        onPressed: widget.enable ? (isEnabled ? _onButtonPressed : null) : null,
        child: Text(
          widget.text,
          style: kText18Weight400_Light.copyWith(color: widget.textColor),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          side: widget.borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding:
              EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 12.h),
          minimumSize: Size(
              widget.minWidth ??
                  (1.sw - ((widget.horizontalMargin ?? 16) * 2).w),
              0),
        ),
      ),
    );
  }

  void _onButtonPressed() {
    _isEnabled.value = false;
    if (widget.onTap != null) {
      widget.onTap!();
    }
    _timer = Timer(widget._duration, () => _isEnabled.value = true);
  }
}
