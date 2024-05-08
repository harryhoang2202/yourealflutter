part of 'chat_detail_bloc.dart';

@immutable
abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();
}

class ChatDetailMessageReceived extends ChatDetailEvent {
  final List<Message> message;

  const ChatDetailMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatDetailTypingToggled extends ChatDetailEvent {
  final bool value;

  const ChatDetailTypingToggled(this.value);

  @override
  List<Object?> get props => [value];
}

class ChatDetailNotificationToggled extends ChatDetailEvent {
  final bool value;

  const ChatDetailNotificationToggled(this.value);

  @override
  List<Object?> get props => [value];
}

class ChatDetailRefreshed extends ChatDetailEvent {
  const ChatDetailRefreshed();

  @override
  List<Object?> get props => [];
}

class ChatDetailTextMessageSent extends ChatDetailEvent {
  final String content;

  const ChatDetailTextMessageSent(this.content);

  @override
  List<Object?> get props => [content];
}

class ChatDetailImageMessageSent extends ChatDetailEvent {
  final List<String> images;

  const ChatDetailImageMessageSent(this.images);

  @override
  List<Object?> get props => [images];
}
