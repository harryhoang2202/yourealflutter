import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class YrTabBar extends StatefulWidget {
  final TabController controller;

  const YrTabBar({Key? key, required this.controller}) : super(key: key);

  @override
  _YrTabBarState createState() => _YrTabBarState();
}

class _YrTabBarState extends State<YrTabBar> {
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    widget.controller.addListener(() {
      setState(() {
        selectedIndex = widget.controller.index;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: TabBar(
        controller: widget.controller,
        labelColor: yrColorPrimary,
        unselectedLabelColor: yrColorHint,
        labelStyle: kText14Weight400_Primary,
        unselectedLabelStyle: kText14Weight400_Primary,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        physics: const NeverScrollableScrollPhysics(),
        tabs: [
          TabItem(
            isSelected: selectedIndex == 0,
            text: 'Ảnh',
          ),
          // TabItem(
          //   isSelected: selectedIndex == 1,
          //   text: 'Videos',
          // ),
          // TabItem(
          //   isSelected: selectedIndex == 2,
          //   text: 'Tài liệu',
          // ),
          // TabItem(
          //   isSelected: selectedIndex == 3,
          //   text: 'Đường dẫn',
          // ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;

  const TabItem({
    Key? key,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? yrColorLight : yrColorSecondary,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
        child: Text(
          text,
          style: kText14Weight400_Primary,
        ),
      ),
    );
  }
}
