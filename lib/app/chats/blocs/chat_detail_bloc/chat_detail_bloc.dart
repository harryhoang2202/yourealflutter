import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tuple/tuple.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_cubit/chat_cubit.dart';
import 'package:youreal/app/chats/models/group_chat.dart';
import 'package:youreal/app/chats/widget/chat_item.dart';
import 'package:youreal/app/chats/widget/chat_message/chat_image_message_item.dart';
import 'package:youreal/app/chats/widget/chat_message/chat_special_message_item.dart';
import 'package:youreal/app/chats/widget/chat_message/chat_text_message_item.dart';

import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/message.dart';

import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/services/services_api.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  ChatDetailBloc(this.groupChat, AuthBloc authBloc, ChatCubit chatCubit)
      : super(ChatDetailState.initial(groupChat)) {
    _mapEventToState();

    user = (authBloc.state as AuthStateAuthenticated).user;
    loginSubscription = authBloc.stream.asBroadcastStream().listen((state) {
      state.whenOrNull(
        authenticated: (user) {
          this.user = user;
        },
      );
    });
    chatSubscription = chatCubit.stream.listen((state) {
      if (state.newMessages.isNotEmpty) _listenToChatEvent(state.newMessages);
    });

    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  TextEditingController messageController = TextEditingController();
  late StreamSubscription loginSubscription;
  late StreamSubscription chatSubscription;
  late User user;
  final pagingController = PagingController<int, ChatItem>(firstPageKey: 0);
  final _services = APIServices();
  final _pageSize = 15;
  final GroupChat groupChat;

  Future<void> _fetchPage(int lastId) async {
    printLog("[$runtimeType] fetching chat history $lastId");
    try {
      final result = await loadMessage(
        dealId: groupChat.id,
        lastMessageId: lastId,
        oldChatItems: state.chatItems,
        oldMessages: state.messages,
      );
      final isLastPage = result.item3 == -1;
      emit(
        state.copyWith(
          chatItems: result.item2,
          messages: result.item1,
        ),
      );
      if (isLastPage) {
        pagingController.value = PagingState(
          itemList: state.chatItems,
        );
      } else {
        final nextPageKey = result.item3;
        pagingController.value = PagingState(
          nextPageKey: nextPageKey,
          itemList: state.chatItems,
        );
      }
    } on DioError catch (error) {
      pagingController.value = PagingState(
        nextPageKey: lastId,
        error: error,
      );
      printLog(
          "[$runtimeType] fetch page error lastId:$lastId ${error.response?.data} ${error.message}");
    }
  }

  void _listenToChatEvent(List<Message> messages) {
    final filteredMessages = messages
        .where((element) => element.dealId == state.groupChat.id)
        .toList();
    add(ChatDetailMessageReceived(filteredMessages));
  }

  @override
  Future<void> close() {
    loginSubscription.cancel();
    messageController.dispose();
    pagingController.dispose();
    chatSubscription.cancel();
    return super.close();
  }

  //region mapEventToState
  void _mapEventToState() {
    on<ChatDetailTextMessageSent>(_textMessageSentToState);
    on<ChatDetailMessageReceived>(_mapChatDetailMessageReceivedToState);
    on<ChatDetailTypingToggled>(_mapChatDetailTypingToggledToState);
    on<ChatDetailNotificationToggled>(_mapChatDetailNotificationToggledToState);
    on<ChatDetailRefreshed>(_mapChatDetailRefreshedToState);
    on<ChatDetailImageMessageSent>(_mapChatDetailImageMessageSentToState);
  }

  _mapChatDetailMessageReceivedToState(
      ChatDetailMessageReceived event, emit) async {
    final newMessage = event.message;
    final chatItems = _addNewMessage(
      newMessage,
      [...state.chatItems],
    );

    emit(
      state.copyWith(
        chatItems: chatItems,
        messages: [...state.messages, ...newMessage],
      ),
    );
    pagingController.value = PagingState(
      nextPageKey: pagingController.value.nextPageKey,
      itemList: state.chatItems,
    );
  }

  _mapChatDetailTypingToggledToState(
      ChatDetailTypingToggled event, emit) async {
    if (event.value != state.isTyping) {
      emit(state.copyWith(isTyping: event.value));
    }
  }

  _mapChatDetailNotificationToggledToState(
      ChatDetailNotificationToggled event, emit) async {
    emit(state.copyWith(acceptNotification: event.value));
  }

  _mapChatDetailRefreshedToState(ChatDetailRefreshed event, emit) async {
    emit(ChatDetailState.initial(groupChat));
    pagingController.refresh();
  }

  FutureOr<void> _textMessageSentToState(
      ChatDetailTextMessageSent event, Emitter<ChatDetailState> emit) async {
    if (event.content.isNotEmpty) {
      await _services.sendChat(
          dealId: state.groupChat.id, content: event.content);
    }
  }

  FutureOr<void> _mapChatDetailImageMessageSentToState(
      ChatDetailImageMessageSent event, Emitter<ChatDetailState> emit) async {
    emit(state.copyWith(isSendingImageMessage: true));
    final imageUrls = await Future.wait<String?>([
      for (final path in event.images)
        _services.upFile(path: path, type: FileUploadType.Images)
    ]);
    final messageContent = imageUrls.join(",");
    if (messageContent.isNotEmpty) {
      await _services.sendChat(
          dealId: state.groupChat.id, content: messageContent);
    }
    emit(state.copyWith(isSendingImageMessage: false));
  }

  //endregion

  //region function

  Future<Tuple3<List<Message>, List<ChatItem>, int>> loadMessage({
    required int dealId,
    required int lastMessageId,
    List<Message> oldMessages = const [],
    List<ChatItem> oldChatItems = const [],
  }) async {
    assert(oldMessages.isEmpty == oldChatItems.isEmpty);

    final messages = [...oldMessages];
    List<ChatItem> chatItems = [...oldChatItems];
    int lastId = -1;
    try {
      final response = await _services.getHistoryGroupChat(
          dealId: dealId, lastMessageId: lastMessageId, pageSize: _pageSize);
      if (response.isNotEmpty) {
        lastId = response.last.id;
        chatItems = _addHistoryMessage(response, chatItems);

        messages.addAll(response);
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] loadMessage error: ${e.response?.data}");
      return const Tuple3([], [], -1);
    }
    return Tuple3(messages, chatItems, lastId);
  }

  Widget buildChatItemChild(Message message,
      {bool isMe = false, required MessagePosition messagePosition}) {
    final name = '${message.userSend.firstName} ${message.userSend.lastName}';
    if (message.images.isNotEmpty) //image message
    {
      return ChatImageMessageItems(
        images: message.images,
        isMe: isMe,
        position: messagePosition,
        name: name,
      );
    }
    //special message (heart icon)
    else if (message.content.contains(kChatHeartSpecialCode)) {
      return ChatSpecialMessageItem(
        isMe: isMe,
        role: 'Member',
        name: name,
        time: message.hhmmSendTime,
        position: messagePosition,
        content: message.content,
      );
    }
    //text message
    else {
      return ChatTextMessageItem(
        isMe: isMe,
        role: 'Member',
        name: name,
        content: message.content,
        time: message.hhmmSendTime,
        position: messagePosition,
      );
    }
  }

  bool checkIsMe(String senderID) {
    return senderID == user.userId.toString();
  }

  List<ChatItem> _addHistoryMessage(
      List<Message> newMessages, List<ChatItem> chatItems) {
    ///newMesssages chứa message từ mới nhất đến cũ nhất
    ///0= mới nhất, length-1 = cũ nhất

    for (var message in newMessages) {
      //message trước đó có cùng owner với message hiện tại => Nối message
      if (chatItems.isNotEmpty == true &&
          chatItems.last.sender.userId == message.userSend.userId) {
        ChatItem latestChatItem = chatItems.last;
        chatItems.removeLast();

        List<Widget> latestChatItemMessages = latestChatItem.messages;

        //lấy message cuối cùng ra sửa lại border
        Widget firstMessage = latestChatItemMessages.first;

        final checkFirstIsLast = latestChatItemMessages.length == 1;
        latestChatItemMessages.removeAt(0);
        //Nếu message trước đó là message đầu tiên
        if (firstMessage is ChatMessageItem && checkFirstIsLast) {
          //position message trước đó = last
          firstMessage = (firstMessage as ChatMessageItem)
              .copyWith(position: MessagePosition.Last);
        }
        //Nếu message trước đó KHÔNG là message đầu tiên
        else if (firstMessage is ChatMessageItem && !checkFirstIsLast) {
          //position message trước đó = middle
          firstMessage = (firstMessage as ChatMessageItem)
              .copyWith(position: MessagePosition.Middle);
        }
        latestChatItemMessages = [
          buildChatItemChild(
            message,
            isMe: checkIsMe(message.userSend.userId!),
            messagePosition: MessagePosition.First,
          ),
          firstMessage,
          ...latestChatItemMessages,
        ];
        latestChatItem = ChatItem(
          messages: latestChatItemMessages,
          sender: message.userSend,
          isMe: checkIsMe(message.userSend.userId!),
        );
        chatItems.add(latestChatItem);
      } else {
        //Nếu không thì add bình thường (Message cuối cùng của người tiếp theo)

        final newChatItemMessage = buildChatItemChild(
          message,
          isMe: checkIsMe(message.userSend.userId!),
          messagePosition: MessagePosition.First,
        );
        chatItems.add(
          ChatItem(
            isMe: checkIsMe(message.userSend.userId!),
            messages: [newChatItemMessage],
            sender: message.userSend,
          ),
        );
      }
    }
    return [...chatItems];
  }

  List<ChatItem> _addNewMessage(
      List<Message> newMessages, List<ChatItem> chatItems) {
    for (var newMessage in newMessages) {
      //message cuối cùng có cùng owner với message hiện tại => Nối message
      if (chatItems.isNotEmpty &&
          chatItems.first.sender.userId == newMessage.userSend.userId) {
        ChatItem latestChatItem = chatItems.first;
        chatItems.removeAt(0);

        List<Widget> latestChatItemMessages = latestChatItem.messages;

        //lấy message cuối cùng ra sửa lại border
        Widget lastMessage = latestChatItemMessages.last;

        final checkLastIsFirst = latestChatItemMessages.length == 1;
        latestChatItemMessages.removeLast();
        if (lastMessage is ChatTextMessageItem && !checkLastIsFirst) {
          lastMessage = lastMessage.copyWith(position: MessagePosition.Middle);
        }

        latestChatItemMessages.addAll([
          lastMessage,
          buildChatItemChild(
            newMessage,
            isMe: checkIsMe(newMessage.userSend.userId!),
            messagePosition: MessagePosition.Last,
          ),
        ]);
        latestChatItem = ChatItem(
          messages: latestChatItemMessages,
          sender: newMessage.userSend,
          isMe: checkIsMe(newMessage.userSend.userId!),
        );
        chatItems = [latestChatItem, ...chatItems];
      } else {
        //Nếu không thì add bình thường (Message đầu tiên của người tiếp theo)
        final newChatItemMessage = buildChatItemChild(
          newMessage,
          isMe: checkIsMe(newMessage.userSend.userId!),
          messagePosition: MessagePosition.First,
        );
        final newChatItem = ChatItem(
          isMe: checkIsMe(newMessage.userSend.userId!),
          messages: [newChatItemMessage],
          sender: newMessage.userSend,
        );
        chatItems = [newChatItem, ...chatItems];
      }
    }
    return [...chatItems];
  }
//endregion

//region temp data

  //TODO: remove this, for test purpose only

  static const testImage =
      "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg";

  static List<Map<String, dynamic>> listChatDetail = [
    {
      "dealId": 1,
      "userSend": {
        "userId": "1",
        "roleId": 1,
        "roleName": "Member",
        "firstName": "Trương",
        "lastName": "Hưng Huy",
        "dateOfBirth": "2001-03-11T00:00:00",
        "picture": testImage
      },
      "sendTime": "2015-11-11T16:10:00.000+00:00",
      "content": " to go",
      "images": null
    },
    {
      "dealId": 1,
      "userSend": {
        "userId": "2",
        "roleId": 1,
        "roleName": "Leader",
        "firstName": "Hoàng",
        "lastName": "Minh Hồng",
        "dateOfBirth": "1999-02-22T00:00:00",
        "picture": testImage
      },
      "sendTime": "2016-11-11T16:04:00.000+00:00",
      "content": "Hello anation",
      "images": null
    },
    {
      "dealId": 1,
      "userSend": {
        "userId": "2",
        "roleId": 1,
        "roleName": "Leader",
        "firstName": "Hoàng",
        "lastName": "Minh Hồng",
        "dateOfBirth": "1999-02-22T00:00:00",
        "picture": testImage
      },
      "sendTime": "2017-11-11T16:04:00.000+00:00",
      "content":
          "Hello guys, we have discussed about post-corona vacation plan and our decision is to go to Bali. We will have a very big party after this corona ends! These are some images about our destination",
      "images": null
    },
    {
      "dealId": 1,
      "userSend": {
        "userId": "2",
        "roleId": 1,
        "roleName": "Leader",
        "firstName": "Hoàng",
        "lastName": "Minh Hồng",
        "dateOfBirth": "1999-02-22T00:00:00",
        "picture": testImage
      },
      "sendTime": "2017-11-11T16:05:00.000+00:00",
      "content": null,
      "images": [testImage, testImage, testImage]
    },
    {
      "dealId": 1,
      "userSend": {
        "userId": "1",
        "roleId": 1,
        "roleName": "Member",
        "firstName": "Trương",
        "lastName": "Hưng Huy",
        "dateOfBirth": "2001-03-11T00:00:00",
        "picture": testImage
      },
      "sendTime": "2017-11-11T16:10:00.000+00:00",
      "content":
          "That’s very nice place! you guys made a very good decision. Can’t wait to go on vacation!",
      "images": null
    },
  ];
  static List<Map<String, dynamic>> dataMemberLeader = [
    {
      "userId": "1",
      "roleId": 1,
      "roleName": "Member",
      "firstName": "Nguyễn",
      "lastName": "Văn A",
      "dateOfBirth": "2001-03-11T00:00:00",
      "picture": testImage
    },
    {
      "userId": "2",
      "roleId": 1,
      "roleName": "Member",
      "firstName": "Phạm",
      "lastName": "B",
      "dateOfBirth": "2001-03-11T00:00:00",
      "picture": testImage
    },
    {
      "userId": "3",
      "roleId": 1,
      "roleName": "Member",
      "firstName": "Trần",
      "lastName": "Thị N",
      "dateOfBirth": "2001-03-11T00:00:00",
      "picture": testImage
    },
    {
      "userId": "45",
      "roleId": 99,
      "roleName": "Leader",
      "firstName": "Mike",
      "lastName": "Mazowski",
      "dateOfBirth": "2001-03-11T00:00:00",
      "picture": testImage
    },
    {
      "userId": "457",
      "roleId": 100,
      "roleName": "Admin",
      "firstName": "Marvin",
      "lastName": "Robertson",
      "dateOfBirth": "2001-03-11T00:00:00",
      "picture": testImage
    },
    {
      "userId": "4",
      "roleId": 1,
      "roleName": "Member",
      "firstName": "Lê",
      "lastName": "Ngọc T",
      "dateOfBirth": "2001-03-11T00:00:00",
      "picture": testImage
    },
    {
      "userId": "6",
      "roleId": 1,
      "roleName": "Member",
      "firstName": "Nguyễn",
      "lastName": "Văn E",
      "dateOfBirth": "2001-03-11T00:00:00",
      "picture": testImage
    },
    {
      "userId": "7",
      "roleId": 1,
      "roleName": "Member",
      "firstName": "Nguyễn",
      "lastName": "Văn F",
      "dateOfBirth": "2001-03-11T00:00:00",
      "picture": testImage
    },
  ];

//endregion
}
