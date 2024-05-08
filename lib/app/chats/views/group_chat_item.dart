import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_cubit/chat_cubit.dart';
import 'package:youreal/app/chats/models/group_chat.dart';
import 'package:youreal/app/chats/widget/latest_message.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'chat_detail_screen.dart';

class GroupChatItem extends StatelessWidget {
  final GroupChat groupChat;

  const GroupChatItem({
    Key? key,
    required this.groupChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final chatCubit = BlocProvider.of<ChatCubit>(context, listen: false);
        Navigator.of(context, rootNavigator: true).pushNamed(
          ChatDetailScreen.id,
          arguments: ChatDetailArgs(
            groupChat: groupChat,
            authBloc: BlocProvider.of<AuthBloc>(context, listen: false),
            chatCubit: chatCubit,
          ),
        );
      },
      child: Container(
        height: 72.h,
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.fromSize(
              size: Size(56.w, 56.w),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CircleAvatar(
                      maxRadius: 18.w,
                      backgroundImage: const AssetImage(
                        "assets/images/avatar.png",
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: yrColorPrimary,
                          maxRadius: 20.w,
                          child: CircleAvatar(
                            maxRadius: 18.w,
                            backgroundImage: const AssetImage(
                              "assets/images/avatar.png",
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14.w,
                            height: 14.w,
                            decoration: BoxDecoration(
                              color: yrColorSuccess,
                              shape: BoxShape.circle,
                              border: Border.all(color: yrColorPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupChat.name,
                    style: kText18Weight500_Light,
                  ),
                  if (groupChat.latestMessage != null)
                    LatestMessage(groupChat: groupChat),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
