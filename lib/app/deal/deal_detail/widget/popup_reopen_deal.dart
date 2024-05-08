import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/deal_detail/blocs/deal_detail_bloc.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/view_models/app_bloc.dart';

class PopupReOpenDeal extends StatefulWidget {
  final String title;
  final String textOk;
  final String textCancel;
  final String dealId;
  const PopupReOpenDeal(
      {Key? key,
      required this.title,
      required this.dealId,
      this.textOk = "Đồng ý",
      this.textCancel = "Hủy"})
      : super(key: key);

  @override
  State<PopupReOpenDeal> createState() => _PopupReOpenDealState();
}

class _PopupReOpenDealState extends State<PopupReOpenDeal> {
  DateTime date = DateTime.now();
  TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);

  TextEditingController dateSelected = TextEditingController();
  TextEditingController timeSelected = TextEditingController();
  TextEditingController reason = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void initState() {
    super.initState();

    setState(() {
      dateSelected.text = date.ddMMyyyy;

      timeSelected.text = "${time.hour}:${time.minute}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DealDetailBloc, DealDetailState>(
      listener: (context, state) {
        if (state.reOpenStatus is LoadingState) {
          setState(() {
            loading = true;
          });
        } else if (state.reOpenStatus is SuccessState) {
          setState(() {
            loading = true;
          });
          Navigator.pop(context, true);
        } else {
          setState(() {
            loading = false;
          });
        }
      },
      listenWhen: ((previous, current) =>
          previous.reOpenStatus != current.reOpenStatus),
      child: Stack(
        children: [
          AlertDialog(
            backgroundColor: yrColorLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.h)),
            insetPadding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            contentPadding: EdgeInsets.zero,
            content: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                alignment: Alignment.center,
                height: screenHeight / 2 - 50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: kText18_Primary,
                    ),
                    50.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              var result = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2028),
                                helpText: 'Chọn ngày',
                                cancelText: 'Hủy',
                                confirmText: 'OK',
                              );
                              if (result != null) {
                                setState(() {
                                  date = result;
                                  dateSelected.text = result.ddMMyyyy;
                                });
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Ngày hết hạn",
                                    style: kText14_Primary,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: yrColorLight,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.w)),
                                  ),
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.number,
                                    controller: dateSelected,
                                    readOnly: true,
                                    enabled: false,
                                    validator: ((value) {
                                      if (value != null && value.isEmpty) {
                                        return "Bạn cần chọn thời gian gia hạn!";
                                      }
                                      return null;
                                    }),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: kText14_Primary,
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10.h),
                                    ).allBorder(
                                      OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: yrColorPrimary),
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
                        ),
                        SizedBox(
                          width: 17.w,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              var result = await showTimePicker(
                                context: context,
                                helpText: 'Chọn giờ',
                                cancelText: 'Hủy',
                                confirmText: 'OK',
                                initialTime: TimeOfDay.now(),
                              );
                              if (result != null) {
                                setState(() {
                                  time = result;
                                  timeSelected.text =
                                      "${result.hour}:${result.minute}";
                                });
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Giờ hết hạn",
                                    style: kText14_Primary,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: yrColorLight,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.w)),
                                  ),
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    readOnly: true,
                                    enabled: false,
                                    controller: timeSelected,
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return "Bạn cần chọn thời gian gia hạn!";
                                      }

                                      return null;
                                    },
                                    style: kText14_Primary,
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10.h),
                                    ).allBorder(
                                      OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: yrColorPrimary),
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
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Lý do gia hạn",
                            style: kText14_Primary,
                          ),
                        ),
                        TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: reason,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: kText14_Primary,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Bạn cần nhập lý do gia hạn!";
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10.h),
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
                      ],
                    )
                  ],
                ),
              ),
            ),
            buttonPadding: EdgeInsets.zero,
            actions: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: widget.textCancel,
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        borderRadius: 16,
                        backgroundColor: yrColorLight,
                        textColor: yrColorPrimary,
                        borderSide: const BorderSide(color: yrColorPrimary),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: PrimaryButton(
                        text: widget.textOk,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            var dt = date.add(Duration(
                                hours: time.hour, minutes: time.minute));
                            var res = dt.millisecondsSinceEpoch -
                                DateTime.now().millisecondsSinceEpoch;
                            if (res > 0) {
                              AppBloc.dealDetailBloc
                                  .reOpenDeal(widget.dealId, res, reason.tText);
                            } else {
                              await Utils.showInfoSnackBar(context,
                                  message:
                                      "Thời gian gia hạn phải lớn hơi thời gian hiện tại!!!",
                                  isError: true);
                            }
                          }
                        },
                        borderRadius: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (loading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
