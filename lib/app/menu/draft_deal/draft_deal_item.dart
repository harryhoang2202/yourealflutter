import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/confirm_dialog.dart';
import 'package:youreal/app/deal/create_deal/views/create_deal.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/utils/blocs/lazy_load/lazy_load_bloc.dart';
// import 'package:youreal/view_models/utils/lazy_loading/lazy_loading_bloc.dart';

class DraftDealItem extends StatelessWidget {
  const DraftDealItem({Key? key, required this.item}) : super(key: key);
  final Deal item;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: yrColorLight,
        borderRadius: BorderRadius.circular(15.h),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Deal #${item.id}",
                style: kText18_Primary,
              ),
              Container(
                height: 26.h,
                width: 30.h,
                decoration: const BoxDecoration(
                    color: yrColorLight, shape: BoxShape.circle),
                child: GestureDetector(
                  onTap: () async {
                    if (item.id == null) return;

                    bool result = await showAnimatedDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => const ConfirmDialog(
                            title: 'Bạn có muốn xóa deal nháp ?',
                          ),
                          animationType: DialogTransitionType.slideFromTop,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ) ??
                        false;
                    if (result) {
                      bool deleteResult =
                          await APIServices().deleteDeal(dealId: item.id);
                      if (deleteResult) {
                        context
                            .read<LazyLoadBloc<Deal>>()
                            .add(LazyLoadEvent.initial());
                      }
                    }
                  },
                  child: Icon(
                    Icons.clear,
                    color: yrColorHint,
                    size: 26.h,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "Được tạo cách đây ${Utils.getDuration(DateTime.parse(item.createdTime))}",
            style: kText14Weight400_Secondary2,
          ),
          SizedBox(height: 12.h),
          Text(
            item.realEstate?.note?.content ?? "",
            style: kText14Weight400_Dark,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () async {
                await Navigator.of(context, rootNavigator: true).pushNamed(
                  CreateDealScreen.id,
                  arguments: CreateDealArgs(
                    editToBuy: false,
                    draftDeal: item,
                  ),
                );
                BlocProvider.of<LazyLoadBloc<Deal>>(context, listen: false)
                    .add(LazyLoadRefreshed());
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: yrColorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                fixedSize: Size(147.w, 40.h),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                "Tiếp tục".toUpperCase(),
                style: kText14_Light,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
