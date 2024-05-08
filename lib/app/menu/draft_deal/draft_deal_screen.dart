import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/utils/lazy_loading_list.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'draft_deal_item.dart';
import 'no_deal.dart';

class DraftDealScreen extends StatefulWidget {
  const DraftDealScreen({Key? key}) : super(key: key);

  static const id = "DraftDealScreen";

  @override
  _DraftDealScreenState createState() => _DraftDealScreenState();
}

class _DraftDealScreenState extends State<DraftDealScreen> {
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
          "Lưu deal nháp",
          style: kText28_Light,
        ),
      ),
      body: LazyLoadingList<Deal>(
        builder: (context, items) => items.isNotEmpty
            ? Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 60.h),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return DraftDealItem(item: items[index]);
                  },
                ),
              )
            : const NoDeal(
                title: "Rất tiếc, bạn chưa có Deal nháp. Tạo Deal ngay!",
              ),
      ),
    );
  }
}
