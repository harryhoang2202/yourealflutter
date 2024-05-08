import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/view_models/app_model.dart';

class AppraisalGeneralInfo extends StatelessWidget {
  ///Các thông tin chung
  ///
  const AppraisalGeneralInfo({Key? key}
      //   {
      //   this.primary = yrColorDark,
      //   this.labelStyle,
      //   this.inputTextStyle,
      //   this.underlineColor,
      // }
      )
      : super(key: key);

  // final Color primary;
  // final TextStyle? labelStyle;
  // final TextStyle? inputTextStyle;
  // final Color? underlineColor;
  @override
  Widget build(BuildContext context) {
    // final AppraisalBloc _appraisalBloc =
    //     BlocProvider.of<AppraisalBloc>(context, listen: false);
    //     _appraisalBloc.appraisalProposer.text = "";
    var appModel = Provider.of<AppModel>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Người gửi thẩm định",
                      style: kText14Weight400_Light,
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        alignment: AlignmentDirectional.centerStart,
                        padding: EdgeInsets.only(left: 12.w),
                        decoration: BoxDecoration(
                            color: yrColorLight,
                            borderRadius: BorderRadius.circular(8.h)),
                        child: Text(
                          "${appModel.user.firstName} ${appModel.user.lastName}",
                          style: kText14Weight400_Dark,
                        ),
                      ),
                    )
                  ],
                ),
              )

              // TextInput1(
              //   textInput: _appraisalBloc.appraisalProposer,
              //   labelText: "Người gửi thẩm định",
              //   readOnly: true,
              //   enabled: false,
              //   labelStyle: kText14Weight400_Light,
              // ),
              // SizedBox(
              //   height: 10.h,
              // ),
              // TextInput1(
              //   textInput: _appraisalBloc.propertyOwner,
              //   labelText: "Chủ sở hữu tài sản",
              //   labelStyle: kText14Weight400_Light,
              // ),
              // SizedBox(
              //   height: 10.h,
              // ),
              // TextInput1(
              //   textInput: _appraisalBloc.appraisalPurpose,
              //   labelText: "Mục đích thẩm định",
              //   height: 128.h,
              //   labelStyle: kText14Weight400_Light,
              // ),
              // SizedBox(
              //   height: 10.h,
              // ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Thời gian chấp nhận",
              //         style: kText14Weight400_Light,
              //       ),
              //       Container(
              //         height: 40.h,
              //         width: 180.w,
              //         padding: EdgeInsets.only(left: 10.w),
              //         decoration: BoxDecoration(
              //             color: yrColorLight,
              //             borderRadius: BorderRadius.circular(8.h)),
              //         child: TextFormField(
              //           controller: _appraisalBloc.appraisalAcceptedTime,
              //           style: kText14Weight400_Dark,
              //           textAlignVertical: TextAlignVertical.center,
              //           decoration: InputDecoration(
              //               border: InputBorder.none,
              //               hintText: "dd / mm / yyyy",
              //               hintStyle: kText14Weight400_Hint,
              //               alignLabelWithHint: true,
              //               suffixIconConstraints:
              //                   BoxConstraints(maxHeight: 20.h, maxWidth: 30.h),
              //               suffixIcon: InkWell(
              //                 onTap: () {},
              //                 child: Container(
              //                   padding: EdgeInsets.only(right: 10.w),
              //                   child: SvgPicture.asset(
              //                       "assets/icons/ic_calendar.svg"),
              //                 ),
              //               )),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 29.h,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
