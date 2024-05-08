part of 'chat_detail_bloc.dart';

@immutable
class ChatDetailState extends Equatable {
  final List<ChatItem> chatItems;
  final GroupChat groupChat;
  final bool isTyping;
  final bool acceptNotification;
  final bool isSendingImageMessage;
  final List<Message> messages;
  @override
  List<Object?> get props => [
        chatItems,
        groupChat,
        isTyping,
        acceptNotification,
        isSendingImageMessage,
        messages
      ];
  List<String> get imageChatUrl {
    final imageMessages =
        messages.where((element) => element.images.isNotEmpty);
    final List<String> imageUrls = [];
    for (final message in imageMessages) {
      imageUrls.addAll(message.images);
    }
    return imageUrls;
  }

  factory ChatDetailState.initial(GroupChat groupChat) => ChatDetailState(
        acceptNotification: false,
        isTyping: false,
        groupChat: groupChat,
        chatItems: const [],
        isSendingImageMessage: false,
        messages: const [],
      );

//<editor-fold desc="Data Methods">

  @override
  String toString() {
    return 'ChatDetailState{ chatItems: $chatItems, groupChat: $groupChat, isTyping: $isTyping, acceptNotification: $acceptNotification, isLoading: $isSendingImageMessage, messages: $messages,}';
  }

  const ChatDetailState({
    required this.chatItems,
    required this.groupChat,
    required this.isTyping,
    required this.acceptNotification,
    required this.isSendingImageMessage,
    required this.messages,
  });

  ChatDetailState copyWith({
    List<ChatItem>? chatItems,
    GroupChat? groupChat,
    bool? isTyping,
    bool? acceptNotification,
    bool? isSendingImageMessage,
    List<Message>? messages,
  }) {
    return ChatDetailState(
      chatItems: chatItems ?? this.chatItems,
      groupChat: groupChat ?? this.groupChat,
      isTyping: isTyping ?? this.isTyping,
      acceptNotification: acceptNotification ?? this.acceptNotification,
      isSendingImageMessage:
          isSendingImageMessage ?? this.isSendingImageMessage,
      messages: messages ?? this.messages,
    );
  } //</editor-fold>
}
