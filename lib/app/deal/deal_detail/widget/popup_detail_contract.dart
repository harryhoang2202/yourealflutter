import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvt_tab_bar/tvt_tab_bar.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/app/signature_view/create_signature_screen.dart';

class PopupDetailContract extends StatefulWidget {
  const PopupDetailContract({Key? key}) : super(key: key);

  @override
  _PopupDetailContractState createState() => _PopupDetailContractState();
}

class _PopupDetailContractState extends State<PopupDetailContract> {
  File? signOfUser;
  Uint8List? signature;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      contentPadding: EdgeInsets.zero,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "Chi tiết hợp đồng",
          style: kText28_Light,
        ),
      ),
      content: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              '''
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum feugiat turpis non id aliquet vulputate justo, tristique. Nullam tristique duis sapien, odio volutpat in. Velit nisi phasellus felis imperdiet auctor purus. Fermentum mattis sagittis, penatibus magna. Blandit orci, ipsum sit elementum fermentum, commodo habitant quis id. Porttitor tortor in nisl, egestas nunc dignissim. Id quis ultricies egestas tortor eget a justo, orci, in. Facilisis sed in tincidunt turpis. Sit semper eu volutpat habitasse vestibulum suspendisse. Pharetra accumsan consectetur dolor imperdiet tincidunt luctus rhoncus morbi.
      Pellentesque ut tortor, volutpat tempor a mi at donec sem. Enim mi tincidunt suspendisse enim, eget. Quis nisi nunc lacinia viverra tellus nunc, quam. Dictum euismod tellus viverra in ullamcorper et. Vulputate massa lorem non egestas eleifend. Dolor tincidunt morbi metus vitae vel tempor, tellus, leo id. Et justo, quis mattis semper dictumst tellus fringilla. Sit porta leo in vitae. Risus, curabitur adipiscing vel in nibh. Eu imperdiet quisque et consectetur pretium venenatis.
            ''',
              style: kText14_Light,
            ),
            SizedBox(height: 20.h),
            Text(
              "Ký tên",
              style: kText14_Light,
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                pushNewScreen(context, screen: CreateSignatureScreen(
                  onSigned: (result) {
                    setState(() {
                      // signOfUser = File.fromRawPath(result);
                      signature = result;
                    });
                  },
                ), withNavBar: false);
              },
              child: Container(
                height: 130.h,
                decoration: BoxDecoration(
                    color: yrColorLight,
                    borderRadius: BorderRadius.circular(15.h)),
                child: signature != null
                    ? Center(
                        child: Image.memory(
                        signature!,
                        fit: BoxFit.contain,
                      ))
                    : Container(),
              ),
            )
          ],
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      actions: [
        PrimaryButton(
          text: 'ĐÓNG',
          backgroundColor: yrColorLight,
          textColor: yrColorPrimary,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class DepositContract extends StatefulWidget {
  const DepositContract({Key? key}) : super(key: key);

  @override
  State<DepositContract> createState() => _DepositContractState();
}

class _DepositContractState extends State<DepositContract> {
  File? signOfUser;
  Uint8List? signature;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      contentPadding: EdgeInsets.zero,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "Hợp đồng đặt cọc",
          style: kText28_Light,
        ),
      ),
      content: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              '''
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum feugiat turpis non id aliquet vulputate justo, tristique. Nullam tristique duis sapien, odio volutpat in. Velit nisi phasellus felis imperdiet auctor purus. Fermentum mattis sagittis, penatibus magna. Blandit orci, ipsum sit elementum fermentum, commodo habitant quis id. Porttitor tortor in nisl, egestas nunc dignissim. Id quis ultricies egestas tortor eget a justo, orci, in. Facilisis sed in tincidunt turpis. Sit semper eu volutpat habitasse vestibulum suspendisse. Pharetra accumsan consectetur dolor imperdiet tincidunt luctus rhoncus morbi.
      Pellentesque ut tortor, volutpat tempor a mi at donec sem. Enim mi tincidunt suspendisse enim, eget. Quis nisi nunc lacinia viverra tellus nunc, quam. Dictum euismod tellus viverra in ullamcorper et. Vulputate massa lorem non egestas eleifend. Dolor tincidunt morbi metus vitae vel tempor, tellus, leo id. Et justo, quis mattis semper dictumst tellus fringilla. Sit porta leo in vitae. Risus, curabitur adipiscing vel in nibh. Eu imperdiet quisque et consectetur pretium venenatis.
            ''',
              style: kText14_Light,
            ),
            SizedBox(height: 20.h),
            Text(
              "Ký tên",
              style: kText14_Light,
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                pushNewScreen(context, screen: CreateSignatureScreen(
                  onSigned: (result) {
                    setState(() {
                      // signOfUser = File.fromRawPath(result);
                      signature = result;
                    });
                  },
                ), withNavBar: false);
              },
              child: Container(
                height: 130.h,
                decoration: BoxDecoration(
                    color: yrColorLight,
                    borderRadius: BorderRadius.circular(15.h)),
                child: signature != null
                    ? Center(
                        child: Image.memory(
                        signature!,
                        fit: BoxFit.contain,
                      ))
                    : Container(),
              ),
            )
          ],
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      actions: [
        PrimaryButton(
          text: 'ĐÓNG',
          backgroundColor: yrColorLight,
          textColor: yrColorPrimary,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class PaymentContract extends StatefulWidget {
  const PaymentContract({Key? key}) : super(key: key);

  @override
  State<PaymentContract> createState() => _PaymentContractState();
}

class _PaymentContractState extends State<PaymentContract> {
  File? signOfUser;
  Uint8List? signature;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: yrColorPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      contentPadding: EdgeInsets.zero,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "Hợp đồng thanh toán",
          style: kText28_Light,
        ),
      ),
      content: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              '''
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum feugiat turpis non id aliquet vulputate justo, tristique. Nullam tristique duis sapien, odio volutpat in. Velit nisi phasellus felis imperdiet auctor purus. Fermentum mattis sagittis, penatibus magna. Blandit orci, ipsum sit elementum fermentum, commodo habitant quis id. Porttitor tortor in nisl, egestas nunc dignissim. Id quis ultricies egestas tortor eget a justo, orci, in. Facilisis sed in tincidunt turpis. Sit semper eu volutpat habitasse vestibulum suspendisse. Pharetra accumsan consectetur dolor imperdiet tincidunt luctus rhoncus morbi.
      Pellentesque ut tortor, volutpat tempor a mi at donec sem. Enim mi tincidunt suspendisse enim, eget. Quis nisi nunc lacinia viverra tellus nunc, quam. Dictum euismod tellus viverra in ullamcorper et. Vulputate massa lorem non egestas eleifend. Dolor tincidunt morbi metus vitae vel tempor, tellus, leo id. Et justo, quis mattis semper dictumst tellus fringilla. Sit porta leo in vitae. Risus, curabitur adipiscing vel in nibh. Eu imperdiet quisque et consectetur pretium venenatis.
            ''',
              style: kText14_Light,
            ),
            SizedBox(height: 20.h),
            Text(
              "Ký tên",
              style: kText14_Light,
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                pushNewScreen(context, screen: CreateSignatureScreen(
                  onSigned: (result) {
                    setState(() {
                      // signOfUser = File.fromRawPath(result);
                      signature = result;
                    });
                  },
                ), withNavBar: false);
              },
              child: Container(
                height: 130.h,
                decoration: BoxDecoration(
                    color: yrColorLight,
                    borderRadius: BorderRadius.circular(15.h)),
                child: signature != null
                    ? Center(
                        child: Image.memory(
                        signature!,
                        fit: BoxFit.contain,
                      ))
                    : Container(),
              ),
            )
          ],
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      actions: [
        PrimaryButton(
          text: 'ĐÓNG',
          backgroundColor: yrColorLight,
          textColor: yrColorPrimary,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
