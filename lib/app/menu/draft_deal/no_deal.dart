import 'package:flutter/material.dart';
import 'package:youreal/app/deal/create_deal/views/create_deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDeal extends StatelessWidget {
  final String title;

  const NoDeal({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      color: yrColorPrimary,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/empty.png"),
          SizedBox(
            height: 40.h,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: kText14Weight400_Light,
          ),
          SizedBox(
            height: 40.h,
          ),
          InkWell(
            onTap: () async {
              await Navigator.of(context, rootNavigator: true)
                  .popAndPushNamed(CreateDealScreen.id);
              // BlocProvider.of<LazyLoadBloc<Deal>>(context, listen: false)
              //     .add(LazyLoadEvent.initial());
            },
            child: Container(
              height: 40.h,
              width: screenWidth,
              decoration: BoxDecoration(
                color: yrColorLight,
                borderRadius: BorderRadius.circular(8.h),
              ),
              alignment: Alignment.center,
              child: Text(
                "Tạo deal",
                style: kText14Weight400_Primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
