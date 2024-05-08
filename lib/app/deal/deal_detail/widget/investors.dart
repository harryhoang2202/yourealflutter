import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';

class Investors extends StatefulWidget {
  final Deal deal;

  const Investors({Key? key, required this.deal}) : super(key: key);

  @override
  _InvestorsState createState() => _InvestorsState();
}

class _InvestorsState extends State<Investors> {
  totalInvestors() {
    List<Widget> investorBuild = [];

    if (widget.deal.allocations != null) {
      for (int i = 0; i < widget.deal.allocations!.length; i++) {
        var item = widget.deal.allocations![i];
        investorBuild.add(_itemInvestor(
            "${item.firstName} ${item.lastName}", item.allocation));
      }
    }
    return investorBuild;
  }

  _mainInvestors() {
    List<Widget> mainInvestorBuild = [];

    if (widget.deal.allocations != null &&
        widget.deal.allocations!.isNotEmpty) {
      var item = widget.deal.allocations!.first;
      var main = widget.deal.allocations!
          .where((element) => element.allocation! >= item.allocation!);

      for (var item in main) {
        mainInvestorBuild.add(_itemInvestor(
            "${item.firstName} ${item.lastName}", item.allocation));
      }
    }
    return mainInvestorBuild;
  }

  _subInvestors() {
    List<Widget> subInvestorBuild = [];
    if (widget.deal.allocations != null &&
        widget.deal.allocations!.isNotEmpty) {
      var item = widget.deal.allocations!.first;
      var sub = widget.deal.allocations!
          .where((element) => element.allocation! < item.allocation!);

      for (var item in sub) {
        subInvestorBuild.add(_itemInvestor(
            "${item.firstName} ${item.lastName}", item.allocation));
      }
    }
    return subInvestorBuild;
  }

  Widget _itemInvestor(name, allocation) {
    return Container(
      padding: EdgeInsets.only(left: 24.w),
      margin: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          Container(
            height: 4,
            width: 4,
            margin: EdgeInsets.only(right: 12.w),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: yrColorPrimary),
          ),
          RichText(
            text: TextSpan(
                text: "$name   ",
                style: kText14Weight400_Primary,
                children: [
                  TextSpan(
                      text: " ($allocation%)", style: kText14Weight400_Primary)
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      width: screenWidth,
      decoration: BoxDecoration(
          color: yrColorLight, borderRadius: BorderRadius.circular(8.w)),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                "Danh sách nhà đầu tư",
                style: kText18_Primary,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            if (widget.deal.dealStatusId.index <
                DealStatus.FinishedInvestors.index)
              ...totalInvestors(),
            if (widget.deal.dealStatusId.index >=
                DealStatus.FinishedInvestors.index) ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      "Nhà đầu tư chính:",
                      style: kText14_Accent,
                    ),
                  ),
                  ..._mainInvestors(),
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              Column(
                children: [
                  Container(
                    width: screenWidth,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      "Nhà đầu tư phụ:",
                      style: kText14_Accent,
                    ),
                  ),
                  ..._subInvestors()
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
