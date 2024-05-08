import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/src/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:uuid/uuid.dart';
import 'package:youreal/app/deal/blocs/cost_incurred_bloc/cost_incurred_bloc.dart';
import 'package:youreal/app/deal/model/deal_fee.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'new_fee_item.dart';

class NewFees extends StatefulWidget {
  const NewFees({Key? key}) : super(key: key);

  @override
  _NewFeesState createState() => _NewFeesState();
}

class _NewFeesState extends State<NewFees> {
  final List<FeeUiWrapper> newFees = [];

  List<DealFee> get fees {
    return newFees.map((e) => e.fee).toList();
  }

  late CostIncurredBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<CostIncurredBloc>();
  }

  void syncFees() {
    setState(() {});

    _bloc.add(CostIncurredNewFeeChanged(fees: fees));
  }

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return newFees[index].item;
            },
            childCount: newFees.length,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton(
            onPressed: () {
              final temp = FeeUiWrapper(
                item: NewFeeItem(
                    remove: (id) {
                      newFees.removeWhere((it) => it.item.id == id);
                      syncFees();
                    },
                    onChanged: (it, id) {
                      final changedIndex = newFees
                          .indexWhere((element) => element.item.id == id);
                      newFees[changedIndex] =
                          newFees[changedIndex].copyWith(fee: it);
                      syncFees();
                    },
                    id: const Uuid().v4()),
                fee: DealFee.geDefault(),
              );
              newFees.add(temp);
              syncFees();
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: yrColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.w),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              maximumSize: Size(184.w, 1.sh),
            ),
            child: Row(
              children: [
                const Icon(Icons.add_circle_outline, color: yrColorPrimary),
                Expanded(
                  child: Text(
                    "Thêm phí",
                    style: kText18Weight400_Primary,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class FeeUiWrapper {
  final NewFeeItem item;
  final DealFee fee;

  const FeeUiWrapper({
    required this.item,
    required this.fee,
  });

  @override
  String toString() {
    return 'FeeUiWrapper{item: $item, fee: $fee}';
  }

  FeeUiWrapper copyWith({
    NewFeeItem? item,
    DealFee? fee,
  }) {
    return FeeUiWrapper(
      item: item ?? this.item,
      fee: fee ?? this.fee,
    );
  }
}
