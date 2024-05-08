import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youreal/app/deal/blocs/deal_bloc.dart';
import 'package:youreal/app/deal/create_deal/views/create_deal.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';
import 'package:youreal/app/deal/widgets/item_my_deal.dart';
import 'package:youreal/app/menu/menu.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';
import 'package:youreal/widgets_common/notification_button.dart';

import 'statistics_by_role.dart';
import 'statistics_by_status.dart';
import 'total_deal.dart';

class DealScreen extends StatefulWidget {
  const DealScreen({Key? key}) : super(key: key);
  static const id = "DealScreen";

  @override
  _DealScreenState createState() => _DealScreenState();
}

class _DealScreenState extends State<DealScreen> {
  final _key = GlobalKey<ScaffoldState>();
  late DealBloc dealBloc;
  late var _myDealState;
  // late DealInvestingBloc dealInvestingBloc;
  List<Deal> myDeal = [];
  List<Deal> myAppraisalDeal = [];
  int sessionId = 0;
  DateFormat dateFormat = DateFormat("yyyyMMddHHmmss");

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {
      sessionId = int.parse(dateFormat.format(DateTime.now()));
    });
    dealBloc
        .add(LoadMyDealEvent(numPage: 1, sessionId: sessionId, pageSize: 5));
    dealBloc.add(LoadMyDealAppraisalEvent(numPage: 1, sessionId: sessionId));

    if (!checkRole(context, RolesType.User) &&
        !checkRole(context, RolesType.DealLeader)) {
      // dealInvestingBloc
      //     .add(LoadDealInvestingEvent(numPage: 1, sessionId: sessionId));
    }
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    sessionId = int.parse(dateFormat.format(DateTime.now()));
    dealBloc = BlocProvider.of<DealBloc>(context);
    _myDealState = DealInitial();

    dealBloc
        .add(LoadMyDealEvent(numPage: 1, sessionId: sessionId, pageSize: 5));
    dealBloc.add(LoadMyDealAppraisalEvent(numPage: 1, sessionId: sessionId));

    if (!checkRole(context, RolesType.User) &&
        !checkRole(context, RolesType.DealLeader)) {
      // dealInvestingBloc = BlocProvider.of<DealInvestingBloc>(context);
      // dealInvestingBloc
      //     .add(LoadDealInvestingEvent(numPage: 1, sessionId: sessionId));
    }
  }

  @override
  Widget build(BuildContext context) {
    ///Danh sách deal của tôi
    Widget myDealBuild =
        BlocConsumer<DealBloc, DealState>(listener: (context, state) {
      if (state is LoadingMyDealState) {
        setState(() {
          _myDealState = state;
        });
      } else if (state is LoadedMyDealState) {
        setState(() {
          _myDealState = state;
        });
      } else if (state is LoadedMyDealErrorState) {
        setState(() {
          _myDealState = state;
        });
      } else if (state is LoadedDetailDealState) {
        Navigator.pushNamed(
          context,
          DealTracking.id,
          arguments: state.deal,
        );
      }
    }, builder: (context, state) {
      if (_myDealState is LoadingMyDealState) {
        return const CircularProgressIndicator();
      } else if (_myDealState is LoadedMyDealState) {
        var deals = _myDealState.deals;
        if (deals.length > 0) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Deal của tôi",
                    style: kText28_Light,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          TotalDeal.id,
                          arguments: TotalDealArgs(
                            title: "Deal của tôi",
                            itemBuilder: (Deal deal) {
                              return ItemMyDeal(
                                deal: deal,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    DealTracking.id,
                                    arguments: deal,
                                  );
                                },
                              );
                            },
                            loadData: (
                              int page,
                              int size,
                              int sessionId,
                              int lastId,
                            ) async {
                              return await APIServices().getDealOfUser(
                                page: page,
                                sessionId: sessionId,
                                pageSize: size,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Xem tất cả",
                        style: kText14Weight400_Light.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                height: deals.length * 120.h,
                child: ListView.builder(
                    itemCount: deals.length,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Deal item = deals[index];
                      return ItemMyDeal(
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
              ),
            ],
          );
        } else {
          return noHasDataBuild("Danh sách Deal của tôi");
        }
      } else if (_myDealState is LoadedMyDealErrorState) {
        return Container(
          padding: EdgeInsets.only(top: 20.h),
          child: Center(
              child: Text(
            "Opp! Đã có lỗi xảy ra",
            style: kText14Weight400_Dark,
          )),
        );
      } else {
        return Container();
      }
    });

    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: yrColorLight,
            size: 38.w,
          ),
        ),
        title: Text(
          "Deal",
          style: kText28_Light,
        ),
        actions: const [
          NotificationButton(),
        ],
      ),
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: !checkRole(context, RolesType.User)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    CreateDealScreen.id,
                                    arguments: const CreateDealArgs(
                                      editToBuy: false,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 135.w,
                                  height: 41.h,
                                  margin: EdgeInsets.only(right: 14.w),
                                  decoration: BoxDecoration(
                                      color: yrColorLight,
                                      borderRadius: BorderRadius.circular(8.h)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: yrColorPrimary,
                                        size: 25.w,
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        "Tạo Deal",
                                        style: kText18Weight400_Primary,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: 97.w,
                          ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  const StatisticsByRole(),
                  SizedBox(
                    height: 28.h,
                  ),
                  const StatisticsByStatus(),
                  SizedBox(
                    height: 36.h,
                  ),
                  myDealBuild,
                  SizedBox(
                    height: 26.h,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget noHasDataBuild(nameTile) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nameTile.toString(),
              style: kText14Weight400_Dark,
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Container(
          padding: EdgeInsets.only(top: 20.h),
          child: Center(
              child: Text(
            "Không có dữ liệu",
            style: kText14Weight400_Dark,
          )),
        ),
      ],
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
