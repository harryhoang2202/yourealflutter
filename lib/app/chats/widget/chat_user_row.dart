import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';

import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/services/domain/auth/models/user.dart';

import 'chat_item.dart';

class ChatUserRow extends StatelessWidget {
  const ChatUserRow({
    Key? key,
    required this.currentItem,
  }) : super(key: key);

  final User currentItem;
  Widget _buildRole(String roleName, bool isMe) {
    if (isMe) {
      return Text(
        'Bạn',
        style: kText14Weight400_Dark,
      );
    }
    switch (roleName) {
      case 'Admin':
        return Text(
          'Admin',
          style: kText14Weight400_Accent,
        );
      case 'Leader':
        return Text(
          'Leader',
          style: kText14Weight400_Accent,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        children: [
          ChatAvatar(
            imageUrl: currentItem.picture ?? ChatDetailBloc.testImage,
            status: true,
          ),
          SizedBox(
            width: 16.w,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${currentItem.firstName} ${currentItem.lastName}',
                style: kText14Weight400_Dark,
              ),
              _buildRole(
                  currentItem.roles?.first.name ?? "",
                  BlocProvider.of<ChatDetailBloc>(context, listen: false)
                      .checkIsMe(currentItem.userId!)),
            ],
          ),
        ],
      ),
    );
  }
}
