import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';

import 'package:youreal/app/deal/create_deal/views/create_deal.dart';
import 'package:youreal/app/deal/create_deal/widget/choose_real_estate_widget.dart';
import 'package:youreal/app/deal/create_deal/widget/detail_address_v2.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class CreateDealV2 extends StatelessWidget {
  static const id = "CreateDealV2";

  const CreateDealV2({super.key});

  @override
  Widget build(BuildContext context) {
    final createDealBloc = context.read<CreateDealBloc>();

    return Scaffold(
      backgroundColor: yrColorPrimary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Loại bất động sản*",
                  style: kText18_Light,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.h),
                child: ChooseRealEstateWidget(createDealBloc: createDealBloc),
              ),

              ///Địa chỉ
              Container(
                padding: EdgeInsets.only(left: 8.w),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  "Địa chỉ",
                  style: kText18_Light,
                ),
              ),
              const DetailAddressV2(),

              SizedBox(
                height: 20.h,
              ),

              AcreageInput(
                createDealBloc: createDealBloc,
                floorFocusNode: FocusNode(),
                timeDepositFocusNode: FocusNode(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
