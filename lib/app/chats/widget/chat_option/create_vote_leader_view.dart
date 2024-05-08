import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/services/domain/auth/models/user.dart';

class CreateVoteLeaderView extends StatefulWidget {
  const CreateVoteLeaderView({
    Key? key,
  }) : super(key: key);
  static final List<User> tempLeader =
      ChatDetailBloc.dataMemberLeader.map((e) => User.fromJson(e)).toList();

  @override
  State<CreateVoteLeaderView> createState() => _CreateVoteLeaderViewState();
}

class _CreateVoteLeaderViewState extends State<CreateVoteLeaderView> {
  final tempLeader = CreateVoteLeaderView.tempLeader;
  final addLeaderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vote Leader",
            style: kText18Weight500_Light,
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              "Tiêu đề",
              style: kText14Weight400_Light,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: yrColorLight,
            ),
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Text(
              "Danh sách đề cử Leader 10/2021",
              style: kText14Weight400_Dark,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              "Leader đề cử",
              style: kText14Weight400_Light,
            ),
          ),
          SizedBox(height: 4.h),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: yrColorLight,
                  ),
                  width: 1.sw,
                  padding: EdgeInsets.fromLTRB(12.w, 3.h, 4.w, 3.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${tempLeader[index % tempLeader.length].firstName} ${tempLeader[index % tempLeader.length].lastName}",
                        style: kText14Weight400_Dark,
                      ),
                      Material(
                        shape: const CircleBorder(),
                        color: Colors.transparent,
                        child: InkResponse(
                          radius: 16.w,
                          onTap: () {
                            setState(() {
                              tempLeader.remove(
                                  tempLeader[index % tempLeader.length]);
                            });
                          },
                          child: SvgPicture.asset("assets/icons/ic_add.svg"),
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 4.h),
              itemCount: tempLeader.length),
          SizedBox(height: 4.h),
          TextFormField(
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  tempLeader.add(User(firstName: value, lastName: value));
                });
                addLeaderController.clear();
              }
            },
            controller: addLeaderController,
            decoration: InputDecoration(
              hintText: "Thêm lựa chọn",
              hintStyle: kText14Weight400_Hint,
              filled: true,
              fillColor: yrColorLight,
              isDense: true,
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
            ).allBorder(
              OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 64.h)
        ],
      ),
    );
  }
}
