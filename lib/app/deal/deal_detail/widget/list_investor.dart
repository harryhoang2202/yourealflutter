import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'popup_quesion.dart';

class ListInvestorArgs {
  final List<Allocation> listAllocation;
  final double price;

  const ListInvestorArgs({
    required this.listAllocation,
    required this.price,
  });
}

class ListInvestor extends StatelessWidget {
  final List<Allocation> listAllocation;
  final double price;
  static const id = "ListInvestor";

  const ListInvestor(
      {Key? key, required this.listAllocation, required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        leading: const YrBackButton(),
        title: Text("Danh sách nhà đầu tư", style: kText28_Light),
        centerTitle: true,
      ),
      body: ListView.separated(
          shrinkWrap: true,
          itemCount: listAllocation.length,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          separatorBuilder: (context, index) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            var item = listAllocation[index];
            return Container(
              height: 90.h,
              decoration: BoxDecoration(
                  color: yrColorLight,
                  borderRadius: BorderRadius.circular(8.r)),
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text("21/04/2021", style: kText14Weight400_Accent),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text("${item.firstName} ${item.lastName}",
                              style: kText14Bold_Primary)),
                      // Container(
                      //     width: 130.w,
                      //     alignment: Alignment.centerLeft,
                      //     child: Text("Người thanh toán:",
                      //         style: kText14Weight400_Secondary2)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 130.w,
                          alignment: Alignment.centerLeft,
                          child: Text("Số tiền đầu tư:",
                              style: kText14Weight400_Primary)),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              Tools()
                                  .convertMoneyToSymbolMoney(
                                      "${item.allocation! * price / 100}")
                                  .toString(),
                              style: kText14Weight400_Primary))
                    ],
                  )
                ],
              ),
            );
          }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h),
        child: PrimaryButton(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => const PopupQuesion(
                  title: "Bạn chắc chắn chốt danh sánh nhà đầu tư lúc này?",
                  textOk: "Chốt danh sách"),
            );
          },
          text: "Chốt danh sách nhà đầu tư",
          backgroundColor: yrColorLight,
          textColor: yrColorPrimary,
          verticalPadding: 16.h,
        ),
      ),
    );
  }
}
