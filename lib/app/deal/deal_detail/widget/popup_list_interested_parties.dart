import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

class PopupListInterestedParties extends StatefulWidget {
  const PopupListInterestedParties({Key? key}) : super(key: key);

  static const id = "PopupListInterestedParties";
  @override
  _PopupListInterestedPartiesState createState() =>
      _PopupListInterestedPartiesState();
}

class _PopupListInterestedPartiesState
    extends State<PopupListInterestedParties> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        leading: const YrBackButton(),
        title: Text("DS các bên liên quan", style: kText28_Light),
        centerTitle: true,
      ),
      body: ListView.separated(
          shrinkWrap: true,
          itemCount: 3,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          separatorBuilder: (context, index) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            return Container(
              height: 110.h,
              decoration: BoxDecoration(
                  color: yrColorLight,
                  borderRadius: BorderRadius.circular(8.r)),
              padding: EdgeInsets.all(8.h),
            );
          }),
      bottomNavigationBar: InkWell(
        onTap: () async {
          Navigator.pop(context);
        },
        child: Container(
            width: screenWidth,
            margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h),
            height: 55.h,
            decoration: BoxDecoration(
              color: yrColorLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Text("Đóng", style: kText18_Primary)),
      ),
    );
  }
}
