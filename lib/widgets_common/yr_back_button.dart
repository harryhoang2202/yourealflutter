import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/config/color_config.dart';

class YrBackButton extends StatelessWidget {
  const YrBackButton({Key? key, this.onTap, this.color = yrColorLight})
      : super(key: key);

  final GestureTapCallback? onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
      radius: 24.w,
      child: Icon(
        Icons.arrow_back_ios,
        color: color,
      ),
    );
  }
}
