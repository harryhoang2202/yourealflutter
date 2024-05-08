import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_vote_leader_cubit/chat_vote_leader_cubit.dart';
import 'package:youreal/common/constants/enums.dart';

import 'primary_button.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatInputBloc, ChatInputState>(
      builder: (context, inputState) {
        return BlocBuilder<ChatVoteLeaderCubit, ChatVoteLeaderState>(
          builder: (context, voteState) {
            final buttonText = _getButtonText(inputState.dealOptionType,
                inputState.inputOption, voteState.pageIndex);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: PrimaryButton(
                text: buttonText,
                onTap: () => _onButtonClick(context, buttonText),
              ),
            );
          },
        );
      },
    );
  }

  _onButtonClick(BuildContext context, String buttonText) {
    switch (buttonText) {
      case "Tạo bình chọn":
        context.read<ChatVoteLeaderCubit>().onVoteLeaderViewChanged(1);
        return;
      case "Bình chọn":
        return;
      case "Gửi yêu cầu":
        return;
      case "Bắt đầu chia sẻ vị trí trực tiếp":
        return;
    }
  }

  String _getButtonText(
      DealOptionType dealOptionType, InputOption inputOption, pageIndex) {
    String buttonText = "Unknown";

    if (inputOption == InputOption.Add) {
      if (dealOptionType == DealOptionType.Modify) {
        buttonText = "Gửi yêu cầu";
      }
      //Vote Leader
      else if (dealOptionType == DealOptionType.VoteLeader) {
        if (pageIndex == 0) {
          buttonText = "Tạo bình chọn";
        } else if (pageIndex == 1) {
          buttonText = "Bình chọn";
        }
      }
    } else if (inputOption == InputOption.Location) {
      buttonText = "Bắt đầu chia sẻ vị trí trực tiếp";
    }
    return buttonText;
  }
}
