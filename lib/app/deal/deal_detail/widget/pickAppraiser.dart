import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/deal_detail/blocs/deal_detail_bloc.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/widget/app_loading.dart';

import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/view_models/app_bloc.dart';

import 'popup_quesion.dart';

class PickAppraiserBottomSheet extends StatefulWidget {
  final Deal deal;

  const PickAppraiserBottomSheet({
    Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  State<PickAppraiserBottomSheet> createState() =>
      _PickAppraiserBottomSheetState();
}

class _PickAppraiserBottomSheetState extends State<PickAppraiserBottomSheet> {
  List<Account> listAppraised = [];
  Account? leaderSelected;
  @override
  void initState() {
    loadAppreaisers();
    super.initState();
  }

  final APIServices _services = APIServices();

  loadAppreaisers() async {
    listAppraised = await _services.getListAppraiser();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: yrColorLight,
                  borderRadius: BorderRadius.circular(16.w),
                ),
                width: 1.sw,
                child: BlocListener<DealDetailBloc, DealDetailState>(
                  listener: (context, state) async {
                    if (state.assignAppraiserStatus is LoadingState) {
                      AppLoading.show(context);
                    } else if (state.assignAppraiserStatus is SuccessState) {
                      AppLoading.dismiss(context);
                      AppBloc.dealDetailBloc.initial(widget.deal.id.toString());
                      await Utils.showInfoSnackBar(
                        context,
                        message:
                            "Bạn đã chỉ định ${leaderSelected!.name} thẩm định deal #${widget.deal.id}",
                      );
                    } else if (state.assignAppraiserStatus is ErrorState) {
                      AppLoading.dismiss(context);
                      Utils.showInfoSnackBar(
                        context,
                        message: "Có lỗi xảy ra! Vui lòng kiểm tra lại",
                        isError: true,
                      );
                    } else if (state is IdleState) {
                      AppLoading.dismiss(context);
                    }
                  },
                  listenWhen: ((previous, current) =>
                      previous.assignAppraiserStatus !=
                      current.assignAppraiserStatus),
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      final isFirst = index == 0;
                      final isLast = index == listAppraised.length - 1;
                      final borderRadius = BorderRadius.vertical(
                        top: isFirst ? Radius.circular(16.w) : Radius.zero,
                        bottom: isLast ? Radius.circular(16.w) : Radius.zero,
                      );
                      return Material(
                        color: Colors.transparent,
                        shape:
                            RoundedRectangleBorder(borderRadius: borderRadius),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () async {
                            final result = await showDialog(
                                  context: context,
                                  builder: (context) => PopupQuesion(
                                    title:
                                        "Deal #${widget.deal.id} sẽ được gửi cho thẩm định viên\n${listAppraised[index].name!}",
                                    textOk: "Gửi",
                                  ),
                                ) ??
                                false;

                            if (result) {
                              setState(() {
                                leaderSelected = listAppraised[index];
                              });
                              AppBloc.dealDetailBloc.assignAppraiser(
                                  widget.deal.realEstateId.toString(),
                                  listAppraised[index].id.toString());
                            }
                          },
                          splashColor: yrColorPrimary.withOpacity(0.2),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Text(
                              listAppraised[index].name!,
                              style: kText14Weight400_Primary,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: listAppraised.length,
                    separatorBuilder: (_, __) => const Divider(
                      thickness: 1,
                      color: yrColorGrey2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              PrimaryButton(
                text: "Hủy",
                onTap: () {
                  Navigator.pop(context);
                },
                minWidth: 1.sw,
                textColor: yrColorPrimary,
                backgroundColor: yrColorLight,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ],
      ),
    );
  }
}
