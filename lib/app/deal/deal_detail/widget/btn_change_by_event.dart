import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/create_deal/views/create_deal.dart';
import 'package:youreal/app/deal/deal_detail/blocs/deal_detail_bloc.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/widget/app_loading.dart';

import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/utils/blocs/lazy_load/lazy_load_bloc.dart';
import 'package:youreal/view_models/app_bloc.dart';
import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/popup_update_feature.dart';

import 'list_deposit.dart';
import 'list_payment.dart';
import 'popup_payment.dart';
import 'popup_quesion.dart';
import 'row_button.dart';
import 'vote_leader.dart';

class BtnChangeByEvent extends StatefulWidget {
  final Deal deal;
  final bool showBtn;
  const BtnChangeByEvent({Key? key, required this.deal, this.showBtn = true})
      : super(key: key);

  @override
  State<BtnChangeByEvent> createState() => _BtnChangeByEventState();
}

class _BtnChangeByEventState extends State<BtnChangeByEvent> {
  EventType event = EventType.FinishInvestment;
  int chooseLeader = -1;
  late Deal _deal;
  List<Voter> listVoter = [];

  @override
  void initState() {
    setState(() {
      _deal = widget.deal;
    });
    super.initState();
  }

  bool isLeader(userId) {
    for (var item in _deal.dealLeaders!) {
      if (item.id == userId) {
        return true;
      }
    }
    return false;
  }

  updateEventDeal({idEvent}) async {
    AppBloc.dealDetailBloc.updateEventDeal(widget.deal.id.toString(), idEvent);
  }

  snackBarWidget(title, error) {
    final snackBar = SnackBar(
      content: Container(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: kText14_Light,
        ),
      ),
      backgroundColor: !error ? yrColorSuccess : yrColorError,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    AppModel appModel = Provider.of<AppModel>(context);

    _buttonWidgetBuild() {
      if (_deal.events != null && _deal.events!.isNotEmpty) {
        event = _deal.events!.first.eventTypeId;
      } else {
        event = EventType.None;
      }
      switch (event) {
        case EventType.CloseTransaction:
          return _buildCase1(appModel.user);
        case EventType.ProrfomTheNameRegistration: //đóng deal
          return _buildCase2(appModel.user);
        case EventType.FullPayment: //Thực hiện trước bạ sang tên
          return _buildCase3(appModel.user);
        case EventType.SigningContract:
        case EventType.SignPropertyPurchaseContract: // Thanh toán toàn bộ
          return _buildCase4(appModel.user);
        case EventType.VoteDealLeader: //Ký hợp động và đặt cọc
          return _buildCase10(appModel.user);
        case EventType.FinishInvestment: //Bình chọn leader
          return _buildCase5(appModel.user);
        case EventType.SendProposal: //chốt danh sách nhà đầu tư
          return _buildCase6(appModel.user);

        default:
          return const SizedBox();
      }
    }

    return widget.showBtn
        ? BlocListener<DealDetailBloc, DealDetailState>(
            listener: (context, state) {
              if (state.initialStatus is SuccessState) {
                setState(() {
                  _deal = state.deal!;
                });
              }
            },
            child: Container(
              child: _buttonWidgetBuild(),
            ),
          )
        : const SizedBox();
  }

  _buildCase1(User user) {
    return isLeader(user.userId)
        ? RowButton(
            onLeftTap: () async {
              await Navigator.of(context, rootNavigator: true).pushNamed(
                CreateDealScreen.id,
                arguments: CreateDealArgs(
                  editToBuy: true,
                  draftDeal: _deal,
                ),
              );
              BlocProvider.of<LazyLoadBloc<Deal>>(context, listen: false)
                  .add(LazyLoadRefreshed());
            },
            onRightTap: () {
              showDialog(
                context: context,
                builder: (_) => const PopupUpdateFeature(),
              );
            },
            leftText: "Bán sang tay",
            rightText: "Làm pháp lý",
          )
        : const SizedBox();
  }

//Todo: Button đóng deal: Leader xác nhận đóng deal đầu tư
  _buildCase2(User user) {
    return isLeader(user.userId)
        ? BlocListener<DealDetailBloc, DealDetailState>(
            listener: (context, state) async {
              if (state.closeDealStatus is LoadingState) {
                AppLoading.show(context);
              } else if (state.closeDealStatus is SuccessState) {
                AppLoading.dismiss(context);

                AppBloc.dealDetailBloc.initial(widget.deal.id.toString());
              } else if (state.closeDealStatus is ErrorState) {
                AppLoading.dismiss(context);
                await Utils.showInfoSnackBar(context,
                    message: "Có lỗi xảy ra! Vui lòng thử lại.", isError: true);
              } else if (state.closeDealStatus is IdleState) {
                AppLoading.dismiss(context);
              }
            },
            listenWhen: (previous, current) =>
                previous.closeDealStatus != current.closeDealStatus,
            child: PrimaryButton(
              text: "Đóng deal",
              onTap: () async {
                var result = await showDialog(
                    context: context,
                    builder: (context) => const PopupQuesion(
                          title: "Bạn chắc chắn đóng deal?",
                          textOk: "Đóng",
                        ));
                if (result) {
                  try {
                    updateEventDeal(idEvent: 1);

                    AppBloc.dealDetailBloc.closeDeal(widget.deal.id.toString());
                  } catch (e) {
                    printLog("Btn change by event case 2 error: $e");
                    snackBarWidget("Có lỗi xảy ra! Vui lòng thử lại", true);
                  }
                }
              },
              textColor: yrColorPrimary,
              backgroundColor: yrColorLight,
            ),
          )
        : const SizedBox();
  }

//Todo: Button hoàn tất sang tên và DS liên quan: Leader xác nhận đã hoàn tất thủ tục sang tên
  _buildCase3(User user) {
    return isLeader(user.userId)
        ? BlocListener<DealDetailBloc, DealDetailState>(
            listener: (context, state) async {
              if (state.updateEventStatus is LoadingState) {
                AppLoading.show(context);
              } else if (state.updateEventStatus is SuccessState) {
                AppLoading.dismiss(context);

                AppBloc.dealDetailBloc.initial(widget.deal.id.toString());
              } else if (state.updateEventStatus is ErrorState) {
                AppLoading.dismiss(context);
                await Utils.showInfoSnackBar(context,
                    message: "Có lỗi xảy ra! Vui lòng thử lại.", isError: true);
              } else if (state.updateEventStatus is IdleState) {
                AppLoading.dismiss(context);
              }
            },
            listenWhen: (previous, current) =>
                previous.updateEventStatus != current.updateEventStatus,
            child: RowButton(
              onLeftTap: () async {
                var result = await showDialog(
                    context: context,
                    builder: (context) => const PopupQuesion(
                          title: "Bạn chắc chắn đã hoàn tất thủ tục sang tên?",
                          textOk: "Hoàn tất",
                        ));
                if (result) {
                  updateEventDeal(idEvent: 2);
                }
              },
              onRightTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const PopupUpdateFeature(),
                );
              },
              leftText: "Hoàn tất sang tên",
              rightText: "DS liên quan",
            ),
          )
        : const SizedBox();
  }

//Todo: Button DS thanh toán: Leader xác nhận các nhà đầu từ đã thanh toán
  _buildCase4(User user) => Row(
        children: [
          if (isLeader(user.userId))
            Expanded(
              child: PrimaryButton(
                text: "DS thanh toán",
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    ListPayment.id,
                    arguments: ListPaymentArgs(deal: _deal),
                  );
                },
                textColor: yrColorPrimary,
                backgroundColor: yrColorLight,
              ),
            ),
        ],
      );

//Todo: Button DS đặt cọc: Leader xác nhận các nhà đầu từ đã đặt cọc
  _buildCase10(User user) => Row(
        children: [
          if (isLeader(user.userId)) ...[
            Expanded(
              child: PrimaryButton(
                text: "DS đặt cọc",
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    ListDeposit.id,
                    arguments: ListDepositArgs(deal: _deal),
                  );
                },
                textColor: yrColorPrimary,
                backgroundColor: yrColorLight,
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ],
      );

//Todo: Button bình chọn leader: Hiển thị danh sách các nhà đầu tư
  _buildCase5(User user) {
    return PrimaryButton(
      text: "Bình chọn leader",
      onTap: () async {
        await showAnimatedDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Dialog(
            insetPadding: EdgeInsets.only(
                left: 10.w, right: 10.w, top: screenHeight - 400.h),
            child: VoteLeader(deal: _deal),
          ),
          animationType: DialogTransitionType.slideFromBottom,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      },
      textColor: yrColorPrimary,
      backgroundColor: yrColorLight,
    );
  }

//Todo: Button Tham gia deal và liên hệ môi giới
  _buildCase6(User user) {
    return RowButton(
        onLeftTap: () async {
          await showAnimatedDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => Dialog(
              insetPadding: EdgeInsets.only(
                  left: 10.w, right: 10.w, top: screenHeight - 70.h),
              child: InkWell(
                onTap: () async {
                  if (widget.deal.user?.phoneNumber != null) {
                    await Tools()
                        .makePhoneCall(widget.deal.user?.phoneNumber ?? "");
                  }
                },
                child: Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                      color: yrColorLight,
                      borderRadius: BorderRadius.circular(10.h)),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    children: [
                      Container(
                        height: 40.h,
                        width: 40.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: yrColorPrimary),
                        child: const Icon(
                          Icons.phone,
                          color: yrColorLight,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.deal.user?.phoneNumber ?? "",
                            style: kText28_Primary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            animationType: DialogTransitionType.slideFromBottom,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        },
        onRightTap: () async {
          showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => PopupPayment(
              deal: widget.deal,
            ),
          );
        },
        leftText: "Liên hệ môi giới",
        rightText: "Tham gia deal");
  }
}
