import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:tvt_tab_bar/tvt_tab_bar.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';
import 'package:youreal/app/deal/common/address_search_provider.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/constants/enums.dart';

import 'location_view.dart';
import 'modify_deal_view.dart';
import 'vote_leader.dart';

class DealOptionBottomSheet extends StatefulWidget {
  const DealOptionBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<DealOptionBottomSheet> createState() => _DealOptionBottomSheetState();
}

class _DealOptionBottomSheetState extends State<DealOptionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final inputBloc = context.read<ChatInputBloc>();
    return NestedWillPopScope(
      onWillPop: () async {
        if (inputBloc.dealOptionPanelController.isPanelOpen) {
          inputBloc.dealOptionPanelController.close();
        } else if (inputBloc.dealOptionPanelController.isPanelShown) {
          inputBloc.add(ChatInputOptionChanged(InputOption.Idle, context));
        }
        return false;
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: BoxDecoration(
            color: yrColorSecondary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 100.w,
                  height: 4.h,
                  color: yrColorLight,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocSelector<ChatInputBloc, ChatInputState,
                    Tuple2<DealOptionType, InputOption>>(
                  selector: (state) =>
                      Tuple2(state.dealOptionType, state.inputOption),
                  builder: (context, tuple) {
                    if (tuple.item2 == InputOption.Location) {
                      return ChangeNotifierProvider(
                        create: (BuildContext context) =>
                            AddressSearchProvider(enableAutoComplete: false),
                        child: LocationView(),
                      );
                    } else {
                      if (tuple.item1 == DealOptionType.Modify) {
                        return const ModifyDealView();
                      } else {
                        return const VoteLeader();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
