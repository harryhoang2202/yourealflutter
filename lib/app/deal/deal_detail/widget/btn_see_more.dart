import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/cost_incurred/costs_incurred.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'popup_detail_contract.dart';

class BtnSeeMore extends StatelessWidget {
  final bool isLeader;
  final bool hasDepositContract;
  final bool hasPaymentContract;
  final Deal deal;
  const BtnSeeMore({
    Key? key,
    this.isLeader = false,
    this.hasDepositContract = false,
    this.hasPaymentContract = false,
    required this.deal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: yrColorLight,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20.r),
        topLeft: Radius.circular(20.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Hợp đồng đầu tư
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const PopupDetailContract(),
              );
              // showDialog(
              //   context: context,
              //   builder: (_) => const PopupUpdateFeature(),
              // );
            },
            child: Container(
              height: 50.h,
              alignment: Alignment.center,
              child: Text("Hợp đồng đầu tư", style: kText16Weight400_Primary),
            ),
          ),
          const Divider(),

          /// Hợp đồng đặt cọc
          if (hasDepositContract) ...[
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const DepositContract(),
                );
                // showDialog(
                //   context: context,
                //   builder: (_) => const PopupUpdateFeature(),
                // );
              },
              child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Text("Hợp đồng đặt cọc",
                      style: kText16Weight400_Primary)),
            ),
            const Divider(),
          ],

          ///Hợp đồng thanh toán
          if (hasPaymentContract) ...[
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const PaymentContract(),
                );
                // showDialog(
                //   context: context,
                //   builder: (_) => const PopupUpdateFeature(),
                // );
              },
              child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Text("Hợp đồng thanh toán",
                      style: kText16Weight400_Primary)),
            ),
            const Divider(),
          ],

          /// Chuyển leader
          // if (isLeader) ...[
          //   InkWell(
          //     onTap: () async {
          //       var result = await showDialog(
          //         context: context,
          //         builder: (_) => const ChangeLeader(),
          //       );
          //     },
          //     child: Container(
          //         height: 50.h,
          //         alignment: Alignment.center,
          //         child: Text("Chuyển quyền leader",
          //             style: kText16Weight400_Primary)),
          //   ),
          //   const Divider(),
          // ],

          if (isLeader) ...[
            InkWell(
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  CostsIncurred.id,
                  arguments: deal,
                );
              },
              child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Text("Phí phát sinh (Nếu có)",
                      style: kText16Weight400_Primary)),
            ),
            const Divider(
              color: Colors.transparent,
            ),
          ],

          PrimaryButton(
            text: "Đóng",
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: 0,
            horizontalMargin: 0,
          ),
        ],
      ),
    );
  }
}
