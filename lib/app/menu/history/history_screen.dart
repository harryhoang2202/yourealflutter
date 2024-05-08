import 'package:flutter/material.dart';
import 'package:youreal/app/menu/draft_deal/no_deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static const id = "HistoryScreen";

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        centerTitle: true,
        leading: const YrBackButton(),
        elevation: 0,
        title: Text(
          "Lịch sử",
          style: kText28_Light,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            // if (snapshot.hasData)
            //   return ListView.builder(itemBuilder: (context, index) {
            //     return Container();
            //   });
            // else if (snapshot.hasError)
            //   return Container(
            //     padding: EdgeInsets.only(top: 20.h),
            //     child: Center(
            //         child: Text(
            //           "Không có dữ liệu",
            //           style: kText14_3,
            //         )),
            //   );
            // else
            //   return Container(
            //       child: Center(child: CircularProgressIndicator()));
            return const NoDeal(
                title: "Rất tiếc, bạn chưa có hoạt động nào gần đây."
                    "\nBạn muốn tạo Deal mới!");
          },
        ),
      ),
    );
  }
}
