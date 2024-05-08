import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/deal/blocs/deal_bloc.dart';
import 'package:youreal/app/deal/create_deal/views/create_deal.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';

class ItemMyDeal extends StatelessWidget {
  final Deal deal;
  final Function() onTap;
  const ItemMyDeal({Key? key, required this.deal, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    APIServices services = APIServices();

    return BlocBuilder<DealBloc, DealState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.h),
          child: Material(
            color: yrColorLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.h),
            ),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () async {
                if (deal.dealStatusId == DealStatus.Draft) {
                  Navigator.pushNamed(
                    context,
                    CreateDealScreen.id,
                    arguments: CreateDealArgs(
                      editToBuy: false,
                      draftDeal: deal,
                    ),
                  );
                } else {
                  onTap();
                }
              },
              child: Container(
                width: screenWidth,
                constraints: BoxConstraints(minHeight: 90.h),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal.user != null
                                ? "${deal.user!.firstName} ${deal.user!.lastName}"
                                : "",
                            style: kText14_Primary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            deal.realEstate != null
                                ? deal.realEstate!.realEstateTypeName!
                                : "",
                            style: kText14Weight400_Dark,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_location1.svg",
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Flexible(
                                child: Text(
                                  deal.realEstate!.address != null
                                      ? "${deal.realEstate!.address!.fullAddress}"
                                      : "Đang cập nhật",
                                  style: kText14Weight400_Dark,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              getDate(deal.createdTime),
                              style: kText14Weight400_Hint,
                            ),
                          ),
                          kDEAL_ID(deal.id),
                          StatusDeal(deal: deal)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StatusDeal extends StatelessWidget {
  final Deal deal;
  const StatusDeal({Key? key, required this.deal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      alignment: AlignmentDirectional.bottomEnd,
      child: Builder(builder: (context) {
        switch (deal.dealStatusId) {
          case DealStatus.Draft:
          case DealStatus.WaitingVerification:
          case DealStatus.WaitingApproval:
            return Text(
              deal.dealStatusName!.toString(),
              textAlign: TextAlign.center,
              style: kText14_Primary,
            );

          case DealStatus.WaitingMainInvestor:
          case DealStatus.WaitingSubInvestor:
          case DealStatus.FinishedInvestors:
            return Text(
              deal.dealStatusName!.toString(),
              textAlign: TextAlign.center,
              style: kText14_Accent,
            );

          default:
            return Text(
              deal.dealStatusName!.toString(),
              textAlign: TextAlign.center,
              style: kText14_Error,
            );
        }
      }),
    );
  }
}
