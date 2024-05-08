import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tvt_gallery/tvt_gallery.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_cubit/chat_cubit.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';
import 'package:youreal/app/chats/models/group_chat.dart';
import 'package:youreal/app/chats/widget/chat_input_row.dart';
import 'package:youreal/app/chats/widget/chat_item.dart';
import 'package:youreal/app/chats/widget/chat_option/bottom_button.dart';
import 'package:youreal/app/chats/widget/chat_option/chat_option_row.dart';
import 'package:youreal/app/chats/widget/chat_option/deal_option_bottom_sheet.dart';
import 'package:youreal/app/chats/widget/chat_option/padding_panel.dart';
import 'package:youreal/app/chats/widget/emoji_view.dart';
import 'package:youreal/app/chats/widget/heart_widget.dart';
import 'package:youreal/app/chats/widget/list_chat_message.dart';
import 'package:youreal/app/menu/menu.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'chat_detail_info_screen.dart';

class ChatDetailArgs {
  final GroupChat groupChat;
  final AuthBloc authBloc;
  final ChatCubit chatCubit;

  ChatDetailArgs({
    required this.groupChat,
    required this.authBloc,
    required this.chatCubit,
  });
}

class ChatDetailScreen extends StatelessWidget {
  final _key = GlobalKey<ScaffoldState>();
  static const id = "ChatDetailScreen";

  ChatDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: context.read<ChatInputBloc>().dealOptionPanelController,
      defaultPanelState: PanelState.HIDDEN,
      minHeight: PaddingPanel.kPanelContainerMinHeight,
      maxHeight: PaddingPanel.kPanelContainerMaxHeight,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom +
              (Platform.isAndroid ? 16.h : 0)),
      //padding: EdgeInsets.zero,
      boxShadow: null,
      color: yrColorSecondary,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.r),
      ),
      backdropEnabled: false,
      panel: const DealOptionBottomSheet(),
      footer: const BottomButton(),
      body: GalleryViewWrapper(
        backgroundColor: yrColorPrimary,
        controller: context.read<ChatInputBloc>().galleryPickerController,
        child: Scaffold(
          key: _key,
          backgroundColor: yrColorPrimary,
          drawer: const Menu(),
          drawerEnableOpenDragGesture: false,
          //region appbar
          appBar: AppBar(
            backgroundColor: yrColorPrimary,
            elevation: 0,
            leading: const YrBackButton(),
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
            titleSpacing: 0,
            centerTitle: false,
            actions: [
              IconButton(
                splashRadius: 20.w,
                onPressed: () {
                  Navigator.pushNamed(context, ChatDetailInfoScreen.id,
                      arguments: context.read<ChatDetailBloc>());
                },
                icon: SvgPicture.asset(
                  'assets/icons/ic_menu_dots.svg',
                  height: 24.w,
                  width: 24.w,
                ),
              ),
            ],
          ),
          //endregion appbar
          body: Column(
            children: [
              const Expanded(
                child: ListChatMessage(),
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: HeartWidget(),
              ),
              const SendingImageLoadingIndicator(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                child: Row(
                  children: const [
                    ChatOptionRow(),
                    Flexible(
                      child: ChatInputRow(),
                    ),
                  ],
                ),
              ),
              const EmojiView(),
              const PaddingPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

class SendingImageLoadingIndicator extends StatelessWidget {
  const SendingImageLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: BlocSelector<ChatDetailBloc, ChatDetailState, bool>(
        selector: (state) => state.isSendingImageMessage,
        builder: (context, isSendingImageMessage) {
          return Visibility(
            visible: isSendingImageMessage,
            child: Container(
              padding: EdgeInsets.only(left: 16.w, right: 8.w, bottom: 16.w),
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      color: yrColorLight,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.w),
                        topLeft: Radius.circular(16.w),
                        topRight: Radius.circular(16.w),
                        bottomRight: Radius.circular(4.w),
                      ),
                    ),
                    child: SpinKitThreeBounce(
                      color: yrColorPrimary,
                      size: 16.w,
                    ),
                  ),
                  8.horSp,
                  ChatAvatar(
                    imageUrl: context.read<AppModel>().user.picture!,
                    status: true,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/*
 [
    ChatItem(
      isMe: true,
      messages: [
        ChatMessageTextItem(
          isMe: true,
          name: '',
          role: '',
          time: '16.04',
          content:
              'That’s very nice place! you guys made a very good decision. Can’t wait to go on vacation!',
        ),
      ],
    ),
    ChatItem(
      messages: [
        ChatMessageTextItem(
          name: 'Mike Mazowski',
          role: 'Leader',
          time: '16.04',
          content:
              'Hello guys, we have discussed about post-corona vacation plan and our decision is to go to Bali. We will have a very big party after this corona ends! These are some images about our destination',
        ),
        ChatMessageImageItems(
          images: [
            ChatDetailProvider.testImage,
            ChatDetailProvider.testImage,
            ChatDetailProvider.testImage,
            ChatDetailProvider.testImage,
          ],
        ),
        ChatMessageTextItem(
          name: 'Mike Mazowski',
          role: 'Leader',
          time: '16.04',
          content:
              'Hello guys, we have discussed about post-corona vacation plan and our decision is to go to Bali. We will have a very big party after this corona ends! These are some images about our destination',
        ),
        ChatMessageTextItem(
          name: 'Mike Mazowski',
          role: 'Leader',
          time: '16.04',
          content:
              'Hello guys, we have discussed about post-corona vacation plan and our decision is to go to Bali. We will have a very big party after this corona ends! These are some images about our destination',
        ),
        ChatMessageImageItems(
          images: [
            ChatDetailProvider.testImage,
            ChatDetailProvider.testImage,
            ChatDetailProvider.testImage,
            ChatDetailProvider.testImage,
          ],
        ),
      ],
    ),
    ChatItem(
      isMe: true,
      messages: [
        ChatMessageTextItem(
          isMe: true,
          name: '',
          role: '',
          time: '16.04',
          content:
              'That’s very nice place! you guys made a very good decision. Can’t wait to go on vacation!',
        ),
      ],
    )
  ];
* */
