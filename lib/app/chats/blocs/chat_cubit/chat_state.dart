part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final List<GroupChat> groups;
  final List<Message> newMessages;
  final bool isLoading;

  @override
  List<Object?> get props => [
        groups,
        newMessages,
        isLoading,
      ];
  factory ChatState.initial() {
    return const ChatState(groups: [], newMessages: [], isLoading: false);
  }

//<editor-fold desc="Data Methods">

  const ChatState({
    required this.groups,
    required this.newMessages,
    required this.isLoading,
  });

  @override
  String toString() {
    return 'ChatState{ groups: $groups, newMessages: $newMessages, isLoading: $isLoading,}';
  }

  ChatState copyWith({
    List<GroupChat>? groups,
    Nullable<GroupChat?>? selectedGroup,
    List<Message>? newMessages,
    bool? isLoading,
  }) {
    return ChatState(
      groups: groups ?? this.groups,
      newMessages: newMessages ?? this.newMessages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groups': groups,
      'newMessages': newMessages,
      'isLoading': isLoading,
    };
  }

  factory ChatState.fromMap(Map<String, dynamic> map) {
    return ChatState(
      groups: map['groups'] as List<GroupChat>,
      newMessages: map['newMessages'] as List<Message>,
      isLoading: map['isLoading'] as bool,
    );
  }

//</editor-fold>
}
