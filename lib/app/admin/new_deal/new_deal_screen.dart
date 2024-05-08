import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youreal/app/admin/new_deal/bloc/new_deal_bloc.dart';
import 'package:youreal/app/deal/deal_detail/admin_detail_deal.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/widgets/card_deal_investing.dart';
import 'package:youreal/app/menu/menu.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';

class NewDealScreen extends StatefulWidget {
  const NewDealScreen({super.key});

  @override
  State<NewDealScreen> createState() => _NewDealScreenState();
}

class _NewDealScreenState extends State<NewDealScreen> {
  final DateFormat dateFormat = DateFormat("yyyyMMddHHmmss");
  late final NewDealBloc bloc;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    bloc.add(const NewDealEvent.loadDeal());

    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    try {
      bloc = NewDealBloc();
      bloc.add(const NewDealEvent.loadDeal());
    } catch (e, trace) {
      printLog("$e $trace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: yrColorPrimary,
        drawer: const Menu(),
        drawerEnableOpenDragGesture: false,
        drawerEdgeDragWidth: screenWidth / 2,
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(
              waterDropColor: Colors.white,
              complete: Container(),
              refresh: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      children: [
                        BlocConsumer<NewDealBloc, NewDealState>(
                          bloc: bloc,
                          listener: (context, state) {
                            state.when(
                              initial: () {},
                              loaded: (deals) {},
                              loading: () {},
                              loadDetailSuccess: (deal) async {
                                await Navigator.of(context, rootNavigator: true)
                                    .pushNamed(
                                  AdminDetailDeal.id,
                                  arguments: deal,
                                );
                                _onRefresh();
                              },
                              loadDetalError: () {},
                            );
                          },
                          buildWhen: (previous, current) =>
                              current is NewDealLoaded ||
                              current is NewDealInitial,
                          builder: (context, state) {
                            final list = state.whenOrNull<List<Deal>?>(
                                  loaded: (deals) => deals,
                                ) ??
                                [];
                            return SizedBox(
                              height: list.length * (168.h + 8.h),
                              child: ListView.separated(
                                itemCount: list.length,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Deal item = list[index];
                                  return CardDealInvesting(
                                    deal: item,
                                    onTap: () {
                                      bloc.add(
                                        NewDealEvent.loadDetail(
                                          item.id.toString(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (_, __) => 8.verSp,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
