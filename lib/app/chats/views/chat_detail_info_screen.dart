import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/chats/widget/chat_detail_info/media_container.dart';
import 'package:youreal/app/chats/widget/chat_detail_info/member_list.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/widgets_common/notification_button.dart';
import 'package:youreal/widgets_common/popup_update_feature.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

class ChatDetailInfoScreen extends StatelessWidget {
  static const id = "ChatDetailInfoScreen";

  const ChatDetailInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        leading: const YrBackButton(),
        titleSpacing: 0,
        title: BlocBuilder<ChatDetailBloc, ChatDetailState>(
          builder: (context, state) {
            String groupName = "";
            int groupMemberCount = 0;

            groupName = state.groupChat.name;
            groupMemberCount = state.groupChat.numberMember;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: kText14Bold_Light,
                ),
                Text(
                  '$groupMemberCount người',
                  style: kText14Weight400_Light,
                ),
              ],
            );
          },
        ),
        actions: [
          InkResponse(
            radius: 20.w,
            onTap: () async {
              showDialog(
                context: context,
                builder: (_) => const PopupUpdateFeature(),
              );

              return;
            },
            child: SvgPicture.asset(
              'assets/icons/ic_user_add.svg',
              color: yrColorLight,
              height: 24.w,
              width: 24.w,
            ),
          ),
          SizedBox(width: 10.w),
          const NotificationButton(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MediaContainer(),
              const MemberList(),
              SizedBox(height: 16.h),
              const ExitDealButton(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

class ExitDealButton extends StatelessWidget {
  const ExitDealButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (_) => const PopupUpdateFeature(),
        );

        return;
        // final result = await showAnimatedDialog<bool>(
        //       barrierDismissible: true,
        //       context: context,
        //       builder: (context) => const ConfirmDialog(
        //         title: 'Bạn có chắc muốn rút khỏi Deal này không?\n'
        //             'Nếu có bạn phải thanh toán tiền phạt.',
        //       ),
        //       animationType: DialogTransitionType.slideFromTop,
        //       duration: const Duration(milliseconds: 300),
        //       curve: Curves.easeOut,
        //     ) ??
        //     false;
        // if (result) {
        //   await showAnimatedDialog(
        //     barrierDismissible: true,
        //     context: context,
        //     builder: (context) => const PayFineExitDealDialog(),
        //     animationType: DialogTransitionType.slideFromTop,
        //     duration: const Duration(milliseconds: 300),
        //     curve: Curves.easeOut,
        //   );
        // }
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: yrColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.w)),
        padding: EdgeInsets.all(16.w),
      ),
      child: Row(
        children: [
          Icon(
            Icons.exit_to_app,
            size: 21.w,
            color: yrColorError,
          ),
          SizedBox(width: 16.w),
          Text(
            "Rời khỏi dự án",
            style: kText14Weight400_Error,
          ),
        ],
      ),
    );
  }
}
