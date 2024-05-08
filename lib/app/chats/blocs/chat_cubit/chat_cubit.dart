import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/models/group_chat.dart';

import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/message.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/utils/nullable.dart';

import 'package:youreal/services/services_api.dart';

part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final Stream<AuthState> authStream;
  ChatCubit(@factoryParam this.authStream) : super(ChatState.initial()) {
    authStream.listen((authState) {
      authState.whenOrNull(
        authenticated: (user) {
          getListGroupChat();
          initSignalr();
        },
        unAuthentication: () {
          stopSocketConnection();
        },
      );
    });
  }

  HubConnection? connection;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  void getListGroupChat() async {
    emit(state.copyWith(isLoading: true));
    final listGroupChat = await APIServices()
            .getListGroupChat(page: 1, sessionId: Utils.newSessionId) ??
        [];
    emit(state.copyWith(groups: listGroupChat, isLoading: false));
    refreshController.refreshCompleted();
  }

  void initSignalr() async {
    _toggleLoading(true);
    connection = HubConnectionBuilder()
        .withUrl(
          '${APIServices().url}hub',
          HttpConnectionOptions(
            // logging: (level, message) => printLog(message),
            accessTokenFactory: () => Future.value(APIServices().accessToken),
            transport: HttpTransportType.webSockets,
            skipNegotiation: true,
          ),
        )
        .withAutomaticReconnect()
        .build();
    await startSocketConnection();
    _toggleLoading(false);
  }

  void _toggleLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  Future<void> startSocketConnection() async {
    _toggleLoading(true);

    if (connection?.state == HubConnectionState.disconnected) {
      connection?.on('newChatMessage', _onNewMessageReceived);
      await connection?.start();
    }
    _toggleLoading(false);
  }

  Future<void> stopSocketConnection() async {
    _toggleLoading(true);

    if (connection?.state == HubConnectionState.connected) {
      connection?.off('newChatMessage');
      await connection?.stop();
    }
    _toggleLoading(false);
  }

  void _onNewMessageReceived(List? data) {
    printLog("[$runtimeType] New message received: $data");
    if (data == null) return;

    final List<Message> messages =
        data.map((e) => Message.fromJson(e)).toList();

    ///update GroupChatItem latestMessage
    final groupsClone = [...state.groups];
    for (final message in messages) {
      final groupIndex =
          state.groups.indexWhere((element) => element.id == message.dealId);
      if (groupIndex == -1) {
        continue;
      }
      final updatedGroup =
          groupsClone[groupIndex].copyWith(latestMessage: message);

      groupsClone[groupIndex] = updatedGroup;
    }
    emit(state.copyWith(newMessages: messages, groups: groupsClone));
    emit(state.copyWith(newMessages: []));
  }
}
