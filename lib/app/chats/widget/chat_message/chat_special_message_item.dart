import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';

import 'chat_text_message_item.dart';

class ChatSpecialMessageItem extends StatelessWidget
    implements ChatMessageItem {
  final String role;
  @override
  final String name;
  final String time;
  @override
  final bool isMe;
  final String content;
  @override
  final MessagePosition position;
  const ChatSpecialMessageItem({
    Key? key,
    required this.role,
    required this.name,
    required this.time,
    isMe,
    required this.position,
    required this.content,
  })  : isMe = isMe ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = double.tryParse(content.split(",").last) ?? 1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (position == MessagePosition.First && !isMe)
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              name,
              style: kText14Weight400_Accent,
            ),
          ),
        SvgPicture.asset(
          getIcon("ic_heart.svg"),
          color: yrColorError,
          width: kHeartMessageMaxHeight.w * scale,
          height: kHeartMessageMaxHeight.w * scale,
        ),
      ],
    );
  }

  @override
  ChatSpecialMessageItem copyWith({
    String? role,
    String? name,
    String? time,
    bool? isMe,
    String? content,
    MessagePosition? position,
  }) {
    return ChatSpecialMessageItem(
      role: role ?? this.role,
      name: name ?? this.name,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
      content: content ?? this.content,
      position: position ?? this.position,
    );
  }
}
