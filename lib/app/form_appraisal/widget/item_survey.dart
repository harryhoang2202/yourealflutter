import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import 'package:youreal/app/form_appraisal/blocs/appraisal_bloc/appraisal_bloc.dart';
import 'package:youreal/app/form_appraisal/model/survey_data.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

class ItemSurvey extends StatefulWidget {
  final SurveyType type;

  const ItemSurvey(
      {Key? key,
      required this.type,
      this.primary = yrColorPrimary,
      this.secondary = yrColorDark,
      this.priceColor = yrColorDark})
      : super(key: key);
  final Color primary;
  final Color secondary;
  final Color priceColor;

  @override
  State<ItemSurvey> createState() => _ItemSurveyState();
}

class _ItemSurveyState extends State<ItemSurvey> {
  List<ItemCompare> listItemCompare = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<AppraisalBloc>(context, listen: false);
    surveyComparisonToItemCompare(bloc.state.survey[widget.type]!.comparisons);
  }

  void surveyComparisonToItemCompare(List<SurveyComparison> comparisons) {
    final bloc = BlocProvider.of<AppraisalBloc>(context, listen: false);
    listItemCompare = [];
    for (var element in comparisons) {
      final tempItem = ItemCompare(
        priceColor: widget.priceColor,
        comparison: element,
        type: widget.type,
        onRemoved: (id) {
          final temp = listItemCompare
              .firstWhere((element) => element.comparison.id == id);

          bloc.add(AppraisalComparisonDeleted(widget.type, temp.comparison));
        },
      );
      listItemCompare.add(tempItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appraisalBloc =
        BlocProvider.of<AppraisalBloc>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
          color: yrColorLight, borderRadius: BorderRadius.circular(12.r)),
      child: BlocSelector<AppraisalBloc, AppraisalState, SurveyData>(
        selector: (state) => state.survey[widget.type]!,
        builder: (context, state) {
          surveyComparisonToItemCompare(state.comparisons);
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                      color: yrColorSecondary,
                      borderRadius: BorderRadius.circular(8.h)),
                  child: Row(
                    children: [
                      Container(
                        width: 130.w,
                        alignment: Alignment.center,
                        child: Text(
                          widget.type.name,
                          style: kText14Weight400_Light,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 3.w),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "BĐS thẩm định: ",
                              style: kText14Weight400_Light,
                            ),
                            Container(
                              height: 20.h,
                              width: 137.w,
                              padding: EdgeInsets.only(bottom: 4.w),
                              child: TextFormField(
                                style: kText14Weight400_Light,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20.h,
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 20.h,
                        width: 130.w,
                        alignment: Alignment.center,
                        child: Text(
                          "Tên BĐS so sánh",
                          style: kText14Weight400_Dark,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 20.h,
                          alignment: Alignment.center,
                          child: Text(
                            "Giá BĐS so sánh",
                            style: kText14Weight400_Dark,
                          ),
                        ),
                      ),
                      SizedBox(width: 30.w)
                    ],
                  ),
                ),
                ListView(
                  key: Key(listItemCompare.length.toString()),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: listItemCompare,
                ),
                InkWell(
                  onTap: () {
                    final tempItem = ItemCompare(
                      priceColor: widget.priceColor,
                      comparison: SurveyComparison(
                          id: const Uuid().v4(), price: 0, realEstateName: ""),
                      type: widget.type,
                      onRemoved: (id) {
                        final temp = listItemCompare.firstWhere(
                            (element) => element.comparison.id == id);

                        appraisalBloc.add(
                          AppraisalComparisonDeleted(
                              widget.type, temp.comparison),
                        );
                      },
                    );
                    appraisalBloc.add(AppraisalComparisonAdded(
                        widget.type, tempItem.comparison));
                  },
                  child: Container(
                    height: 40.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                        color: yrColorPrimary,
                        borderRadius: BorderRadius.circular(8.h)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline_outlined,
                          color: yrColorLight,
                          size: 25.h,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Thêm BĐS",
                          style: kText14Weight400_Light,
                        )
                      ],
                    ),
                  ),
                )
              ]);
        },
      ),
    );
  }
}

class ItemCompare extends StatefulWidget {
  final Function(String) onRemoved;

  final SurveyType type;
  final Color priceColor;

  const ItemCompare({
    Key? key,
    required this.onRemoved,
    required this.type,
    required this.comparison,
    required this.priceColor,
  }) : super(key: key);

  final SurveyComparison comparison;

  @override
  State<ItemCompare> createState() => _ItemCompareState();
}

class _ItemCompareState extends State<ItemCompare> {
  final name = TextEditingController();

  final price = MoneyMaskedTextController(
      thousandSeparator: ",", decimalSeparator: "", precision: 0);

  @override
  void initState() {
    super.initState();
    name.text = widget.comparison.realEstateName;
    price.updateValue(widget.comparison.price);
  }

  @override
  Widget build(BuildContext context) {
    final appraisalBloc =
        BlocProvider.of<AppraisalBloc>(context, listen: false);
    return Container(
      height: 30.h,
      margin: EdgeInsets.only(bottom: 1.w),
      child: Row(
        children: [
          Container(
            height: 30.h,
            width: 130.w,
            color: yrColorPrimary,
            padding: EdgeInsets.only(left: 8.w),
            alignment: Alignment.center,
            child: TextField(
              controller: name,
              decoration: const InputDecoration(border: InputBorder.none),
              style: kText14Weight400_Dark,
              onChanged: (val) {
                appraisalBloc.add(
                  AppraisalComparisonUpdated(
                    widget.type,
                    widget.comparison.copyWith(
                      price: price.numberValue,
                      realEstateName: name.tText,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 8.w),
              color: yrColorHint,
              height: 30.h,
              alignment: Alignment.center,
              child: TextField(
                controller: price,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: kText14Weight400_Dark,
                onChanged: (val) {
                  appraisalBloc.add(
                    AppraisalComparisonUpdated(
                      widget.type,
                      widget.comparison.copyWith(
                        price: price.numberValue,
                        realEstateName: name.tText,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.onRemoved(widget.comparison.id);
            },
            child: SizedBox(
              height: 30.h,
              width: 30,
              child: const Icon(
                Icons.remove_circle_outline,
                color: yrColorPrimary,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
