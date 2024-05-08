import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvt_tab_bar/tvt_tab_bar.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/constants/enums.dart';

class EmojiView extends StatelessWidget {
  const EmojiView({
    Key? key,
  }) : super(key: key);

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatDetailBloc>(context, listen: false);
    final chatInputBloc =
        BlocProvider.of<ChatInputBloc>(context, listen: false);
    return BlocSelector<ChatInputBloc, ChatInputState, InputOption>(
      selector: (state) => state.inputOption,
      builder: (context, inputOption) {
        return NestedWillPopScope(
          onWillPop: () async {
            if (inputOption == InputOption.Emoji) {
              chatInputBloc
                  .add(ChatInputOptionChanged(InputOption.Idle, context));
              return false;
            }
            return true;
          },
          child: Visibility(
            visible: inputOption == InputOption.Emoji,
            child: Flexible(
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  chatBloc.messageController.text += emoji.emoji;
                  chatBloc.add(const ChatDetailTypingToggled(true));
                },
                onBackspacePressed: () {
                  final text = chatBloc.messageController.text;
                  if (text.isNotEmpty) {
                    chatBloc.add(const ChatDetailTypingToggled(true));

                    int deleteChar =
                        _isUtf16Surrogate(text.codeUnitAt(text.length - 1))
                            ? 2
                            : 1;
                    chatBloc.messageController.text =
                        text.substring(0, text.length - deleteChar);
                  }
                },
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  initCategory: Category.SMILEYS,
                  bgColor: yrColorSecondary,
                  iconColor: yrColorLight,
                  iconColorSelected: yrColorPrimary,
                  indicatorColor: yrColorPrimary,
                  // progressIndicatorColor: yrColorPrimary,
                  showRecentsTab: true,
                  recentsLimit: 28,
                  // noRecents: Text(
                  //   "No Recents",
                  //   style: const TextStyle(fontSize: 20, color: Colors.black26),
                  // ),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: Platform.isIOS
                      ? ButtonMode.CUPERTINO
                      : ButtonMode.MATERIAL,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
