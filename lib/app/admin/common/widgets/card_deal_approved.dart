import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';

import '../../../deal/deal_detail/detail_deal.dart';

class CardDealApproved extends StatelessWidget {
  const CardDealApproved({
    Key? key,
    required this.item,
    this.showStatus = false,
  }) : super(key: key);

  final Deal item;
  final bool showStatus;
  @override
  Widget build(BuildContext context) {
    final services = APIServices();

    return Container(
      decoration: BoxDecoration(
        color: yrColorLight,
        borderRadius: BorderRadius.circular(8.w),
      ),
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(4.w),
      height: 161.w,
      width: 1.sw,
      child: Row(
        children: [
          item.realEstate!.realEstateImages != null
              ? SizedBox(
                  width: 142.w,
                  height: double.infinity,
                  child: getImage(
                    item.realEstate!.realEstateImages!.content!
                        .split(',')
                        .first,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(8),
                  ),
                )
              : SizedBox(
                  width: 142.w,
                  height: double.infinity,
                  child: getImage(
                    "image_card.png",
                    fit: BoxFit.fill,
                    isAsset: true,
                  ),
                ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   isAppraised ? "Đã thẩm định" : "Chưa thẩm định",
                //   style: isAppraised
                //       ? kText14Weight400_Success
                //       : kText14Weight400_Warning,
                // ),

                Text(
                  item.realEstate?.realEstateTypeName ?? "Đang cập nhật",
                  style: kText14_Primary,
                ),

                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/ic_location1.svg",
                      color: yrColorDark,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        item.realEstate?.fullAddress?.content ??
                            "Đang cập nhật",
                        style: kText14Weight400_Dark,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SvgPicture.asset("assets/icons/ic_home.svg"),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      item.realEstate!.acreage1 != null
                          ? "${item.realEstate!.acreage1!.content} m²"
                          : "Đang cập nhật",
                      style: kText14Weight400_Dark,
                    ),
                    const Spacer(),

                    // Icon(
                    //   Icons.visibility_outlined,
                    //   color: yrColorDark,
                    //   size: 20.h,
                    // ),
                    // Text(
                    //   " 0 người quan tâm",
                    //   style: kText14Weight400_Dark,
                    // ),
                    kDEAL_ID(item.id),
                  ],
                ),

                if (showStatus &&
                    item.events != null &&
                    item.events!.isNotEmpty)
                  Text(
                    item.events!.first.eventName!,
                    style: kText14Weight400_Accent,
                  ),

                PrimaryButton(
                  text: "Xem chi tiết",
                  onTap: () async {
                    Deal? deal = await services.getDealById(dealId: item.id);
                    if (deal == null) return;

                    if (deal.dealStatusId.index >
                        DealStatus.WaitingApproval.index) {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(DealTracking.id, arguments: deal);
                    } else {
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed(
                        DetailDeal.id,
                        arguments: DetailDealArs(
                          deal: deal,
                        ),
                      );
                    }
                  },
                  verticalPadding: 8.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
