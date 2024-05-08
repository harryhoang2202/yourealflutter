import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/form_appraisal/blocs/appraisal_bloc/appraisal_bloc.dart';
import 'package:youreal/app/form_appraisal/model/analysis_and_adjustment/appraisal_adjustment_data.dart';
import 'package:youreal/app/form_appraisal/model/analysis_and_adjustment/appraisal_analysis_data.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

class ItemAnalysis<T> extends StatefulWidget {
  final T type;

  const ItemAnalysis({
    Key? key,
    required this.type,
    this.boxBackground = yrColorPrimary,
    this.textStyle,
    this.underlineColor = yrColorDark,
  }) : super(key: key);
  final Color boxBackground;
  final TextStyle? textStyle;
  final Color underlineColor;
  @override
  _ItemAnalysisState createState() => _ItemAnalysisState();
}

class _ItemAnalysisState extends State<ItemAnalysis> {
  String get subString {
    if (widget.type is AnalysisType) {
      return (widget.type as AnalysisType).someString;
    } else if (widget.type is AdjustmentType) {
      return (widget.type as AdjustmentType).someString;
    }
    throw "Unknown type";
  }

  String get name {
    if (widget.type is AnalysisType) {
      return (widget.type as AnalysisType).name.toUpperCase();
    } else if (widget.type is AdjustmentType) {
      return (widget.type as AdjustmentType).name;
    }
    throw "Unknown type";
  }

  void onTextChanged(_) {
    if (widget.type is AnalysisType) {
      _bloc.add(
        AppraisalAnalysisUpdated(
          widget.type,
          AppraisalAnalysisData(compareRealEstate: [
            controller1.tText,
            controller2.tText,
            controller3.tText
          ], type: widget.type),
        ),
      );
    } else if (widget.type is AdjustmentType) {
      _bloc.add(
        AppraisalAdjustmentUpdated(
          widget.type,
          AppraisalAdjustmentData(adjustmentPercentages: [
            double.tryParse(controller1.tText) ?? 0,
            double.tryParse(controller2.tText) ?? 0,
            double.tryParse(controller3.tText) ?? 0,
          ], type: widget.type),
        ),
      );
    }
  }

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  late AppraisalBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<AppraisalBloc>(context, listen: false);
    if (widget.type is AnalysisType) {
      final data = _bloc.state.analyses[widget.type];
      if (data?.compareRealEstate.isEmpty ?? true) return;
      controller1.text = data?.compareRealEstate[0] ?? "";
      controller2.text = data?.compareRealEstate[1] ?? "";
      controller3.text = data?.compareRealEstate[2] ?? "";
    } else if (widget.type is AdjustmentType) {
      final data = _bloc.state.adjustments[widget.type];
      if (data?.adjustmentPercentages.isEmpty ?? true) return;
      controller1.text = (data?.adjustmentPercentages[0] == 0
              ? ""
              : data?.adjustmentPercentages[0].toString()) ??
          "";
      controller2.text = (data?.adjustmentPercentages[1] == 0
              ? ""
              : data?.adjustmentPercentages[1].toString()) ??
          "";
      controller3.text = (data?.adjustmentPercentages[2] == 0
              ? ""
              : data?.adjustmentPercentages[2].toString()) ??
          "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.w),
      height: 90.h,
      child: Row(
        children: [
          Container(
            height: 90.h,
            width: 90.w,
            color: widget.boxBackground,
            padding: EdgeInsets.only(left: 3.w),
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: kText14Weight400_Dark,
            ),
          ),
          Container(
            height: 90.h,
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 3.w),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        "$subString 1: ",
                        style: kText14Weight400_Dark,
                      ),
                      Container(
                        height: 30.h,
                        width: 168.w,
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: TextFormField(
                          style: kText14Weight400_Dark,
                          controller: controller1,
                          onChanged: onTextChanged,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: widget.underlineColor)),
                          ),
                          keyboardType: widget.type is AnalysisType
                              ? null
                              : TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 3.w),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        "$subString 2: ",
                        style: kText14Weight400_Dark,
                      ),
                      Container(
                        height: 30.h,
                        width: 168.w,
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: TextFormField(
                          style: kText14Weight400_Dark,
                          controller: controller2,
                          onChanged: onTextChanged,
                          keyboardType: widget.type is AnalysisType
                              ? null
                              : TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 3.w),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Text(
                        "$subString 3: ",
                        style: kText14Weight400_Dark,
                      ),
                      Container(
                        height: 30.h,
                        width: 168.w,
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: TextFormField(
                          style: kText14Weight400_Dark,
                          controller: controller3,
                          onChanged: onTextChanged,
                          keyboardType: widget.type is AnalysisType
                              ? null
                              : TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
