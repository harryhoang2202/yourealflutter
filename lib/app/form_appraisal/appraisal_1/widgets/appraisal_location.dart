import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/create_deal/widget/detail_address.dart';
import 'package:youreal/app/form_appraisal/blocs/appraisal_bloc/appraisal_bloc.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class AppraisalLocation extends StatelessWidget {
  ///Vị trí bất động sản
  const AppraisalLocation({
    Key? key,
    this.primary = yrColorDark,
    this.labelStyle,
    this.inputTextStyle,
    this.underlineColor,
  }) : super(key: key);
  final Color primary;
  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final Color? underlineColor;

  @override
  Widget build(BuildContext context) {
    final AppraisalBloc appraisalBloc =
        BlocProvider.of<AppraisalBloc>(context, listen: false);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 8.w),
          alignment: Alignment.centerLeft,
          child: Text(
            "1. Vị trí bất động sản",
            style: kText18_Light,
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        const DetailAddress(),
      ],
    );
  }
}
