import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';

import 'package:youreal/common/constants/enums.dart';

import 'deal_option_button.dart';

class PaddingPanel extends StatelessWidget {
  const PaddingPanel({
    Key? key,
  }) : super(key: key);
  static final double kPanelContainerMinHeight = 282.h;
  static final double kPanelContainerMaxHeight = 1.sh - 77.h;
  static final double kOptionButtonHeight = 36.w;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatInputBloc, ChatInputState, InputOption>(
      selector: (state) => state.inputOption,
      builder: (context, inputOption) {
        final inputBloc = context.read<ChatInputBloc>();
        double height = MediaQuery.of(context).viewPadding.bottom;
        if (inputOption == InputOption.Add) {
          height = kPanelContainerMinHeight + 16.h + kOptionButtonHeight;
        } else if (inputOption == InputOption.Location) {
          height = kPanelContainerMinHeight;
        } else if (inputOption == InputOption.Picture) {
          height = 0;
        }
        return AnimatedContainer(
          height: height,
          width: 1.sw,
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (inputOption == InputOption.Add)
                BlocSelector<ChatInputBloc, ChatInputState, DealOptionType>(
                  selector: (state) => state.dealOptionType,
                  builder: (context, dealOptionType) {
                    return Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DealOptionButton(
                            iconName: "ic_tool",
                            text: "Điều chỉnh Deal",
                            isActive: dealOptionType == DealOptionType.Modify,
                            onTap: () {
                              inputBloc.add(
                                const ChatInputDealOptionTypeChanged(
                                    DealOptionType.Modify),
                              );
                            },
                          ),
                          DealOptionButton(
                            iconName: "ic_thumbs_up",
                            text: "Vote Leader",
                            isActive:
                                dealOptionType == DealOptionType.VoteLeader,
                            onTap: () {
                              inputBloc.add(
                                const ChatInputDealOptionTypeChanged(
                                    DealOptionType.VoteLeader),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
