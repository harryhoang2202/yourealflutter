import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/blocs/cost_incurred_bloc/cost_incurred_bloc.dart';
import 'package:youreal/app/deal/model/deal_fee.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

import 'information_text.dart';

class IncurredFees extends StatefulWidget {
  const IncurredFees({
    Key? key,
  }) : super(key: key);

  @override
  State<IncurredFees> createState() => _IncurredFeesState();
}

class _IncurredFeesState extends State<IncurredFees> {
  List<DealFee> incurredFees = [];
  late CostIncurredBloc _bloc;
  @override
  void initState() {
    _bloc = context.read<CostIncurredBloc>();
    setState(() {
      incurredFees = _bloc.state.dealFees
          .where((element) => element.feeType == FeeType.Others)
          .toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CostIncurredBloc, CostIncurredState>(
      buildWhen: (oSt, nSt) {
        return oSt.dealFees
                .where((element) => element.feeType == FeeType.Others) !=
            nSt.dealFees.where((element) => element.feeType == FeeType.Others);
      },
      listener: (context, state) {
        setState(() {
          incurredFees = state.dealFees
              .where((element) => element.feeType == FeeType.Others)
              .toList();
        });
      },
      builder: (context, state) {
        if (incurredFees.isEmpty) {
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
              final item = incurredFees[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 8.0.h),
                child: InformationText(
                  affix: 'VNĐ',
                  content: item.value.money,
                  title: item.note ?? item.feeTypeName,
                ),
              );
            },
            childCount: incurredFees.length,
          ),
        );
      },
    );
  }
}
