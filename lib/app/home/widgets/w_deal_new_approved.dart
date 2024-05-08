import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/widgets/card_deal_new_approved.dart';
import 'package:youreal/app/home/blocs/home_bloc.dart';
import 'package:youreal/app/home/services/home_service.dart';
import 'package:youreal/app/my_deal/total_deal.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/services/services_api.dart';

class WDealNewApproved extends StatelessWidget {
  const WDealNewApproved({super.key});
  _itemTotalDeal(Deal deal) {
    return FutureBuilder(
        future: APIServices().getDealById(dealId: deal.id.toString()),
        builder: (context, AsyncSnapshot<Deal?> snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          } else {
            Deal data = snapshot.data!;
            return CardDealNewApproved(
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
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Deal mới",
                  style: kText28_Light,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    TotalDeal.id,
                    arguments: TotalDealArgs(
                      title: "Deal mới",
                      itemBuilder: (Deal deal) {
                        return _itemTotalDeal(deal);
                      },
                      loadData: (int page, int size, int sessionId,
                          int lastId) async {
                        var list = await HomeService.getListDealNew(
                          page: page,
                          sessionId: sessionId,
                          pSize: size,
                        );
                        return list!;
                      },
                    ),
                  );
                },
                child: Text(
                  "Xem tất cả",
                  style: kText14Weight400_Light.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          BlocSelector<HomeBloc, HomeState, List<Deal>>(
            selector: (state) {
              return state.newDealState.data;
            },
            builder: (context, data) {
              return BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.initialStatus == const LoadingState()) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.newDealState.data.isEmpty) {
                    return Container(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Center(
                          child: Text(
                        "Không có dữ liệu",
                        style: kText14_Light,
                      )),
                    );
                  }
                  return SizedBox(
                    height: data.length * (168.h + 8.h),
                    child: ListView.separated(
                      itemCount: data.length,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Deal item = data[index];
                        return CardDealNewApproved(
                          deal: item,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              DealTracking.id,
                              arguments: item,
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, __) => 8.verSp,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
