import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/src/provider.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/blocs/cost_incurred_bloc/cost_incurred_bloc.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'widgets/defailt_fees.dart';
import 'widgets/incurred_fees.dart';
import 'widgets/new_fees.dart';

class CostsIncurred extends StatefulWidget {
  const CostsIncurred({Key? key}) : super(key: key);

  static const id = "CostsIncurred";

  @override
  _CostsIncurredState createState() => _CostsIncurredState();
}

class _CostsIncurredState extends State<CostsIncurred> {
  @override
  void initState() {
    super.initState();
    _bloc = context.read<CostIncurredBloc>();
  }

  late CostIncurredBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        leading: const YrBackButton(),
        title: Text("Các khoản phí", style: kText28_Light),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              Text(
                "Các khoản phí mặc định",
                style: kText18_Light,
              ).toSliver(),
              SizedBox(height: 8.h).toSliver(),
              const DefaultFees(),
              SizedBox(height: 8.h).toSliver(),
              Text(
                "Các khoản phí phát sinh",
                style: kText18_Light,
              ).toSliver(),
              SizedBox(height: 8.h).toSliver(),
              const IncurredFees(),
              SizedBox(height: 8.h).toSliver(),
              Text(
                "Thêm khoản phí mới",
                style: kText18_Light,
              ).toSliver(),
              SizedBox(height: 8.h).toSliver(),
              const NewFees(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 50.h),
        child: PrimaryButton(
          text: "Cập nhật",
          onTap: () async {
            final result = await Utils.showConfirmDialog(context,
                title: "Bạn chắc chắn muốn cập nhật các khoản phí phát sinh?");

            if (result == true) {
              _bloc.add(
                CostIncurredFeeUpdated(onComplete: (error) async {
                  if (error != null) {
                    Utils.showErrorDialog(context, message: error);
                  } else {
                    _bloc.add(const CostIncurredGetFees());
                    await Utils.showInfoSnackBar(context,
                        duration: const Duration(seconds: 1),
                        message: "Thêm phí thành công");
                  }
                }),
              );
            }
          },
          textColor: yrColorPrimary,
          backgroundColor: yrColorLight,
        ),
      ),
    );
  }
}
