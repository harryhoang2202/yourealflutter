import 'package:equatable/equatable.dart';
import 'package:youreal/services/domain/auth/models/user.dart';

class ChatVoteLeaderItem extends Equatable {
  final User user;
  final List<User> votes;
  @override
  List<Object?> get props => [votes, user];
//<editor-fold desc="Data Methods">

  const ChatVoteLeaderItem({
    required this.user,
    required this.votes,
  });

  @override
  String toString() {
    return 'ChatVoteLeaderItem{ user: $user, votes: $votes,}';
  }

  ChatVoteLeaderItem copyWith({
    User? user,
    List<User>? votes,
  }) {
    return ChatVoteLeaderItem(
      user: user ?? this.user,
      votes: votes ?? this.votes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'votes': votes,
    };
  }

  factory ChatVoteLeaderItem.fromMap(Map<String, dynamic> map) {
    return ChatVoteLeaderItem(
      user: map['user'] as User,
      votes: map['votes'] as List<User>,
    );
  }

//</editor-fold>
}
