import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/main_screen.dart';
import 'package:youreal/app/my_deal/deal_screen.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

class CreateDealComplete extends StatefulWidget {
  final String dealId;
  const CreateDealComplete({Key? key, required this.dealId}) : super(key: key);
  static const id = "CreateDealComplete";

  @override
  _CreateDealCompleteState createState() => _CreateDealCompleteState();
}

class _CreateDealCompleteState extends State<CreateDealComplete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        centerTitle: true,
        elevation: 0,
        leading: Container(),
        title: Text(
          "Khởi tạo Deal",
          style: kText28_Light,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: 190.h,
              width: screenWidth,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              decoration: BoxDecoration(
                  color: yrColorLight,
                  borderRadius: BorderRadius.circular(10.h)),
              child: Text(
                "Hồ sơ tài sản số #${widget.dealId} của bạn đã được tiếp nhận. "
                "Vui lòng đợi quá trình kiểm duyệt hồ sơ.",
                style: kText14Weight400_Primary,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 50.h),
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: PrimaryButton(
                    text: "DANH SÁCH DEAL",
                    textColor: yrColorPrimary,
                    backgroundColor: yrColorLight,
                    onTap: () {
                      Utils.hideKeyboard(context);
                      Navigator.popUntil(context, (route) {
                        return route.settings.name == MainScreen.id ||
                            route.settings.name == DealScreen.id;
                      });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
