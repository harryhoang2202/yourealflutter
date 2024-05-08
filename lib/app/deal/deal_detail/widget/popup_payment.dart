import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:tvt_input_keyboard/tvt_input_keyboard.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/deal_detail/blocs/deal_detail_bloc.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/widget/app_loading.dart';
import 'package:youreal/view_models/app_bloc.dart';

import 'package:youreal/view_models/app_model.dart';

class PopupPayment extends StatefulWidget {
  final Deal deal;
  const PopupPayment({
    Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  _PopupPaymentState createState() => _PopupPaymentState();
}

class _PopupPaymentState extends State<PopupPayment> {
  int indexPayments = 0;
  final FocusNode _focusNode = FocusNode();
  TextEditingController percent = TextEditingController();
  TextEditingController money = TextEditingController();

  bool isLoading = false;
  double totalPrice = 0;
  String? errorMessage;
  bool isJoined = false;
  @override
  void initState() {
    super.initState();

    totalPrice = double.parse(widget.deal.price!);
    loadJoinedDeal();
    percent.addListener(() {
      var p = double.tryParse(percent.text);
      if (p != null && p > 100) {
        setState(() {
          errorMessage = "Số phần trăm tham gia không hợp lệ";
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              errorMessage = null;
            });
          }
        });
      }
    });
  }

  loadJoinedDeal() {
    if (widget.deal.allocations != null) {
      for (var item in widget.deal.allocations!) {
        if (item.userId ==
            Provider.of<AppModel>(context, listen: false).user.userId) {
          setState(() {
            isJoined = true;
            indexPayments = item.paymentMethodId ?? 0;
          });
          _onKeyboardTap(item.allocation!.toStringAsFixed(0));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator.adaptive(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () {
                //close bottom sheet when click on the blank area
                Navigator.maybePop(context);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: const BoxDecoration(
                color: yrColorLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            child: Column(
              children: [
                16.verSp,
                Text(
                  "Tham gia".toUpperCase(),
                  style: kText18_Primary,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Phần trăm",
                              style: kText14Weight400_Dark,
                            ),
                          ),
                          SizedBox(
                            height: 45.h,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              controller: percent,
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              focusNode: _focusNode,
                              style: kText14_Primary,
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                hintText: "0",
                                hintStyle: kText14_Primary,
                                suffixIcon: Container(
                                    width: 15.w,
                                    padding: EdgeInsets.only(right: 5.w),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "%",
                                      style: kText14_Dark,
                                    )),
                              ).allBorder(
                                OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: yrColorPrimary),
                                  borderRadius: BorderRadius.circular(
                                    8.r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 17.w,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Thành tiền",
                              style: kText14Weight400_Dark,
                            ),
                          ),
                          Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: yrColorLight,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.w)),
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              readOnly: true,
                              enabled: false,
                              controller: money,
                              inputFormatters: [
                                CustomTextInputFormatter(3, ".")
                              ],
                              style: kText14_Primary,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                hintText: "0",
                                hintStyle: kText14Weight400_Hint,
                                suffixIcon: Container(
                                    width: 30.w,
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 5.w),
                                    child: Text(
                                      "VNĐ",
                                      style: kText14Weight400_Hint,
                                    )),
                              ).allBorder(
                                OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: yrColorPrimary),
                                  borderRadius: BorderRadius.circular(
                                    8.r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                  child: Visibility(
                      visible: errorMessage != null,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$errorMessage",
                          style: kText14_Error,
                        ),
                      )),
                ),
                // SizedBox(height: 20.h),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hình thức thanh toán",
                    style: kText14_Primary,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      indexPayments = 1;
                    });
                  },
                  child: SizedBox(
                    height: 34.h,
                    child: Row(
                      children: [
                        Radio(
                            value: 1,
                            groupValue: indexPayments,
                            activeColor: yrColorSecondary,
                            onChanged: (int? value) {
                              setState(() {
                                indexPayments = value!;
                              });
                            }),
                        Text(
                          "Thanh toán trực tiếp",
                          style: kText14Weight400_Secondary2,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      indexPayments = 2;
                    });
                  },
                  child: SizedBox(
                    height: 34.h,
                    child: Row(
                      children: [
                        Radio(
                            value: 2,
                            groupValue: indexPayments,
                            activeColor: yrColorSecondary,
                            onChanged: (int? value) {
                              setState(() {
                                indexPayments = value!;
                              });
                            }),
                        Text(
                          "Chuyển khoản ngân hàng",
                          style: kText14Weight400_Secondary2,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 48.h,
                  margin: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: "Hủy",
                          textColor: yrColorPrimary,
                          backgroundColor: yrColorLight,
                          borderSide: const BorderSide(color: yrColorPrimary),
                          onTap: () {
                            _focusNode.unfocus();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      16.horSp,
                      BlocListener<DealDetailBloc, DealDetailState>(
                        listener: (context, state) async {
                          if (state.joinDealStatus is LoadingState) {
                            setState(() {
                              isLoading = true;
                            });
                            AppLoading.show(context);
                          } else if (state.joinDealStatus is SuccessState) {
                            setState(() {
                              isLoading = false;
                            });
                            AppLoading.dismiss(context);

                            AppBloc.dealDetailBloc
                                .initial(widget.deal.id.toString());

                            Navigator.pop(context);
                            Utils.showInfoSnackBar(
                              context,
                              message:
                                  "${isJoined ? "Điều chỉnh" : "Tham gia"} thành công",
                            );
                          } else if (state.joinDealStatus is ErrorState) {
                            setState(() {
                              isLoading = false;
                            });
                            AppLoading.dismiss(context);
                            Utils.showInfoSnackBar(
                              context,
                              message: "Có lỗi xảy ra! Vui lòng kiểm tra lại",
                              isError: false,
                            );
                          } else if (state.joinDealStatus is IdleState) {
                            setState(() {
                              isLoading = false;
                            });
                            AppLoading.dismiss(context);
                          }
                        },
                        listenWhen: (previous, current) =>
                            previous.joinDealStatus != current.joinDealStatus,
                        child: InkWell(
                          onTap: () {
                            var p = double.parse(percent.text);
                            if (p <= 100) {
                              if (indexPayments != 0) {
                                AppBloc.dealDetailBloc.joinDeal(
                                  widget.deal.id.toString(),
                                  percent.text,
                                  indexPayments.toString(),
                                );
                              } else {
                                Utils.showInfoSnackBar(
                                  context,
                                  message: "Bạn phải chọn hình thức thanh toán",
                                  isError: true,
                                );
                              }
                            } else {
                              Utils.showInfoSnackBar(
                                context,
                                message: "Phần trăm tham gia không hợp lệ",
                                isError: true,
                              );
                            }
                          },
                          child: Container(
                            height: 48.h,
                            width: 184.w,
                            decoration: BoxDecoration(
                              color: yrColorPrimary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.w)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isJoined ? "Điều chỉnh" : "Tham gia",
                              style: kText18_Light,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFD1D5DB),
            child: Keyboard(
              onKeyboardTap: _onKeyboardTap,
              textStyle: kText18_Dark,
              numHeight: 50.h,
              numWidth: screenWidth / 3 - 40.w,
              rightButtonFn: () {
                if (percent.text.length > 1) {
                  setState(() {
                    percent.text =
                        percent.text.substring(0, percent.text.length - 1);
                  });
                  double m = double.parse(widget.deal.price!);
                  double p = double.parse(percent.text);
                  setState(() {
                    money.text = ((m * p) / 100).toString();
                    money.text = Tools().convertMoneyToSymbolMoney(money.text)!;
                  });
                } else {
                  setState(() {
                    money.text = "0";
                    percent.text = "";
                  });
                }
              },
              rightIcon: const Icon(
                Icons.backspace_outlined,
                color: yrColorHint,
              ),
              style: KeyboardStyle.STYLE1,
            ),
          ),
          MediaQuery.of(context).viewPadding.bottom.verSp,
        ],
      ),
    );
  }

  _onKeyboardTap(String value) {
    double m = double.parse(widget.deal.price!);
    double p = double.parse(percent.text + value);

    setState(() {
      percent.text = percent.text + value;
      money.text = ((p * m) / 100).toString();
      money.text = Tools().convertMoneyToSymbolMoney(money.text)!;
    });
  }
}
