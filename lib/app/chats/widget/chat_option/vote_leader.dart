import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/blocs/chat_vote_leader_cubit/chat_vote_leader_cubit.dart';

import 'create_vote_leader_view.dart';
import 'vote_leader_view.dart';

class VoteLeader extends StatefulWidget {
  const VoteLeader({Key? key}) : super(key: key);

  @override
  _VoteLeaderState createState() => _VoteLeaderState();
}

class _VoteLeaderState extends State<VoteLeader> {
  final views = [
    const CreateVoteLeaderView(),
    const VoteLeaderView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatVoteLeaderCubit, ChatVoteLeaderState, int>(
      selector: (state) {
        return state.pageIndex;
      },
      builder: (context, pageIndex) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: views[pageIndex],
        );
      },
    );
  }
}
