import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';
import 'package:youreal/app/deal/widgets/card_deal_investing.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';

import 'package:youreal/services/services_api.dart';

import 'total_deal.dart';

class StatisticsByStatus extends StatefulWidget {
  const StatisticsByStatus({Key? key}) : super(key: key);

  @override
  _StatisticsByStatusState createState() => _StatisticsByStatusState();
}

class _StatisticsByStatusState extends State<StatisticsByStatus> {
  final APIServices _services = APIServices();

  int createDealNumber = 0;
  int dealInvestingNumber = 0;
  int dealFinishNumber = 0;
  int dealRejectedNumber = 0;
  @override
  void initState() {
    loadDataStatistics();
    super.initState();
  }

  loadDataStatistics() async {
    final data = await _services.getDataStatistics();
    if (data != null) {
      createDealNumber = data.created.numberWaitingApprovalDeal +
          data.created.numberWaitingVerificationDeal;
      dealInvestingNumber = data.created.numberFinishedInvestorsDeal +
          data.created.numberWaitingMainInvestorDeal +
          data.created.numberWaitingSubInvestorDeal;
      dealFinishNumber = data.created.numberDoneDeal;
      dealRejectedNumber = data.created.numberRejectedDeal;
      setState(() {});
    }
  }

  Future<List<Deal>> loadDealNewCreate() async {
    List<Deal> list = [];
    final deals = await _services.getDealOfUser(
        page: 1,
        sessionId: 0,
        pageSize: createDealNumber,
        statusIds: [
          DealStatus.Draft.index,
          DealStatus.WaitingApproval.index,
          DealStatus.WaitingVerification.index
        ]);
    list.addAll(deals);
    return list;
  }

  Future<List<Deal>> loadDealCancelled() async {
    List<Deal> list = [];
    final deals = await _services.getDealOfUser(
        page: 1,
        sessionId: 0,
        pageSize: dealRejectedNumber,
        statusIds: [DealStatus.Rejected.index]);
    list.addAll(deals);
    return list;
  }

  Future<List<Deal>> loadDealInvested() async {
    List<Deal> list = [];
    final deals = await _services.getDealOfUser(
        page: 1,
        sessionId: 0,
        pageSize: dealInvestingNumber,
        statusIds: [
          DealStatus.WaitingMainInvestor.index,
          DealStatus.WaitingSubInvestor.index,
          DealStatus.FinishedInvestors.index
        ]);
    list.addAll(deals);
    return list;
  }

  Future<List<Deal>> loadDealFinish() async {
    List<Deal> list = [];
    final deals = await _services.getDealOfUser(
        page: 1,
        sessionId: 0,
        pageSize: dealInvestingNumber,
        statusIds: [
          DealStatus.Done.index,
        ]);
    list.addAll(deals);
    return list;
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
    // loadInit();
    return SizedBox(
      height: 134.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatisticCircle(
            number: createDealNumber,
            title: "Deal\nkhởi tạo",
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                TotalDeal.id,
                arguments: TotalDealArgs(
                  title: "DS deal khởi tạo",
                  itemBuilder: (Deal deal) {
                    return _itemTotalDeal(deal);
                  },
                  loadData:
                      (int page, int size, int sessionId, int lastId) async {
                    var list = await loadDealNewCreate();
                    return list;
                  },
                ),
              );
            },
          ),
          StatisticCircle(
            number: dealInvestingNumber,
            title: "Deal\nđược đầu tư",
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                TotalDeal.id,
                arguments: TotalDealArgs(
                  title: "DS deal đang được đầu tư",
                  itemBuilder: (Deal deal) {
                    return _itemTotalDeal(deal);
                  },
                  loadData:
                      (int page, int size, int sessionId, int lastId) async {
                    var list = await loadDealInvested();
                    return list;
                  },
                ),
              );
            },
          ),
          StatisticCircle(
            number: dealFinishNumber,
            title: "Deal\nhoàn tất",
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                TotalDeal.id,
                arguments: TotalDealArgs(
                  title: "DS deal đã hoàn tất",
                  itemBuilder: (Deal deal) {
                    return _itemTotalDeal(deal);
                  },
                  loadData:
                      (int page, int size, int sessionId, int lastId) async {
                    var list = await loadDealFinish();
                    return list;
                  },
                ),
              );
            },
          ),
          StatisticCircle(
            number: dealRejectedNumber,
            title: "Deal\ntừ chối",
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                TotalDeal.id,
                arguments: TotalDealArgs(
                  title: "DS deal từ chối",
                  itemBuilder: (Deal deal) {
                    return _itemTotalDeal(deal);
                  },
                  loadData:
                      (int page, int size, int sessionId, int lastId) async {
                    var list = await loadDealCancelled();
                    return list;
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StatisticCircle extends StatelessWidget {
  const StatisticCircle({
    Key? key,
    required this.number,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final int number;
  final String title;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          children: [
            Container(
              height: 84.h,
              width: 84.h,
              decoration: const BoxDecoration(
                  color: yrColorSecondary, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                "$number",
                style: kText32_Light,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: kText14Weight400_Light,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
