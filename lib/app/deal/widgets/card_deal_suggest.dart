import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

class CardDealSuggest extends StatelessWidget {
  final Deal deal;
  final Function()? onTap;

  const CardDealSuggest({
    Key? key,
    required this.deal,
    required this.onTap,
  }) : super(key: key);

  final bool isHasImage = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 332.h,
      width: 275.w,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
          color: yrColorLight, borderRadius: BorderRadius.circular(8.h)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 158.h,
            width: 267.w,
            decoration: BoxDecoration(
              color: yrColorPrimary,
              borderRadius: BorderRadius.circular(12.h),
            ),
            child: deal.realEstate!.realEstateImages != null
                ? SizedBox(
                    width: 142.w,
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
                    width: 142.w,
                    height: double.infinity,
                    child: getImage(
                      "image_card.png",
                      fit: BoxFit.fill,
                      isAsset: true,
                    ),
                  ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Text(
                      deal.realEstate != null
                          ? deal.realEstate!.realEstateTypeName!.toString()
                          : "",
                      style: kText14Weight400_Dark,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  SizedBox(
                    height: 35.h,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_location1.svg"),
                        SizedBox(
                          width: 4.w,
                        ),
                        Expanded(
                          child: Container(
                              height: 35.h,
                              width: 160.w,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                deal.realEstate!.address != null
                                    ? "${deal.realEstate!.address!.district}, "
                                        "${deal.realEstate!.address!.province}"
                                    : "Đang cập nhật",
                                style: kText14Weight400_Dark,
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/ic_home.svg"),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            deal.realEstate!.acreage1 != null
                                ? "${deal.realEstate!.acreage1!.content} m²"
                                : "Đang cập nhật",
                            style: kText14Weight400_Dark,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            color: yrColorDark,
                            size: 20.h,
                          ),
                          Text(
                            " 0 người quan tâm",
                            style: kText14Weight400_Dark,
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "${Tools().convertMoneyToSymbolMoney(deal.price!)} VNĐ",
                    style: kText14_Error,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        kDEAL_ID(deal.id),
                        OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: yrColorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                          ),
                          child: Text(
                            "Xem chi tiết",
                            style: kText14_Light,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class _WaitingWidget extends StatelessWidget {
//   const _WaitingWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: BlocConsumer<DealBloc, DealState>(
//         listener: (context, state) {
//           if (state is! LoadingDetailDealState) Navigator.pop(context);
//         },
//         builder: (context, state) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }
