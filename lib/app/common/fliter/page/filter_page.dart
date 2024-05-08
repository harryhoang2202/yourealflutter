part of '../index.dart';

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  static const id = "FilterView";
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  late FilterBloc filterBloc;
  bool sendingFilter = false;
  double minValue = 0;
  double maxValue = 10000000000;

  @override
  void initState() {
    super.initState();
    filterBloc = BlocProvider.of<FilterBloc>(context);
    filterBloc.initial();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: yrColorPrimary,
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.clear,
              color: yrColorLight,
              size: 38.w,
            ),
          ),
          title: Text(
            "Lọc kết quả",
            style: kText28_Light,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 14.w),
                child: Text(
                  "Bỏ lọc",
                  style: kText14_Light,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: yrColorPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
              //   child: RichText(
              //     text: TextSpan(
              //       text: 'Leader của bạn: ',
              //       style: kText18_Light,
              //       children: <TextSpan>[
              //         TextSpan(
              //           text: '\n(Chọn ít nhất 1 leader)',
              //           style: kText14Weight400_Light,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20.h,
              // ),
              // Container(
              //   width: screenWidth,
              //   height: 140.h,
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.only(left: 20.w, right: 10.w),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Column(
              //           children: _leaderViewBuild1,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 5.w,
              //       ),
              //       Expanded(
              //         child: Column(
              //           children: _leaderViewBuild2,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ngân sách tài chính",
                  style: kText18_Light,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              BlocSelector<FilterBloc, FilterState, Tuple2<double, double>>(
                selector: (state) {
                  return Tuple2(state.investmentLimitState.lowerValue,
                      state.investmentLimitState.upperValue);
                },
                builder: (context, investmentLimit) {
                  return Container(
                    width: screenWidth - 50.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 10.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 90.h,
                          padding: EdgeInsets.only(top: 10.h),
                          child: CustomSlider1(
                            valueMin: minValue,
                            valueMax: maxValue,
                            valueLower: investmentLimit.item1,
                            valueUpper: investmentLimit.item2,
                            valueChange: (lower, upper) {
                              filterBloc.changedInvestmentLimit(lower, upper);
                            },
                          ),
                        ),
                        Container(
                          height: 20.h,
                          padding: EdgeInsets.only(left: 15.w, right: 10.w),
                          margin: EdgeInsets.only(top: 60.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "0 VNĐ",
                                style: kText14Weight400_Light,
                              ),
                              Text(
                                "${Tools().convertMoneyToSymbolMoney(maxValue.toString())} VNĐ",
                                style: kText14Weight400_Light,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: RichText(
                  text: TextSpan(
                    text: 'Bất động sản bạn đang quan tâm: ',
                    style: kText18_Light,
                    children: <TextSpan>[
                      TextSpan(
                        text: '\n(Chọn ít nhất 2 loại)',
                        style: kText14Weight400_Light,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              BlocSelector<
                  FilterBloc,
                  FilterState,
                  Tuple3<List<OtpCheckModel>, List<OtpCheckModel>,
                      List<OtpCheckModel>>>(
                selector: (state) {
                  return Tuple3(
                      state.soilTypesState.listSoilType1,
                      state.soilTypesState.listSoilType2,
                      state.soilTypesState.selected);
                },
                builder: (context, listSoilType) {
                  return Container(
                    width: screenWidth,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.w, right: 10.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: listSoilType.item1
                                .map(
                                  (e) => Column(
                                    children: [
                                      OtpCheck(
                                        item: e,
                                        isChecked:
                                            listSoilType.item3.contains(e),
                                        onCheck: () {
                                          filterBloc.selectSolid(e);
                                        },
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: listSoilType.item2
                                .map(
                                  (e) => Column(
                                    children: [
                                      OtpCheck(
                                        item: e,
                                        isChecked:
                                            listSoilType.item3.contains(e),
                                        onCheck: () {
                                          filterBloc.selectSolid(e);
                                        },
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                  child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(10.h),
                  child: BlocConsumer<FilterBloc, FilterState>(
                      listener: (context, state) {
                        if (state.sendStatus == const LoadingState()) {
                          setState(() {
                            sendingFilter = true;
                          });
                        } else if (state.sendStatus == const SuccessState()) {
                          setState(() {
                            sendingFilter = false;
                          });
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            sendingFilter = false;
                          });
                        }
                      },
                      listenWhen: ((previous, current) =>
                          previous.sendStatus != current.sendStatus),
                      builder: (context, state) {
                        return InkWell(
                          onTap: sendingFilter
                              ? null
                              : () async {
                                  filterBloc.sendFilter();
                                },
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: yrColorLight,
                                borderRadius: BorderRadius.circular(8.h)),
                            child: sendingFilter
                                ? const CircularProgressIndicator()
                                : Text(
                                    "Áp dụng",
                                    style: kText14_Primary,
                                  ),
                          ),
                        );
                      }),
                ),
              )),
              SizedBox(
                height: 40.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
