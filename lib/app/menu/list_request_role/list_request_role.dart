import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/utils/lazy_loading_list.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'item_request.dart';
import 'model/role_requiring.dart';

class ListRequestRole extends StatefulWidget {
  const ListRequestRole({Key? key}) : super(key: key);

  @override
  _ListRequestRoleState createState() => _ListRequestRoleState();
}

class _ListRequestRoleState extends State<ListRequestRole> {
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
          "DS đề nghị vai trò",
          style: kText28_Light,
        ),
      ),
      body: LazyLoadingList<RoleRequiring>(
        builder: (context, items) => items.isNotEmpty
            ? Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 60.h),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemRequest(
                      item: items[index],
                    );
                  },
                ),
              )
            : Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 60.h),
                child: Text("Không có yêu cầu nào cần duyệt.",
                    style: kText14_Light),
              ),
      ),
    );
  }
}
