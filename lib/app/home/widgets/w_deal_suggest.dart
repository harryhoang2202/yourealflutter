import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/widgets/card_deal_investing.dart';
import 'package:youreal/app/deal/widgets/card_deal_suggest.dart';
import 'package:youreal/app/home/blocs/home_bloc.dart';
import 'package:youreal/app/home/services/home_service.dart';
import 'package:youreal/app/my_deal/total_deal.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/services/services_api.dart';

class WDealSuggest extends StatelessWidget {
  const WDealSuggest({super.key});
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
    return BlocSelector<HomeBloc, HomeState, List<Deal>>(
      selector: (state) {
        return state.suggestDealState.data;
      },
      builder: (context, data) {
        return Container(
          padding: EdgeInsets.only(left: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Deal đề xuất",
                      style: kText28_Light,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        TotalDeal.id,
                        arguments: TotalDealArgs(
                          title: "DS deal đề xuất",
                          itemBuilder: (Deal deal) {
                            return _itemTotalDeal(deal);
                          },
                          loadData: (int page, int size, int sessionId,
                              int lastId) async {
                            var list = await HomeService.getListDealSuggest(
                              page: page,
                              sessionId: sessionId,
                            );
                            return list!;
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Text(
                        "Xem tất cả",
                        style: kText14Weight400_Light.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.initialStatus == const LoadingState()) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.suggestDealState.data.isEmpty) {
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
                    height: 332.h,
                    child: ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Deal item = data[index];
                          return CardDealSuggest(
                            deal: item,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                DealTracking.id,
                                arguments: item,
                              );
                            },
                          );
                        }),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
