import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuple/tuple.dart';
import 'package:youreal/app/chats/blocs/chat_cubit/chat_cubit.dart';
import 'package:youreal/app/chats/models/group_chat.dart';
import 'package:youreal/app/menu/menu.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/widgets_common/notification_button.dart';
import 'package:youreal/widgets_common/search_bar.dart';

import 'group_chat_item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const id = "ChatScreen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _key = GlobalKey<ScaffoldState>();
  late ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = context.read<ChatCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: yrColorLight,
            size: 38.w,
          ),
        ),
        title: Text(
          "Chat",
          style: kText28_Light,
        ),
        actions: const [
          NotificationButton(),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          SearchBar(
            // hintText: "Nhập mã Deal...",
            onSubmit: (dealCode) {},
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: BlocSelector<ChatCubit, ChatState,
                Tuple2<List<GroupChat>, bool>>(
              selector: (state) => Tuple2(state.groups, state.isLoading),
              builder: (context, tuple) {
                final groupChats = tuple.item1;
                final isLoading = tuple.item2;
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: yrColorLight,
                    ),
                  );
                }
                return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  physics: const BouncingScrollPhysics(),
                  header: WaterDropHeader(
                    waterDropColor: yrColorLight,
                    complete: Container(),
                    refresh: const CircularProgressIndicator(
                      color: yrColorLight,
                    ),
                  ),
                  controller: _chatCubit.refreshController,
                  onRefresh: () => _chatCubit.getListGroupChat(),
                  child: ListView.separated(
                    itemCount: groupChats.length,
                    padding: EdgeInsets.only(bottom: 50.w),
                    itemBuilder: (_, index) {
                      return GroupChatItem(groupChat: groupChats[index]);
                    },
                    separatorBuilder: (_, index) {
                      return const Divider(
                        color: yrColorSecondary,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
