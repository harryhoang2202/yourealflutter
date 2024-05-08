import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youreal/app/admin/search/admin_search_deal_screen.dart';
import 'package:youreal/app/common/fliter/blocs/filter_bloc.dart';
import 'package:youreal/app/common/fliter/index.dart';
import 'package:youreal/app/home/widgets/w_deal_investing.dart';
import 'package:youreal/app/home/widgets/w_deal_new_approved.dart';
import 'package:youreal/app/home/widgets/w_deal_suggest.dart';

import 'package:youreal/app/menu/menu.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/country.dart';

import 'package:youreal/view_models/app_bloc.dart';
import 'package:youreal/view_models/app_model.dart';
import 'package:youreal/widgets_common/notification_button.dart';

import 'package:youreal/widgets_common/search_bar.dart';

class HomeScreen extends StatefulWidget {
  final bool showAppBar;
  const HomeScreen({Key? key, this.showAppBar = true}) : super(key: key);
  static const id = "HomeScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _key = GlobalKey<ScaffoldState>();

  List<Province> provinces = [];
  DateFormat dateFormat = DateFormat("yyyyMMddHHmmss");
  bool isSelectLocation = false;
  final TextEditingController _search = TextEditingController();
  int sessionId = 0;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {
      sessionId = int.parse(dateFormat.format(DateTime.now()));
    });

    AppBloc.homeBloc.initial();
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    try {
      AppBloc.filterBloc.initial();
      loadInitData();

      sessionId = int.parse(dateFormat.format(DateTime.now()));

      AppBloc.homeBloc.initial();
    } catch (e, trace) {
      printLog("$e $trace");
    }
  }

  loadInitData() async {
    try {
      var list = await AppModel().loadProvinces();

      setState(() {
        provinces = list;
      });
    } catch (e, trace) {
      printLog("$e $trace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      appBar: widget.showAppBar
          ? AppBar(
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
                "Trang chủ",
                style: kText28_Light,
              ),
              actions: const [
                NotificationButton(),
              ],
            )
          : null,
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
                _headerBuild(context),
                24.verSp,
                const WDealSuggest(),
                24.verSp,
                const WDealNewApproved(),
                24.verSp,
                const WDealInvesting(),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          )),
    );
  }

  Widget _headerBuild(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/ic_location.svg"),
                      BlocSelector<FilterBloc, FilterState, Province?>(
                        selector: (state) {
                          return state.provinceSelected;
                        },
                        builder: (context, provinceSelected) {
                          return Container(
                            margin: EdgeInsets.only(left: 16.w),
                            child: DropdownButton<Province>(
                              value: provinceSelected,
                              items: provinces
                                  .map((e) => DropdownMenuItem<Province>(
                                        value: e,
                                        child: Text(
                                          e.name,
                                          style: kText14Weight400_Light,
                                        ),
                                      ))
                                  .toList(),
                              isDense: true,
                              hint: Text(
                                "Tỉnh/Thành phố",
                                style: kText14Weight400_Light,
                              ),
                              icon: Padding(
                                padding: EdgeInsets.only(left: 6.w),
                                child: const Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: yrColorLight,
                                ),
                              ),
                              onChanged: (val) {
                                AppBloc.filterBloc.changeProvince(val!);
                              },
                              style: kText14Weight400_Light,
                              dropdownColor: yrColorPrimary,
                              underline: Container(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 16.w),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, FilterView.id);
                  },
                  child: SvgPicture.asset("assets/icons/ic_filter.svg"),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        SearchBar(
          // hintText: "Nhập mã Deal...",
          readOnly: true,
          onTap: () {
            Navigator.pushNamed(context, AdminSearchDealScreen.id);
          },
        ),
      ],
    );
  }

//#endregion
}
