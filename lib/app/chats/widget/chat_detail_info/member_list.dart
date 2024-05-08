import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/chats/widget/chat_option/create_vote_leader_view.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/domain/auth/models/user.dart';

import '../chat_user_row.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  List<User> sortList(List<User> input) {
    List<User> result = List<User>.filled(3, User(), growable: true);
    List<User> copy = List<User>.from(input);
    for (var us in copy) {
      if (_bloc.checkIsMe(us.userId!)) {
        result[0] = us;
      } else if (checkRole(context, RolesType.DealLeader)) {
        result[1] = us;
      } else if (checkRole(context, RolesType.SuperAdmin) ||
          checkRole(context, RolesType.Admin)) {
        result[2] = us;
      }
    }
    if (result[0].userId == null) {
      result[0] =
          (context.read<AuthBloc>().state as AuthStateAuthenticated).user;
    }
    result.addAll(copy.where((element) => !result.contains(element)));
    return result;
  }

  late final ChatDetailBloc _bloc;
  late final List<User> tempMemberData;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<ChatDetailBloc>(context, listen: false);
    tempMemberData = sortList(CreateVoteLeaderView.tempLeader);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: yrColorLight,
      ),
      padding: EdgeInsets.all(8.w),
      child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thành viên nhóm",
                style: kText18Weight500_Primary,
              ),
              SizedBox(height: 8.w),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/ic_user.svg'),
                  SizedBox(width: 8.w),
                  Text(
                    '${state.groupChat.numberMember} Người',
                    style: kText14Weight400_Primary,
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final Allocation alloc = state.groupChat.allocations[index];
                  User currentItem = User(
                    userId: alloc.userId,
                    lastName: alloc.lastName,
                    firstName: alloc.firstName,

                    // roleName: tempRole[Random().nextInt(tempRole.length)],
                  );
                  return ChatUserRow(currentItem: currentItem);
                },
                itemCount: state.groupChat.allocations.length,
              ),
            ],
          );
        },
      ),
    );
  }
}
