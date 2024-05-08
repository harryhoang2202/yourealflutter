import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youreal/app/common/fliter/index.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/widget/app_loading.dart';
import 'package:youreal/view_models/app_bloc.dart';

import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'blocs/deal_detail_bloc.dart';
import 'event_stream/event_stream.dart';
import 'widget/btn_change_by_event.dart';
import 'widget/btn_see_more.dart';
import 'widget/deal_images_widget.dart';
import 'widget/investors.dart';
import 'widget/popup_evaluate.dart';
import 'widget/state_deal.dart';

class DealTracking extends StatefulWidget {
  final Deal deal;
  static const id = "DealTracking";

  const DealTracking({Key? key, required this.deal}) : super(key: key);

  @override
  _DealTrackingState createState() => _DealTrackingState();
}

class _DealTrackingState extends State<DealTracking> {
  late Timer timer;
  String timeWaiting = "00:00:00";
  int hoursWaiting = 0;
  late Deal deal;

  bool showTimeWaiting = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    AppBloc.dealDetailBloc.initial(widget.deal.id.toString());
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      deal = widget.deal;
    });
    AppBloc.dealDetailBloc.initial(widget.deal.id.toString());
  }

  initialData() {
    if (deal.dealStatusId == DealStatus.WaitingMainInvestor ||
        deal.dealStatusId == DealStatus.WaitingSubInvestor) {
      setState(() {
        showTimeWaiting = true;
      });
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        loadTimeCountDown(start: deal.approvedTime!, hoursWaiting: 24);
      });
    } else if (deal.dealStatusId == DealStatus.FinishedInvestors) {
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (deal.dealStatusId == DealStatus.WaitingMainInvestor ||
            deal.dealStatusId == DealStatus.WaitingSubInvestor) {
          setState(() {
            showTimeWaiting = true;
          });
          loadTimeCountDown(
              start: deal.events!.first.createdDate!, hoursWaiting: 4);
        }
      });
    } else {
      setState(() {
        showTimeWaiting = false;
      });
      timer = Timer(const Duration(seconds: 1), () {});
    }
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  EventType event = EventType.SendProposal;

  List<Widget> loadTimelineEvent() {
    try {
      List<Widget> events = [];

      if (deal.events != null) {
        for (int i = 0; i < deal.events!.length; i++) {
          var e = deal.events![i];
          if (i == 0) {
            event = e.eventTypeId;
            events.add(timelineStartBuild(e.createdDate!, e.eventName!));
          } else if (i == deal.events!.length - 1) {
            events.add(timelineEndBuild(e.createdDate!, e.eventName!));
          } else {
            events.add(timelineBuild(e.createdDate!, e.eventName!));
          }
        }
      }
      return events;
    } catch (e, trace) {
      printLog("$e $trace");
      return [];
    }
  }

  isShowTimeCountDown() {
    if (deal.dealStatusId == DealStatus.WaitingMainInvestor ||
        deal.dealStatusId == DealStatus.WaitingSubInvestor) {
      return true;
    }
    if (deal.events != null) {
      if (deal.events!.first.eventTypeId == EventType.FinishInvestment) {
        return true;
      }
    }
    return false;
  }

  loadTimeCountDown({required String start, required int hoursWaiting}) {
    try {
      var startTime = DateTime.parse(start.replaceFirst("Z", ""));
      var timeNow = DateTime.now();
      if ((timeNow.day - startTime.day) < 2) {
        var result =
            Tools().tinhThoiGian(startTime, timeNow, (hoursWaiting * 3600));

        if (mounted) {
          setState(() {
            timeWaiting = result;
          });
        }
        if (timeWaiting == "00:00:00") {
          timer.cancel();
        }
      } else {
        setState(() {
          timeWaiting = "00:00:00";
        });
        timer.cancel();
      }
    } catch (e) {
      setState(() {
        timeWaiting = "00:00:00";
      });
      timer.cancel();
    }
  }

  bool isLeader(userId) {
    for (var item in deal.dealLeaders!) {
      if (item.id == userId) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    AppModel appModel = Provider.of<AppModel>(context);

    stateOfDeal() {
      switch (deal.dealStatusId) {
        case DealStatus.Draft:
        case DealStatus.WaitingVerification:
        case DealStatus.WaitingApproval:
          return const StateDeal(tile: "Khởi tạo deal");
        case DealStatus.FinishedInvestors:
          return const StateDeal(tile: "Chốt deal đầu tư");
        case DealStatus.WaitingMainInvestor:
        case DealStatus.WaitingSubInvestor:
          return const StateDeal(tile: "Đầu tư");
        case DealStatus.Done:
          return const StateDeal(tile: "Hoàn tất");
        case DealStatus.Cancelled:
          return const StateDeal(
            tile: "Đã Hủy",
            color: yrColorError,
          );
        case DealStatus.Rejected:
          return const StateDeal(
            tile: "Bị từ chối",
            color: yrColorError,
          );
        default:
          return Container();
      }
    }

    return BlocListener<DealDetailBloc, DealDetailState>(
        listener: (context, state) {
          if (state.initialStatus is LoadingState) {
            AppLoading.show(context);
          } else if (state.initialStatus is SuccessState) {
            AppLoading.dismiss(context);
            if (state.deal != null) {
              setState(() {
                deal = state.deal!;
              });
              initialData();
            }
          } else if (state.initialStatus is ErrorState) {
            AppLoading.dismiss(context);
            Utils.showInfoSnackBar(
              context,
              message: "Có lỗi xảy ra! Vui lòng kiểm tra lại",
              isError: false,
            );
          } else if (state.initialStatus is IdleState) {
            AppLoading.dismiss(context);
            _refreshController.refreshCompleted();
          }
        },
        listenWhen: (previous, current) =>
            previous.initialStatus != current.initialStatus,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: yrColorPrimary,
              appBar: AppBar(
                backgroundColor: yrColorPrimary,
                elevation: 0,
                centerTitle: true,
                leadingWidth: 80.w,
                leading: const YrBackButton(),
                title: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Chi tiết deal",
                    style: kText28_Light,
                  ),
                ),
                actions: [
                  if (deal.dealStatusId.index >=
                      DealStatus.FinishedInvestors.index)
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => const Evaluate(
                                  title: "Deal leader",
                                ));
                      },
                      child: SizedBox(
                        width: 60.h,
                        child: Lottie.asset("assets/star1.json",
                            repeat: true, fit: BoxFit.contain),
                      ),
                    ),
                  if (deal.dealStatusId.index >=
                      DealStatus.FinishedInvestors.index)
                    InkResponse(
                      radius: 16.w,
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SafeArea(
                            child: BtnSeeMore(
                              isLeader: isLeader(appModel.user.userId),
                              hasDepositContract: event.index <=
                                  EventType.SigningContract.index,
                              hasPaymentContract:
                                  event.index <= EventType.FullPayment.index,
                              deal: deal,
                            ),
                          ),
                          useRootNavigator: true,
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/icons/ic_menu_dots.svg",
                        color: yrColorLight,
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                  SizedBox(width: 20.w),
                ],
              ),
              body: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropHeader(
                  waterDropColor: Colors.white,
                  complete: Container(),
                  refresh: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 26.h,
                        ),
                        SizedBox(
                          height: 60.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 35.h,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Giai đoạn:",
                                      style: kText14Weight400_Light,
                                    ),
                                  ),
                                  Container(
                                    child: stateOfDeal(),
                                  ),
                                ],
                              ),
                              if (isShowTimeCountDown())
                                Column(
                                  children: [
                                    Text(
                                      event == EventType.FinishInvestment
                                          ? "Bình chọn leader"
                                          : "Tham gia Deal",
                                      style: kText14Weight400_Light,
                                    ),
                                    Text(
                                      timeWaiting,
                                      style: kText14Weight400_Light,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 38.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            children: loadTimelineEvent(),
                          ),
                        ),
                        InfoDeal(
                          deal: deal,
                        ),
                        if (deal.dealStatusId.index >
                            DealStatus.WaitingApproval.index)
                          Investors(deal: deal),
                        SizedBox(
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                  padding: EdgeInsets.only(
                      top: 10.h, bottom: 40.h, left: 10.w, right: 10.w),
                  child: BtnChangeByEvent(deal: deal)),
            ),
          ],
        ));
  }
}

class InfoDeal extends StatelessWidget {
  final Deal deal;

  const InfoDeal({Key? key, required this.deal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    var total = double.parse(deal.price!);
    double percentInvested = 0;
    double totalAmountInvested = 0;
    double minAmount = 0;
    // double amountInvested = 0;
    if (deal.allocations != null && deal.allocations!.isNotEmpty) {
      var minPercent = deal.allocations!.last.allocation ?? 0;
      for (var item in deal.allocations!) {
        percentInvested = percentInvested + item.allocation!;
      }
      totalAmountInvested = total * percentInvested / 100;
      minAmount = total * minPercent / 100;
    }

    return Column(
      children: [
        SizedBox(
          height: 42.h,
        ),
        DealImagesWidget(
          deal: deal,
        ),

        SizedBox(
          height: 12.h,
        ),

        ///header
        Column(
          children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                deal.realEstate!.realEstateTypeName!.toString(),
                style: kText18Bold_Light,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: screenWidth,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      "assets/icons/ic_location1.svg",
                      color: yrColorLight,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  SizedBox(
                    // width: screenWidth - 200.w,
                    width: screenWidth - 50.w,
                    child: Text(
                      deal.realEstate!.address != null
                          ? "${deal.realEstate!.address!.fullAddress}"
                          : "Đang cập nhật",
                      style: kText14Weight400_Light,
                    ),
                  ),
                  // Expanded(
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Text(
                  //       "Cách xa 1.2 KM",
                  //       style: kText14Weight400_Light,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        Column(
          children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                (deal.dealStatusId.index <= DealStatus.WaitingApproval.index)
                    ? "Giá ký gửi"
                    : "Giá trị bất động sản",
                style: kText18Bold_Light,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 18.w),
              child: Text(
                "${Tools().convertMoneyToSymbolMoney(deal.realEstate?.price?.content?.toString() ?? "0")} VNĐ",
                style: kText18_Accent,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
        if ((deal.dealStatusId.index > DealStatus.WaitingApproval.index)) ...[
          Column(
            children: [
              Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: RichText(
                    text: TextSpan(
                        text: "Tổng tiền đầu tư ",
                        style: kText18_Light,
                        children: [
                          TextSpan(
                            text:
                                "${Tools().convertMoneyToSymbolMoney(deal.price.toString())}",
                            style: kText18Bold_Accent,
                          )
                        ]),
                  )),
              SizedBox(
                height: 12.h,
              ),
              Container(
                height: 80.h,
                padding: EdgeInsets.only(top: 10.h, right: 20.w),
                child: CustomSlider2(
                  value: totalAmountInvested,
                  valueMax: double.parse(deal.price!),
                  viewOnly: true,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15.w),
                child: Text(
                  "${deal.allocations != null ? deal.allocations!.length : "0"} người đầu tư",
                  style: kText14Weight400_Light,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 15.w),
                  alignment: AlignmentDirectional.centerStart,
                  child: RichText(
                    text: TextSpan(
                      text: "Số tiền nhỏ nhất",
                      style: kText18_Light,
                    ),
                  )),
              SizedBox(
                height: 8.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w),
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                alignment: AlignmentDirectional.centerStart,
                height: 45.h,
                width: screenWidth - 40.w,
                decoration: BoxDecoration(
                    color: yrColorLight,
                    borderRadius: BorderRadius.circular(8.h)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${Tools().convertMoneyToSymbolMoney(minAmount.toString())}",
                      style: kText14Weight400_Accent,
                    ),
                    Text(
                      "VNĐ",
                      style: kText14Weight400_Hint,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
