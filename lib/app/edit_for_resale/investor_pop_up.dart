import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

import 'yr_dialog.dart';

class InvestorsPopUp extends StatelessWidget {
  const InvestorsPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      backgroundColor: yrColorPrimary,
      titlePadding: EdgeInsets.only(top: 6.h),
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 20.h),
      title: Center(
        child: Text(
          'DANH SÁCH NĐT THAM GIA',
          style: kText14Weight400_Dark,
        ),
      ),
      children: [
        SizedBox.fromSize(
          size: Size((size.width).w, 600.h),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return InvestorItem(
                  duration: index % 2 == 0
                      ? const Duration(hours: 3, minutes: 35, seconds: 19)
                      : const Duration(seconds: 0));
            },
            itemCount: 6,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 59.h,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(size.width.w, 48.h),
              backgroundColor: yrColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Đóng'.toUpperCase(),
              style: kText14Weight400_Dark,
            ),
          ),
        ),
      ],
    );
  }
}

class InvestorItem extends StatelessWidget {
  final Duration duration;

  InvestorItem({
    Key? key,
    required this.duration,
  }) : super(key: key);

  final contactButtonKey = GlobalKey();

  Future showContactPopUp(
    BuildContext context,
    bool isFromTop,
    double currentWidgetPosition,
    double currentWidgetHeight,
    double contactButtonHeight,
    bool contacted,
  ) async {
    return await showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: Offset(0.0, isFromTop ? -1.0 : 1),
            end: Offset.fromDirection(0, 0),
          ).chain(CurveTween(curve: Curves.linear)).animate(animation),
          child: child,
        );
      },
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(
          builder: (context) => ContactPopUp(
            top: (currentWidgetPosition +
                currentWidgetHeight -
                contactButtonHeight),
            contacted: contacted,
          ),
        );
        return SafeArea(
          top: false,
          child: Builder(builder: (BuildContext context) {
            return Theme(data: Theme.of(context), child: pageChild);
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: yrColorLight,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Row(
                      children: [
                        Text(
                          'Phạm Văn A',
                          style: kText14Weight400_Dark,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: yrColorLight,
                          ),
                          child: Text(
                            'Leader',
                            style: kText14Weight400_Dark,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: isTimeUp(duration) ? yrColorDark : yrColorDark,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10.r)),
                    ),
                    height: 20.h,
                    width: 86.w,
                    child: Center(
                      child: Text(
                        durationToString(duration),
                        style: kText14Weight400_Dark,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
                child: Row(
                  children: [
                    Text(
                      '% Tham gia : 15 (%)',
                      style: kText14_Primary,
                    ),
                    const Spacer(),
                    Text(
                      '1,500,000,000 VNĐ',
                      style: kText14_Primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          key: contactButtonKey,
          onPressed: () async {
            RenderBox box = context.findRenderObject() as RenderBox;

            Offset position =
                box.localToGlobal(Offset.zero); //this is global position
            double currentWidgetPosition = position.dy;
            final currentWidgetHeight = box.size.height;
            final contactButtonHeight = (contactButtonKey.currentContext!
                    .findRenderObject() as RenderBox)
                .size
                .height;
            bool isFromTop = currentWidgetPosition / size.height < 0.5;
            await showContactPopUp(
              context,
              isFromTop,
              currentWidgetPosition,
              currentWidgetHeight,
              contactButtonHeight,
              isTimeUp(duration),
            );
          },
          style: OutlinedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            backgroundColor: yrColorHint.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.r),
                  bottomRight: Radius.circular(15.r)),
            ),
            minimumSize: Size(350.w, 20.h),
            fixedSize: Size(350.w, 22.h),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Liên hệ'.toUpperCase(),
                style: kText14Weight400_Dark,
                textAlign: TextAlign.center,
              ),
              SvgPicture.asset('assets/icons/ic_arrow_drop_down.svg')
            ],
          ),
        ),
      ],
    );
  }

  bool isTimeUp(Duration duration) {
    return duration.inSeconds == 0;
  }
}

class ContactPopUp extends StatelessWidget {
  final double top;
  final bool contacted;

  const ContactPopUp({Key? key, required this.top, required this.contacted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YrDialog(
      top: top,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r)),
      ),
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      child: SizedBox(
        height: 70.h,
        width: 350.w,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Số điện thoại:',
                  style: kText14Weight400_Dark,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  '0901234567',
                  style: kText14Weight400_Dark,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!contacted)
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Button1(
                        backgroundColor: yrColorPrimary,
                        text: 'Đã liên hệ',
                        onPress: () async {
                          await Tools().makePhoneCall('0377846295');
                        },
                      ),
                    ),
                  Button1(
                    backgroundColor: yrColorDark,
                    text: 'Liên hệ Admin',
                    onPress: () async {
                      await Tools().makePhoneCall('0377846295');
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset('assets/icons/ic_up_arrow.svg'),
            ),
          ],
        ),
      ),
    );
    /* return SizedBox.fromSize(
      size: Size(100, 100),
      child: Material(
        child: Container(
          height: 68.h,
          width: 100.w,
          constraints: BoxConstraints(
              maxHeight: 68.h,
              minHeight: 68.h,
              maxWidth: 350.w,
              minWidth: 350.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.r),
                bottomRight: Radius.circular(15.r)),
            color: Colors.red,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Số điện thoại:',
                    style: kText14Weigh500_2,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    '0901234567',
                    style: kText18Weight500_21,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button1(
                      backgroundColor: yrColorPrimary,
                      text: 'Đã liên hệ',
                      onPress: () {
                        printLog('tap');
                      },
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Button1(
                      backgroundColor: yrColorDark,
                      text: 'Liên hệ Admin',
                      onPress: () {},
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  printLog('back ${this.hashCode}');
                  Navigator.pop(context);
                },
                child: SvgPicture.asset('assets/icons/ic_up_arrow.svg'),
              ),
            ],
          ),
        ),
      ),
    );*/
  }
}

class Button1 extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final void Function() onPress;

  const Button1({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPress,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: backgroundColor,
        minimumSize: Size(73.w, 24.h),
      ),
      child: Text(
        text,
        style: kText14Weight400_Dark,
      ),
    );
  }
}
