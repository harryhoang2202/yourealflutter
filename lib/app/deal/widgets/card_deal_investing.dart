import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

import 'item_my_deal.dart';

class CardDealInvesting extends StatelessWidget {
  final Deal deal;
  final Function()? onTap;

  const CardDealInvesting({
    Key? key,
    required this.deal,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: yrColorLight,
      borderRadius: BorderRadius.circular(8.w),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 160.h,
          margin: EdgeInsets.symmetric(vertical: 4.h),
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              SizedBox(
                height: 156.h,
                width: 134.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.w),
                  child: deal.realEstate!.realEstateImages != null
                      ? SizedBox(
                          height: double.infinity,
                          child: getImage(
                            deal.realEstate!.realEstateImages!.content!
                                .split(',')
                                .first,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )
                      : SizedBox(
                          height: double.infinity,
                          child: getImage(
                            "image_card.png",
                            fit: BoxFit.fill,
                            isAsset: true,
                          ),
                        ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 12.w, right: 6.w, top: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deal.realEstate != null
                                    ? deal.realEstate!.realEstateTypeName!
                                        .toString()
                                    : "",
                                style: kText14_Primary,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          StatusDeal(
                            deal: deal,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20.w,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                                "assets/icons/ic_location1.svg"),
                          ),
                          8.horSp,
                          Expanded(
                            child: Text(
                              deal.realEstate?.address?.fullAddress != null
                                  ? deal.realEstate!.address!.fullAddress!
                                      .toString()
                                  : "Đang cập nhật",
                              style: kText14_Primary,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20.w,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.home_outlined,
                                  color: yrColorDark,
                                  size: 20.h,
                                ),
                              ),
                              8.horSp,
                              Text(
                                deal.realEstate!.acreage1 != null
                                    ? "${deal.realEstate!.acreage1!.content}m²"
                                    : "Đang cập nhật",
                                style: kText14Weight400_Dark,
                              ),
                            ],
                          ),
                          kDEAL_ID(deal.id),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${Tools().convertMoneyToSymbolMoney(deal.price!)} VNĐ",
                              style: kText14_Error,
                            ),
                          ),
                          SvgPicture.asset(
                            getIcon("ic_news.svg"),
                            color: yrColorPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
