import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:youreal/app/appraiser/widgets/appraiser_deal_item.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/my_deal/total_deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';

class Appraisal extends StatefulWidget {
  const Appraisal({Key? key}) : super(key: key);

  @override
  _AppraisalState createState() => _AppraisalState();
}

class _AppraisalState extends State<Appraisal> {
  final APIServices _services = APIServices();
  @override
  void initState() {
    super.initState();
  }

  loadNumberOfListDealAppraisal(List<int> statusId) async {
    final deals =
        await _services.getDealAssignedToValuate(statusIds: statusId) ?? [];
    return deals.length;
  }

  totalPrice() async {
    final deals = await _services.getDealAssignedToValuate(statusIds: []) ?? [];
    double totalPrice = 0;
    for (var item in deals) {
      totalPrice = totalPrice + double.parse(item.price!);
    }

    return totalPrice;
  }

  biggestPrice() async {
    final deals = await _services.getDealAssignedToValuate(statusIds: []) ?? [];
    deals.sort((a, b) {
      double tempA = double.parse(a.price!);
      double tempB = double.parse(b.price!);
      if (tempA > tempB) {
        return -1;
      } else if (tempA < tempB) {
        return 1;
      } else {
        return 0;
      }
    });

    return deals.first.price;
  }

  _itemTotalDeal(Deal deal, {bool showStatus = true}) {
    return FutureBuilder(
        future: APIServices().getDealById(dealId: deal.id.toString()),
        builder: (context, AsyncSnapshot<Deal?> snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          } else {
            Deal data = snapshot.data!;
            return AppraiserDealItem(
              deal: data,
              showStatus: showStatus,
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return checkRole(context, RolesType.Appraiser)
        ? Container(
            height: 208.h,
            decoration: BoxDecoration(
              color: yrColorLight,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.h),
                bottomRight: Radius.circular(8.h),
                bottomLeft: Radius.circular(8.h),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 106.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            TotalDeal.id,
                            arguments: TotalDealArgs(
                              title: "Tổng dự án thẩm định",
                              itemBuilder: (Deal deal) {
                                return _itemTotalDeal(deal);
                              },
                              loadData: (int page, int size, int sessionId,
                                  int lastId) async {
                                var list = await _services
                                        .getDealAssignedToValuate(
                                            statusIds: []) ??
                                    [];
                                return list;
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 106.h,
                          width: 112.w,
                          decoration: BoxDecoration(
                              color: yrColorPrimary,
                              borderRadius: BorderRadius.circular(8.w)),
                          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_total_deal.svg",
                                width: 32.h,
                                height: 32.h,
                              ),
                              Text(
                                "Tổng dự án:",
                                style: kText14Weight400_Light,
                              ),
                              FutureBuilder(
                                future: loadNumberOfListDealAppraisal([]),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      "${snapshot.data}",
                                      style: kText18_Light,
                                    );
                                  } else {
                                    return SizedBox(
                                        height: 20.h,
                                        width: 20.h,
                                        child:
                                            const CircularProgressIndicator());
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            TotalDeal.id,
                            arguments: TotalDealArgs(
                              title: "DS deal đã thẩm định",
                              itemBuilder: (Deal deal) {
                                return _itemTotalDeal(deal, showStatus: false);
                              },
                              loadData: (int page, int size, int sessionId,
                                  int lastId) async {
                                var list = await _services
                                        .getDealAssignedToValuate(
                                            statusIds: [3]) ??
                                    [];
                                return list;
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 106.h,
                          width: 112.w,
                          decoration: BoxDecoration(
                              color: yrColorSuccess,
                              borderRadius: BorderRadius.circular(8.w)),
                          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_appraised.svg",
                                width: 32.h,
                                height: 32.h,
                              ),
                              Text(
                                "Đã thẩm định:",
                                style: kText14Weight400_Light,
                              ),
                              FutureBuilder(
                                future: loadNumberOfListDealAppraisal([3]),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      "${snapshot.data}",
                                      style: kText18_Light,
                                    );
                                  } else {
                                    return SizedBox(
                                        height: 20.h,
                                        width: 20.h,
                                        child:
                                            const CircularProgressIndicator());
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            TotalDeal.id,
                            arguments: TotalDealArgs(
                              title: "DS deal đang thẩm định",
                              itemBuilder: (Deal deal) {
                                return _itemTotalDeal(deal, showStatus: false);
                              },
                              loadData: (int page, int size, int sessionId,
                                  int lastId) async {
                                var list = await _services
                                        .getDealAssignedToValuate(
                                            statusIds: [1]) ??
                                    [];
                                return list;
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 106.h,
                          width: 112.w,
                          decoration: BoxDecoration(
                              color: yrColorError,
                              borderRadius: BorderRadius.circular(8.w)),
                          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_appraising.svg",
                                width: 32.h,
                                height: 32.h,
                              ),
                              Text(
                                "Đang thẩm định:",
                                style: kText14Weight400_Light,
                              ),
                              FutureBuilder(
                                future: loadNumberOfListDealAppraisal([1]),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      "${snapshot.data}",
                                      style: kText18_Light,
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 20.h,
                                      width: 20.h,
                                      child: const CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Dự án lớn nhất:",
                //       style: kText14Weight400_Primary,
                //     ),
                //     FutureBuilder(
                //       future: biggestPrice(),
                //       builder: (context, snapshot) {
                //         if (snapshot.data != null) {
                //           return Text(
                //             "${Tools().convertMoneyToSymbolMoney(snapshot.data.toString())} VNĐ",
                //             style: kText14_Accent,
                //           );
                //         } else {
                //           return SizedBox(
                //               height: 20.h,
                //               width: 20.h,
                //               child: const CircularProgressIndicator());
                //         }
                //       },
                //     ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Tổng dự án:",
                //       style: kText14Weight400_Primary,
                //     ),
                //     FutureBuilder(
                //       future: totalPrice(),
                //       builder: (context, snapshot) {
                //         if (snapshot.data != null) {
                //           return Text(
                //             "${Tools().convertMoneyToSymbolMoney(snapshot.data.toString())} VNĐ",
                //             style: kText14_Accent,
                //           );
                //         } else {
                //           return SizedBox(
                //               height: 20.h,
                //               width: 20.h,
                //               child: const CircularProgressIndicator());
                //         }
                //       },
                //     ),
                //   ],
                // ),

                // Container(
                //     height: 15.h,
                //     alignment: Alignment.centerRight,
                //     child:
                //         Text("Xem chi tiết", style: kText14Weight400_Primary))
              ],
            ),
          )
        : Container(
            height: 69.h,
            color: yrColorLight,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Center(
              child: Text(
                "Bạn không phải là thẩm định viên",
                style: kText14Weight400_Primary,
              ),
            ),
          );
  }
}
