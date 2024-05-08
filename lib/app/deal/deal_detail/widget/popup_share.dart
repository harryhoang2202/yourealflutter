import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

class PopupShare extends StatefulWidget {
  final Deal deal;

  const PopupShare({Key? key, required this.deal}) : super(key: key);

  @override
  _PopupShareState createState() => _PopupShareState();
}

class _PopupShareState extends State<PopupShare> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(9.h),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "CHIA SẺ",
                style: kText18_Primary,
              ),
            ),
            Container(
              height: 56.h,
              color: yrColorPrimary,
              padding: EdgeInsets.all(9.h),
              child: Row(
                children: [
                  SvgPicture.asset(
                    getIcon("website.svg"),
                    color: yrColorPrimary,
                    width: 42.w,
                    height: 40.h,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.deal.realEstate!.realEstateTypeName}",
                        style: kText14Weight400_Primary,
                      ),
                      Text(
                        "3 giờ trước",
                        style: kText14Weight400_Primary,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Container(
              height: 90.h,
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        printLog("Copy to clipboard");
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.copy_outlined,
                            size: 60.h,
                            color: yrColorLight,
                          ),
                          Text(
                            "Copy to\nclipboard",
                            style: kText14Weight400_Primary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    InkWell(
                      onTap: () {
                        printLog("Gửi tới nhóm");
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/ic_people1.svg",
                            width: 61.w,
                            height: 60.h,
                            color: yrColorDark,
                          ),
                          SizedBox(
                            width: 65.w,
                            child: Text(
                              "Gửi tới nhóm",
                              style: kText14Weight400_Primary,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 7.h,
              width: screenWidth,
              color: yrColorHint,
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      printLog("Gửi tới facebook");
                    },
                    child: SvgPicture.asset(
                      "assets/icons/facebook1.svg",
                      width: 45.w,
                      height: 45.h,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      printLog("Gửi tới sms");
                    },
                    child: SvgPicture.asset(
                      "assets/icons/ic_sms.svg",
                      width: 45.w,
                      height: 45.h,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      printLog("Gửi tới email");
                      File file =
                          await fileFromImageUrl(ChatDetailBloc.testImage);

                      const text = '''
Căn hộ chung cư
Địa chỉ: 182 trương thị định, phường tam bình, thành phố thủ đức, thành phố hồ chí minh
Tổng quan:
-Nhà đẹp mới sửa xong, xách vali vào là ở
-Vị trí gần chợ 200m, gần đại học kinh tế, y dược.
-Sổ hồng riêng.
Phần đất:
  Diện tích sàn
                      ''';
                      await Share.shareFiles([file.path], subject: text);
                    },
                    child: SvgPicture.asset(
                      "assets/icons/ic_email.svg",
                      width: 45.w,
                      height: 45.h,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      printLog("Gửi tới zalo");
                      //Share.share("share bài tới zalo",sharePositionOrigin: );
                    },
                    child: SvgPicture.asset(
                      "assets/icons/ic_zalo.svg",
                      width: 45.w,
                      height: 45.h,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      printLog("Xem thêm");
                    },
                    child: SvgPicture.asset(
                      "assets/icons/ic_other.svg",
                      width: 45.w,
                      height: 45.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
