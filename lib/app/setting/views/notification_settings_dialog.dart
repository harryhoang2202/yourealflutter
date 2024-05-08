import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:signalr_core/signalr_core.dart';
import 'package:youreal/app/chats/blocs/chat_cubit/chat_cubit.dart';
import 'package:youreal/common/config/color_config.dart';

class NotificationSettingsDialog extends StatefulWidget {
  const NotificationSettingsDialog({Key? key}) : super(key: key);

  static NotificationSettingsDialog getInstance() {
    return const NotificationSettingsDialog();
  }

  @override
  State<NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends State<NotificationSettingsDialog> {
  bool socketConnected = false;
  late ChatCubit _chatCubit;
  @override
  void initState() {
    super.initState();
    _chatCubit = context.read<ChatCubit>();
    socketConnected =
        _chatCubit.connection?.state == HubConnectionState.connected;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
              color: yrColorLight, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Switch connection state"),
                  BlocSelector<ChatCubit, ChatState, bool>(
                    selector: (state) => state.isLoading,
                    builder: (context, isLoading) {
                      return SizedBox.fromSize(
                        size: Size(24.w, 24.w),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isLoading
                              ? const CircularProgressIndicator.adaptive()
                              : const SizedBox.shrink(),
                        ),
                      );
                    },
                  ),
                  Switch.adaptive(
                    value: socketConnected,
                    onChanged: (value) async {
                      if (value == false) {
                        await _chatCubit.stopSocketConnection();
                      } else {
                        await _chatCubit.startSocketConnection();
                      }
                      setState(() {
                        socketConnected = value;
                      });
                    },
                  ),
                ],
              ),
              Text(
                  "Current connection state: \n${_chatCubit.connection?.state}")
            ],
          ),
        ),
      ),
    );
  }
}
