part of 'chat_vote_leader_cubit.dart';

class ChatVoteLeaderState extends Equatable {
  final List<ChatVoteLeaderItem> items;
  final User? votedUser;
  final int pageIndex;
  @override
  List<Object?> get props => [items, votedUser, pageIndex];
  factory ChatVoteLeaderState.initial() => const ChatVoteLeaderState(
        items: [],
        votedUser: null,
        pageIndex: 0,
      );

//<editor-fold desc="Data Methods">

  const ChatVoteLeaderState({
    required this.items,
    this.votedUser,
    required this.pageIndex,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatVoteLeaderState &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          votedUser == other.votedUser &&
          pageIndex == other.pageIndex);

  @override
  int get hashCode => items.hashCode ^ votedUser.hashCode ^ pageIndex.hashCode;

  @override
  String toString() {
    return 'ChatVoteLeaderState{ items: $items, votedUser: $votedUser, pageIndex: $pageIndex,}';
  }

  ChatVoteLeaderState copyWith({
    List<ChatVoteLeaderItem>? items,
    Nullable<User?>? votedUser,
    int? pageIndex,
  }) {
    return ChatVoteLeaderState(
      items: items ?? this.items,
      votedUser: votedUser == null ? this.votedUser : votedUser.value,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'votedUser': votedUser,
      'pageIndex': pageIndex,
    };
  }

  factory ChatVoteLeaderState.fromMap(Map<String, dynamic> map) {
    return ChatVoteLeaderState(
      items: map['items'] as List<ChatVoteLeaderItem>,
      votedUser: map['votedUser'] as User,
      pageIndex: map['pageIndex'] as int,
    );
  }

//</editor-fold>
}
