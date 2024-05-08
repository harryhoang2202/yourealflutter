import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lottie/lottie.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/notification/blocs/notification_cubit.dart';
import 'package:youreal/app/notification/views/notification_screen.dart';
import 'package:youreal/common/config/color_config.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 14.w),
      child: InkResponse(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .pushNamed(NotificationScreen.id);
        },
        radius: 24.w,
        child: SizedBox.square(
          dimension: 50.w,
          child: BlocSelector<NotificationCubit, NotificationState, bool>(
            selector: (state) => state.hasNotification,
            builder: (context, hasNotification) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/ic_notification.svg",
                    color: yrColorLight,
                  ),
                  if (hasNotification)
                    Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: 8.h),
                        child: SizedBox(
                            height: 30.h,
                            child: Lottie.asset("assets/ic_notification.json")))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
