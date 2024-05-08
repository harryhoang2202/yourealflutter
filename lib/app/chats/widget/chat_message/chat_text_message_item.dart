import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

abstract class ChatMessageItem {
  MessagePosition get position;
  String get name;
  bool get isMe;

  Widget copyWith({
    String? name,
    bool? isMe,
    MessagePosition? position,
  });
}

class ChatTextMessageItem extends StatelessWidget implements ChatMessageItem {
  final String role;
  @override
  final String name;
  final String content;
  final String time;
  @override
  final bool isMe;
  @override
  final MessagePosition position;

  const ChatTextMessageItem({
    Key? key,
    required this.role,
    required this.name,
    required this.content,
    required this.time,
    required this.position,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final BorderRadius borderRadius;

    /// Default radius for
    /// bottom right,bottom left, top right ,top left
    double bl = 16.w, br = 16.w, tr = 16.w, tl = 16.w;
    switch (position) {
      case MessagePosition.First:
        if (isMe) {
          br = 4.w;
        } else {
          bl = 4.w;
        }
        break;
      case MessagePosition.Middle:
        if (isMe) {
          br = 4.w;
          tr = 4.w;
        } else {
          bl = 4.w;
          tl = 4.w;
        }
        break;
      case MessagePosition.Last:
        if (isMe) {
          tr = 4.w;
        } else {
          tl = 4.w;
        }
        break;
      case MessagePosition.Single:
        break;
    }

    borderRadius = BorderRadius.only(
        topLeft: Radius.circular(tl),
        topRight: Radius.circular(tr),
        bottomLeft: Radius.circular(bl),
        bottomRight: Radius.circular(br));

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
        Material(
          color: isMe ? yrColorLight : yrColorSecondary,
          borderRadius: borderRadius,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onLongPress: () async {
              await FlutterClipboard.copy(content);
              Utils.showInfoSnackBar(context,
                  message: "Đã copy vào bộ nhớ đệm");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              margin: EdgeInsets.only(bottom: 2.h),
              child: Text(
                content,
                style: isMe ? kText14Weight400_Primary : kText14Weight400_Light,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  ChatTextMessageItem copyWith({
    String? role,
    String? name,
    String? content,
    String? time,
    bool? isMe,
    MessagePosition? position,
  }) {
    return ChatTextMessageItem(
      role: role ?? this.role,
      name: name ?? this.name,
      content: content ?? this.content,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
      position: position ?? this.position,
    );
  }
}
