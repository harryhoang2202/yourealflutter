import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/admin/assign_deal/assign_deal_screen.dart';
import 'package:youreal/app/admin/cancel_deal/cancel_deal_screen.dart';
import 'package:youreal/app/admin/new_deal/new_deal_screen.dart';
import 'package:youreal/app/admin/reviewed_deal/reviewed_deal_screen.dart';
import 'package:youreal/app/menu/menu.dart';

import 'package:youreal/common/config/color_config.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  static const String id = 'AdminMainScreen';

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen>
    with TickerProviderStateMixin {
  final _key = GlobalKey<ScaffoldState>();
  late TabController controller;
  @override
  void initState() {
    super.initState();
    int initialIndex = 0;

    controller =
        TabController(initialIndex: initialIndex, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: const Text("Quản lý"),
        centerTitle: true,
        elevation: 0,
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
        backgroundColor: yrColorPrimary,
        bottom: TabBar(
          isScrollable: true,
          controller: controller,
          tabs: const [
            Tab(
              text: "Deal chờ duyệt",
            ),
            Tab(
              text: "Deal chờ thẩm định",
            ),
            Tab(
              text: "Deal đã duyệt",
            ),
            Tab(
              text: "Deal đã hủy",
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TabBarView(
          controller: controller,
          children: const [
            NewDealScreen(),
            AssignDealScreen(),
            ReviewedDealScreen(),
            CancelDealScreen(),
          ],
        ),
      ),
    );
  }
}
