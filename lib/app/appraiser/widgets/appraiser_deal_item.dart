import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/appraiser/blocs/appraiser_bloc.dart';
import 'package:youreal/app/deal/deal_detail/appraiser_detail_deal.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

class AppraiserDealItem extends StatelessWidget {
  const AppraiserDealItem({
    Key? key,
    required this.deal,
    this.showStatus = true,
  }) : super(key: key);
  final Deal deal;
  final bool showStatus;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: yrColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.w),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () async {
          final reload = await Navigator.pushNamed(
                context,
                AppraiserDetailDeal.id,
                arguments: deal,
              ) ??
              false;

          if (reload == true) {
            context.read<AppraiserBloc>().add(const AppraiserRefreshed());
          }
        },
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal.realEstate?.realEstateTypeName ?? "Đang cập nhật",
                        style: kText14_Primary,
                      ),
                      Text(
                        "Được tạo cách đây ${Utils.getDuration(DateTime.parse(deal.createdTime.replaceFirst("Z", "")), addMore: false)}",
                        style: kText14Weight400_Secondary2,
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                  if (showStatus)
                    Container(
                      height: 35.h,
                      alignment: Alignment.centerRight,
                      child: Text(
                        deal.dealStatusId.index >
                                DealStatus.WaitingApproval.index
                            ? "Đã thẩm định"
                            : "Chưa thẩm định",
                        textAlign: TextAlign.center,
                        style: kText14_Primary,
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/ic_home.svg"),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        deal.realEstate!.acreage1 != null
                            ? "${deal.realEstate!.acreage1!.content} m²"
                            : "Đang cập nhật",
                        style: kText14Weight400_Dark,
                      ),
                    ],
                  ),
                  SizedBox(width: 40.w),
                  kDEAL_ID(deal.id),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/ic_location1.svg",
                    color: yrColorDark,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      deal.realEstate?.fullAddress?.content ?? "Đang cập nhật",
                      style: kText14Weight400_Dark,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
