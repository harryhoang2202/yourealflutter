import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youreal/app/chats/models/group_chat.dart';

import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';

import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/view_models/app_model.dart';

class LatestMessage extends StatelessWidget {
  const LatestMessage({
    Key? key,
    required this.groupChat,
  }) : super(key: key);

  final GroupChat groupChat;
  String _getSenderName(GroupChat groupChat, User me) {
    if (me.userId == groupChat.latestMessage!.userSend.userId) {
      return "Bạn: ";
    }
    return "${groupChat.latestMessage!.userSend.firstName}: ";
  }

  String get content {
    final rawContent = groupChat.latestMessage!.content;
    if (rawContent.isEmpty) {
      return "Hình ảnh";
    } else if (rawContent.contains(kChatHeartSpecialCode)) {
      return "❤️";
    }
    return rawContent;
  }

  @override
  Widget build(BuildContext context) {
    final appModel = context.read<AppModel>();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0.0, -0.5), end: const Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          ),
        );
      },
      child: Row(
        key: ValueKey<String>(groupChat.latestMessage!.content),
        children: [
          Text(
            _getSenderName(groupChat, appModel.user),
            style: kText14Weight400_Light,
          ),
          Flexible(
            child: Text(
              content,
              style: kText14Weight400_Light,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            " - ${groupChat.latestMessage!.hhmmSendTime}",
            style: kText14Weight400_Light,
          ),
          16.horSp,
        ],
      ),
    );
  }
}
