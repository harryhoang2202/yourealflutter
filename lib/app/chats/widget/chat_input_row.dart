import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';
import 'package:youreal/app/chats/blocs/heart_cubit/heart_cubit.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/message.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/view_models/app_model.dart';

import 'chat_option/chat_option_row.dart';

class ChatInputRow extends StatefulWidget {
  const ChatInputRow({Key? key}) : super(key: key);

  @override
  State<ChatInputRow> createState() => _ChatInputRowState();
}

class _ChatInputRowState extends State<ChatInputRow> {
  late StreamSubscription<bool> keyboardSubscription;

  late ChatDetailBloc chatBloc;
  late ChatInputBloc chatInputBloc;
  late HeartCubit heartCubit;
  late AppModel appModel;
  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    chatInputBloc = context.read<ChatInputBloc>();
    chatBloc = context.read<ChatDetailBloc>();
    heartCubit = context.read<HeartCubit>();
    appModel = context.read<AppModel>();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      chatInputBloc.add(ChatInputKeyboardVisibilityChanged(visible));
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatInputBloc, ChatInputState, bool>(
      selector: (state) => state.isTextFieldExpanded,
      builder: (context, isTextFieldExpanded) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 16.w),
            Flexible(
                child: AnimatedContainer(
              constraints: BoxConstraints(
                minWidth: 210.w,
              ),
              width: isTextFieldExpanded
                  ? 1.sw
                  : 300.w, //184.w if enable location and add icon.
              duration: const Duration(milliseconds: 200),
              child: TextFormField(
                onChanged: (String val) async {
                  if (val.isEmpty) {
                    chatBloc.add(const ChatDetailTypingToggled(false));
                    chatInputBloc
                        .add(const ChatInputTextFieldExpandedChanged(false));
                  } else {
                    chatBloc.add(const ChatDetailTypingToggled(true));
                    chatInputBloc
                        .add(const ChatInputTextFieldExpandedChanged(true));
                  }
                },
                controller: chatBloc.messageController,
                onTap: () {
                  chatInputBloc
                      .add(const ChatInputTextFieldExpandedChanged(true));
                  chatInputBloc
                      .add(ChatInputOptionChanged(InputOption.Idle, context));
                },
                style: kText14Weight400_Light,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: yrColorSecondary,
                  hintText: 'Aa',
                  hintStyle: kText14Weight400_Light,
                  isDense: true,
                  isCollapsed: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Center(
                      child: Material(
                        shape: const CircleBorder(),
                        color: Colors.transparent,
                        child: ChatOptionIcon(
                          iconName: "ic_smile",
                          onTap: () {
                            Utils.hideKeyboard(context);
                            chatInputBloc.add(ChatInputOptionChanged(
                                InputOption.Emoji, context));
                          },
                        ),
                      ),
                    ),
                  ),
                  suffixIconConstraints:
                      BoxConstraints.tightFor(width: 40.w, height: 36.w),
                ).allBorder(
                  OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            )),
            SizedBox(width: 16.w),
            BlocSelector<ChatDetailBloc, ChatDetailState, bool>(
              selector: (state) {
                return state.isTyping;
              },
              builder: (context, isTyping) {
                return ChatOptionIcon(
                  onTapDown: (_) {
                    if (!isTyping) {
                      heartCubit.forwarded();
                      return;
                    }
                  },
                  onTapCancel: () {
                    heartCubit.reversed((value) {});
                  },
                  onTapUp: (_) {
                    if (isTyping) {
                      String content = chatBloc.messageController.text.trim();

                      if (content.isEmpty) return;
                      final message = Message(
                        dealId: chatBloc.state.groupChat.id,
                        sendTime: DateTime.now(),
                        userSend: appModel.user,
                        images: [],
                        content: content,
                        id: -1,
                      );
                      chatBloc.add(ChatDetailTextMessageSent(message.content));
                      chatBloc.messageController.clear();
                      chatBloc.add(const ChatDetailTypingToggled(false));
                      return;
                    }

                    heartCubit.reversed((value) {
                      if (value == 0) return;
                      final content = "$kChatHeartSpecialCode,$value";
                      final message = Message(
                        dealId: chatBloc.state.groupChat.id,
                        sendTime: DateTime.now(),
                        userSend: appModel.user,
                        images: [],
                        content: content,
                        id: -1,
                      );
                      chatBloc.add(ChatDetailTextMessageSent(message.content));
                      chatBloc.messageController.clear();
                      chatBloc.add(const ChatDetailTypingToggled(false));
                    });
                  },
                  splashRadius: 24.w,
                  iconName: isTyping ? "ic_chat_send" : "ic_heart",
                );
              },
            ),
          ],
        );
      },
    );
  }
}
