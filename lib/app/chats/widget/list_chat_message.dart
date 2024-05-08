import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';

import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

import 'package:youreal/widgets_common/lazy_list_error.dart';

import 'chat_item.dart';
import 'typing_row.dart';

class ListChatMessage extends StatelessWidget {
  const ListChatMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatDetailBloc>();
    bool isTyping = false;

    return Stack(
      children: [
        PagedListView.separated(
          pagingController: bloc.pagingController,
          physics: const BouncingScrollPhysics(),
          builderDelegate: PagedChildBuilderDelegate<ChatItem>(
            itemBuilder: (context, item, index) {
              final itemList = bloc.pagingController.value.itemList ?? [];
              return itemList[index];
            },
            firstPageErrorIndicatorBuilder: (context) {
              return LazyListError(
                onTap: () {
                  bloc.add(const ChatDetailRefreshed());
                },
              );
            },
            newPageErrorIndicatorBuilder: (context) {
              return LazyListError(
                onTap: () {
                  bloc.add(const ChatDetailRefreshed());
                },
              );
            },
            noItemsFoundIndicatorBuilder: (context) {
              return Center(
                child: Text(
                  "Chưa có tin nhắn.",
                  style: kText14_Light,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 48.h,
              bottom: isTyping ? 48.h : 24.h),
          reverse: true,
          separatorBuilder: (_, __) => 24.verSp,
        ),
        Visibility(
          //visible: isTyping,
          visible: false,
          child: Positioned(
            bottom: 25.h,
            child: TypingRow(images: [
              Image.asset(
                'assets/images/avatar.png',
                fit: BoxFit.fill,
              ),
              Image.asset(
                'assets/images/avatar.png',
                fit: BoxFit.fill,
              ),
              Image.asset(
                'assets/images/avatar.png',
                fit: BoxFit.fill,
              )
            ]),
          ),
        ),
      ],
    );
  }
}
