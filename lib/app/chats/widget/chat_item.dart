import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/services/domain/auth/models/user.dart';

class ChatItem extends StatelessWidget {
  final bool isMe;
  final User sender;
  final List<Widget> messages;

  ///Chat Item là 1 chuỗi message liên tiếp nhau của 1 user
  const ChatItem({Key? key, isMe, required this.messages, required this.sender})
      : isMe = isMe ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    late final List<Widget> children;
    if (isMe) {
      children = [
        ChatAvatar(
          imageUrl: sender.picture!,
          status: true,
        ),
        SizedBox(
          width: 8.w,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 290.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: messages,
          ),
        ),
      ].reversed.toList();
    } else {
      children = [
        ChatAvatar(
          imageUrl: sender.picture!,
          status: true,
        ),
        SizedBox(
          width: 8.w,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 290.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: messages,
          ),
        ),
      ];
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: children,
    );
  }
}

class ChatAvatar extends StatelessWidget {
  final String imageUrl;
  final bool status;

  const ChatAvatar({Key? key, required this.imageUrl, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imgProvider) => CircleAvatar(
            backgroundImage: imgProvider,
            radius: 20.w,
          ),
          errorWidget: (_, __, ___) => CircleAvatar(
            backgroundColor: yrColorHint,
            child: const Center(
              child: Icon(
                Icons.broken_image,
                color: yrColorPrimary,
              ),
            ),
            radius: 20.w,
          ),
        ),
        if (status)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 14.w,
              width: 14.w,
              decoration: BoxDecoration(
                color: status ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
            ),
          ),
      ],
    );
  }
}
