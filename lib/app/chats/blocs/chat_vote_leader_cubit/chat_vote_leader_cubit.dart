import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youreal/app/chats/models/chat_vote_leader_item.dart';

import 'package:youreal/common/utils/nullable.dart';

import 'package:youreal/services/domain/auth/models/user.dart';

part 'chat_vote_leader_state.dart';

class ChatVoteLeaderCubit extends Cubit<ChatVoteLeaderState> {
  ChatVoteLeaderCubit() : super(ChatVoteLeaderState.initial());

  void submitItems(List<ChatVoteLeaderItem> items) =>
      emit(state.copyWith(items: [...items]));

  void onVoteChanged(User? user) {
    emit(state.copyWith(votedUser: Nullable<User?>(user)));
  }

  void onVoteUpdated(List<ChatVoteLeaderItem> newItems) {
    final oldItems = [...state.items];
    for (ChatVoteLeaderItem item in newItems) {
      ChatVoteLeaderItem found = oldItems
          .firstWhere((element) => element.user.userId == item.user.userId);
      found = item;
    }
    emit(state.copyWith(items: [...oldItems]));
  }

  void onVoteLeaderViewChanged(int index) =>
      emit(state.copyWith(pageIndex: index));
}
