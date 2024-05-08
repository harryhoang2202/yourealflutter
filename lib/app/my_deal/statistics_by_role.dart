import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/my_deal/widget/statistic_by_admin.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/view_models/app_model.dart';

import 'widget/statistics_by_appraisal.dart';
import 'widget/statistics_by_main_investor.dart';
import 'widget/statistics_by_sub_investor.dart';

class StatisticsByRole extends StatefulWidget {
  const StatisticsByRole({Key? key}) : super(key: key);

  @override
  _StatisticsByRoleState createState() => _StatisticsByRoleState();
}

class _StatisticsByRoleState extends State<StatisticsByRole>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int? roleId;
  final APIServices _services = APIServices();

  List<TabItem> tabs = [
    TabItem(1, "Vài trò: Thẩm định", true),
    TabItem(2, "Nhà đầu tư", false),
    // TabItem(3, "Nhà đầu tư phụ", false),
  ];
  late final bool isAdmin;

  @override
  void initState() {
    isAdmin = checkRole(context, RolesType.Admin) ||
        checkRole(context, RolesType.SuperAdmin);
    if (checkRole(context, RolesType.User)) {
      _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    } else if (isAdmin) {
      tabs.add(
        TabItem(3, "Admin", false),
      );
      _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    } else {
      _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    }
    _tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245.h,
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: yrColorPrimary,
            height: 35.h,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  clipBehavior: Clip.hardEdge,
                  color: _tabController.index == 0
                      ? yrColorLight
                      : yrColorSecondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.h),
                    topRight: Radius.circular(15.h),
                  ),
                  child: InkWell(
                    onTap: () {
                      for (var item in tabs) {
                        item.isSelected = false;
                      }
                      setState(() {
                        tabs[0].isSelected = true;
                        _tabController.index = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      alignment: Alignment.center,
                      child: Text(
                        "Thẩm đinh",
                        style: kText14Weight400_Primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 1,
                ),
                Material(
                  clipBehavior: Clip.hardEdge,
                  color: _tabController.index == 1
                      ? yrColorLight
                      : yrColorSecondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.h),
                    topRight: Radius.circular(15.h),
                  ),
                  child: InkWell(
                    onTap: () {
                      for (var item in tabs) {
                        item.isSelected = false;
                      }
                      setState(() {
                        tabs[1].isSelected = true;
                        _tabController.index = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      alignment: Alignment.center,
                      child: Text(
                        "Nhà đầu tư",
                        textAlign: TextAlign.center,
                        style: kText14Weight400_Primary,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isAdmin,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 1,
                      ),
                      Material(
                        clipBehavior: Clip.hardEdge,
                        color: _tabController.index == 2
                            ? yrColorLight
                            : yrColorSecondary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.h),
                          topRight: Radius.circular(15.h),
                        ),
                        child: InkWell(
                          onTap: () {
                            for (var item in tabs) {
                              item.isSelected = false;
                            }
                            setState(() {
                              tabs[2].isSelected = true;
                              _tabController.index = 2;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            alignment: Alignment.center,
                            child: Text(
                              "Admin",
                              style: kText14Weight400_Primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: isAdmin
                  ? const <Widget>[
                      Appraisal(),
                      MainInvestor(),
                      StatisticByAdmin(),
                    ]
                  : const <Widget>[
                      Appraisal(),
                      MainInvestor(),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TabItem {
  late int id;
  late String name;
  late bool isSelected;

  TabItem(this.id, this.name, this.isSelected);
}
