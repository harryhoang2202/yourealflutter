import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/config/text_config.dart';

class LazyListError extends StatelessWidget {
  const LazyListError(
      {Key? key,
      this.error = "Đã có lỗi xảy ra!\nChạm để thử lại.",
      required this.onTap})
      : super(key: key);

  final String error;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          error,
          style: kText14_Light,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
