import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/app/deal/deal_detail/blocs/deal_detail_bloc.dart';
import 'package:youreal/app/deal/deal_detail/services/deal_detail_service.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/widget/app_loading.dart';

import 'package:youreal/view_models/app_bloc.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'popup_quesion.dart';

class ListDepositArgs {
  final Deal deal;
  const ListDepositArgs({
    required this.deal,
  });
}

class ListDeposit extends StatefulWidget {
  final Deal deal;
  static const id = "ListDeposit";

  const ListDeposit({
    Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  State<ListDeposit> createState() => _ListDepositState();
}

class _ListDepositState extends State<ListDeposit> {
  late Deal _deal;
  ButtonStatus stateOnlyText = ButtonStatus.idle;
  listenStateButton() async {
    //Todo:Update event sign contract: Status = 4
    AppBloc.dealDetailBloc.updateEventDeal(widget.deal.id.toString(), "4");
    //Todo: Update event all investors were deposited: Status = 11
    AppBloc.dealDetailBloc.updateEventDeal(widget.deal.id.toString(), "11");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _deal = widget.deal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DealDetailBloc, DealDetailState>(
      listener: (context, state) async {
        if (state.updateEventStatus is LoadingState) {
          AppLoading.show(context);
          setState(() {
            stateOnlyText = ButtonStatus.loading;
          });
        } else if (state.updateEventStatus is SuccessState) {
          AppLoading.dismiss(context);
          setState(() {
            stateOnlyText = ButtonStatus.success;
          });
          AppBloc.dealDetailBloc.initial(widget.deal.id.toString());
          Navigator.pop(context);
        } else if (state.updateEventStatus is ErrorState) {
          AppLoading.dismiss(context);
          setState(() {
            stateOnlyText = ButtonStatus.fail;
          });
          await Utils.showInfoSnackBar(context,
              message: "Có lỗi xảy ra! Vui lòng thử lại.", isError: true);
        } else if (state.updateEventStatus is IdleState) {
          AppLoading.dismiss(context);
          setState(() {
            stateOnlyText = ButtonStatus.idle;
          });
        }
      },
      listenWhen: (previous, current) =>
          previous.updateEventStatus != current.updateEventStatus,
      child: Scaffold(
        backgroundColor: yrColorPrimary,
        appBar: AppBar(
          backgroundColor: yrColorPrimary,
          elevation: 0,
          leading: const YrBackButton(),
          title: Text("Danh sách đặt cọc", style: kText28_Light),
          centerTitle: true,
        ),
        body: ListView.separated(
          shrinkWrap: true,
          itemCount: _deal.allocations!.length,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            var item = _deal.allocations![index];

            var price = item.allocation! * (double.parse(_deal.price!)) / 100;
            return Container(
              height: 65.h,
              decoration: BoxDecoration(
                  color: yrColorLight,
                  borderRadius: BorderRadius.circular(8.r)),
              padding: EdgeInsets.all(8.h),
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 130.w,
                              alignment: Alignment.centerLeft,
                              child: Text("Người đặt cọc:",
                                  style: kText14Bold_Primary)),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text("${item.firstName} ${item.lastName}",
                                  style: kText14Bold_Primary))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 130.w,
                              alignment: Alignment.centerLeft,
                              child: Text("Số tiền:",
                                  style: kText14Weight400_Primary)),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  Tools()
                                      .convertMoneyToSymbolMoney(
                                          price.toString())
                                      .toString(),
                                  style: kText14Weight400_Primary))
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 20.h,
                    width: 80.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: yrColorPrimary,
                        borderRadius: BorderRadius.circular(4.h)),
                    child: ButtonUpdatePaymentStatus(
                        dealId: _deal.id,
                        allocation: item,
                        initButton: item.paymentStatusId != null &&
                                item.paymentStatusId! >= 2
                            ? ButtonStatus.success
                            : ButtonStatus.idle,
                        paymentStatusId: 2),
                  )
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 50.h, left: 20.w, right: 20.w),
          child: Container(
            height: 55.h,
            alignment: Alignment.center,
            child: ProgressButtonAnimation(
              onPressed: () async {
                try {
                  if (!await _allMemberDeposited(context)) {
                    return;
                  }
                  if (stateOnlyText == ButtonStatus.idle) {
                    var result = await showDialog(
                        context: context,
                        builder: (context) => const PopupQuesion(
                              title:
                                  "Bạn chắc chắn các thành viên đã hoàn tất đặt cọc?",
                              textOk: "Hoàn tất",
                            ));
                    if (result) {
                      listenStateButton();
                    }
                  }
                } catch (e) {
                  printLog(" ");
                }
              },
              state: stateOnlyText,
              height: 55.h,
              radius: stateOnlyText == ButtonStatus.loading ? 30.r : 8.r,
              maxWidth: screenWidth,
              minWidth: 55.h,
              stateWidgets: {
                ButtonStatus.idle: Text(
                  "Hoàn tất đặt cọc",
                  style: kText18Weight400_Primary,
                ),
                ButtonStatus.fail: Text(
                  "Có lỗi xảy ra",
                  style: kText18Weight400_Light,
                ),
                ButtonStatus.success: Text(
                  "Hoàn tất đặt cọc",
                  style: kText18Weight400_Light,
                ),
              },
              stateColors: const {
                ButtonStatus.idle: yrColorLight,
                ButtonStatus.loading: yrColorPrimary,
                ButtonStatus.fail: yrColorError,
                ButtonStatus.success: yrColorSuccess,
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _allMemberDeposited(BuildContext context) async {
    for (final allocation in _deal.allocations!) {
      final status = allocation.paymentStatusId;
      if (status == null || status < 2) {
        await Utils.showInfoSnackBar(
          context,
          message: "Còn thành viên chưa đặt cọc",
          title: "Không thể hoàn tất đặt cọc",
          isError: true,
          position: FlushbarPosition.BOTTOM,
          margin: EdgeInsets.only(bottom: 70.h),
        );
        return false;
      }
    }

    return true;
  }
}

class ButtonUpdatePaymentStatus extends StatefulWidget {
  final int dealId;
  final Allocation allocation;
  final int paymentStatusId;
  final ButtonStatus? initButton;
  const ButtonUpdatePaymentStatus(
      {Key? key,
      required this.dealId,
      required this.allocation,
      required this.paymentStatusId,
      this.initButton})
      : super(key: key);

  @override
  _ButtonUpdatePaymentStatusState createState() =>
      _ButtonUpdatePaymentStatusState();
}

class _ButtonUpdatePaymentStatusState extends State<ButtonUpdatePaymentStatus> {
  ButtonStatus stateOnlyText = ButtonStatus.idle;

  listenStateButton() async {
    setState(() {
      stateOnlyText = ButtonStatus.loading;
    });
    var result = await DealDetailService.paymentStatus(
        dealId: widget.dealId,
        allowcationId: widget.allocation.id,
        paymentStatusId: widget.paymentStatusId);
    if (result) {
      setState(() {
        stateOnlyText = ButtonStatus.success;
      });
      AppBloc.dealDetailBloc.initial(widget.dealId.toString());
    } else {
      setState(() {
        stateOnlyText = ButtonStatus.fail;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          stateOnlyText = ButtonStatus.idle;
        });
      });
    }
  }

  @override
  void initState() {
    if (widget.initButton != null) {
      setState(() {
        stateOnlyText = widget.initButton!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressButtonAnimation(
      onPressed: () async {
        if (stateOnlyText == ButtonStatus.idle) {
          var result = await showDialog(
            context: context,
            builder: (context) => PopupQuesion(
              title:
                  "Bạn chắc chắn ${widget.allocation.firstName} ${widget.allocation.lastName} ${widget.paymentStatusId == 3 ? "đã thanh toán" : "đã đặt cọc"}?",
              textOk: "Hoàn tất",
            ),
          );
          if (result) {
            listenStateButton();
          }
        }
      },
      state: stateOnlyText,
      height: _getButtonHeight(),
      radius: stateOnlyText == ButtonStatus.loading ? 10.r : 4.r,
      maxWidth: 80.w,
      minWidth: 20.h,
      progressIndicatorSize: 10.r,
      stateWidgets: {
        ButtonStatus.idle: Text(
          "Xác nhận",
          style: kText14Weight400_Light,
        ),
        ButtonStatus.fail: Text(
          "Xác nhận",
          style: kText14Weight400_Light,
        ),
        ButtonStatus.success: Text(
          widget.paymentStatusId == 3 ? "Đã thanh toán" : "Đã đặt cọc",
          style: kText14Weight400_Light,
          textAlign: TextAlign.center,
        ),
      },
      stateColors: const {
        ButtonStatus.idle: yrColorPrimary,
        ButtonStatus.loading: yrColorPrimary,
        ButtonStatus.fail: yrColorError,
        ButtonStatus.success: yrColorSecondary,
      },
    );
  }

  double _getButtonHeight() {
    if (stateOnlyText == ButtonStatus.success && widget.paymentStatusId == 3) {
      return 36.h;
    }
    return 20.h;
  }
}
