import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/chats/models/chat_vote_leader_item.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/services/domain/auth/models/user.dart';

import '../radio_group.dart';

class VoteLeaderView extends StatefulWidget {
  const VoteLeaderView({
    Key? key,
  }) : super(key: key);

  @override
  State<VoteLeaderView> createState() => _VoteLeaderViewState();
}

class _VoteLeaderViewState extends State<VoteLeaderView> {
  late final List<User> tempLeader;

  late final List<ChatVoteLeaderItem> voteItems;

  @override
  void initState() {
    tempLeader =
        ChatDetailBloc.dataMemberLeader.map((e) => User.fromJson(e)).toList();
    voteItems = tempLeader
        .map(
            (e) => ChatVoteLeaderItem(user: e, votes: tempLeader.sublist(0, 3)))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Danh sách đề cử vị trí Leader 10/2021",
          style: kText18Weight500_Light,
        ),
        SizedBox(height: 32.h),
        Expanded(
          child: SingleChildScrollView(
            child: RadioGroup<ChatVoteLeaderItem>(
              items: voteItems
                  .map((e) => RadioState<ChatVoteLeaderItem>(
                      title: "${e.user.firstName} ${e.user.lastName}",
                      value: e))
                  .toList(),
              onCheckChanged: (val) {},
              shape: BoxShape.circle,
              size: 20.w,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              unCheckedBorderColor: yrColorLight,
              checkedFillColor: Colors.transparent,
              separator: Divider(
                thickness: 1.h,
                color: yrColorSecondary,
              ),
              style: kText14Weight400_Light,
              icon: Container(
                decoration: const BoxDecoration(
                  color: yrColorLight,
                  shape: BoxShape.circle,
                ),
                width: 10.w,
                height: 10.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
