import 'package:flutter/material.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

class AppraisalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppraisalAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: yrColorPrimary,
      elevation: 0,
      leading: const YrBackButton(),
      centerTitle: true,
      title: Text(
        "Thông tin thẩm định",
        style: kText28_Light,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
