import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';
import 'package:youreal/app/deal/widgets/card_deal_investing.dart';
import 'package:youreal/app/my_deal/total_deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';

class MainInvestor extends StatefulWidget {
  const MainInvestor({Key? key}) : super(key: key);

  @override
  _MainInvestorState createState() => _MainInvestorState();
}

class _MainInvestorState extends State<MainInvestor> {
  final APIServices _services = APIServices();

  int totalDealJoinNumber = 0;
  int dealInvestingNumber = 0;
  int dealFinishNumber = 0;
  @override
  void initState() {
    loadDataStatistics();
    super.initState();
  }

  loadDataStatistics() async {
    final data = await _services.getDataStatistics();
    if (data != null) {
      dealInvestingNumber = data.joined.numberFinishedInvestorsDeal;
      dealFinishNumber = data.joined.numberDoneDeal;
      totalDealJoinNumber = dealInvestingNumber + dealFinishNumber;
      setState(() {});
    }
  }

  Future<List<Deal>> loadDealInvested() async {
    List<Deal> list = [];
    final deals = await _services.getListDealInvesting(
            page: 1,
            sessionId: 0,
            pSize: dealFinishNumber,
            statusIds: [DealStatus.Done.index]) ??
        [];
    for (var deal in deals) {
      list.add(deal);
    }
    return list;
  }

  Future<List<Deal>> loadDealInvesting() async {
    List<Deal> list = [];
    final deals = await _services.getListDealInvesting(
            page: 1,
            sessionId: 0,
            pSize: 10,
            statusIds: [DealStatus.FinishedInvestors.index]) ??
        [];
    for (var deal in deals) {
      list.add(deal);
    }
    return list;
  }

  totalPrice() async {
    final deals = await _services.getListDealInvesting(
            page: 1, sessionId: 0, pSize: totalDealJoinNumber) ??
        [];
    double totalPrice = 0;
    for (var item in deals) {
      totalPrice = totalPrice + double.parse(item.price!);
    }

    return totalPrice;
  }

  _itemTotalDeal(Deal deal) {
    return FutureBuilder(
        future: APIServices().getDealById(dealId: deal.id.toString()),
        builder: (context, AsyncSnapshot<Deal?> snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          } else {
            Deal data = snapshot.data!;
            return CardDealInvesting(
                deal: data,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    DealTracking.id,
                    arguments: data,
                  );
                });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 208.w,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    TotalDeal.id,
                    arguments: TotalDealArgs(
                      title: "Tổng dự án đầu tư",
                      itemBuilder: (Deal deal) {
                        return _itemTotalDeal(deal);
                      },
                      loadData: (int page, int size, int sessionId,
                          int lastId) async {
                        var list = await _services.getListDealInvesting(
                                page: 1, sessionId: 0, pSize: 10) ??
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
                      Text(
                        '$totalDealJoinNumber',
                        style: kText18_Light,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    TotalDeal.id,
                    arguments: TotalDealArgs(
                      title: "DS deal đã hoàn tất",
                      itemBuilder: (Deal deal) {
                        return _itemTotalDeal(deal);
                      },
                      loadData: (int page, int size, int sessionId,
                          int lastId) async {
                        var list = await loadDealInvested();
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
                        "Đã hoàn tất:",
                        style: kText14Weight400_Light,
                      ),
                      Text(
                        "$dealFinishNumber",
                        style: kText18_Light,
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
                      title: "DS deal đang đầu tư",
                      itemBuilder: (Deal deal) {
                        return _itemTotalDeal(deal);
                      },
                      loadData: (int page, int size, int sessionId,
                          int lastId) async {
                        var list = await loadDealInvesting();
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
                        "assets/icons/ic_paid.svg",
                        width: 32.h,
                        height: 32.h,
                      ),
                      Text(
                        "Đang đầu tư:",
                        style: kText14Weight400_Light,
                      ),
                      Text(
                        "$dealInvestingNumber",
                        style: kText18_Light,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          16.verSp,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng vốn đầu tư:",
                style: kText14Weight400_Primary,
              ),
              FutureBuilder(
                future: totalPrice(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Text(
                      "${Tools().convertMoneyToSymbolMoney(snapshot.data.toString())} VNĐ",
                      style: kText14_Accent,
                    );
                  } else {
                    return SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator());
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
