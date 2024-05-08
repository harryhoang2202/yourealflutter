import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/blocs/cost_incurred_bloc/cost_incurred_bloc.dart';
import 'package:youreal/app/deal/model/deal_fee.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

import 'information_text.dart';

class DefaultFees extends StatefulWidget {
  const DefaultFees({
    Key? key,
  }) : super(key: key);

  @override
  State<DefaultFees> createState() => _DefaultFeesState();
}

class _DefaultFeesState extends State<DefaultFees> {
  List<DealFee> defaultFees = [];
  late CostIncurredBloc _bloc;
  @override
  void initState() {
    _bloc = context.read<CostIncurredBloc>();
    setState(() {
      defaultFees = _bloc.state.dealFees
          .where((element) => element.feeType != FeeType.Others)
          .toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CostIncurredBloc, CostIncurredState>(
      buildWhen: (oSt, nSt) {
        return oSt.dealFees
                .where((element) => element.feeType != FeeType.Others) !=
            nSt.dealFees.where((element) => element.feeType != FeeType.Others);
      },
      listener: (context, state) {
        setState(() {
          defaultFees = state.dealFees
              .where((element) => element.feeType != FeeType.Others)
              .toList();
        });
      },
      builder: (context, state) {
        if (defaultFees.isEmpty) {
          return Container(
            padding: EdgeInsets.only(top: 10.h),
            alignment: Alignment.center,
            child:
                Text("Chưa có khoản phí nào.", style: kText18Weight400_Light),
          ).toSliver();
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = defaultFees[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: InformationText(
                  affix: 'VNĐ',
                  content: item.value.money,
                  title: item.feeTypeName,
                ),
              );
            },
            childCount: defaultFees.length,
          ),
        );
      },
    );
  }
}
