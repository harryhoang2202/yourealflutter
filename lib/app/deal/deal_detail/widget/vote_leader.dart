import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/auth/login/widgets/custom_checkbox.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/deal_detail/blocs/deal_detail_bloc.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/widget/app_loading.dart';

import 'package:youreal/services/services_api.dart';
import 'package:youreal/view_models/app_bloc.dart';
import 'package:youreal/view_models/app_model.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

class VoteLeader extends StatefulWidget {
  final Deal deal;

  const VoteLeader({Key? key, required this.deal}) : super(key: key);

  @override
  _VoteLeaderState createState() => _VoteLeaderState();
}

class _VoteLeaderState extends State<VoteLeader> {
  List<Voter> listVoter = [];
  final APIServices _services = APIServices();
  Allocation? _selected;
  bool isVoting = false;

  @override
  void initState() {
    super.initState();

    loadListVoter();
  }

  loadListVoter() async {
    var result = await loadResultVote();
    for (var element in widget.deal.allocations!) {
      if (result != null && result == element.userId) {
        setState(() {
          isVoting = true;
          _selected = element;
        });

        listVoter.add(Voter(element, true));
      } else {
        listVoter.add(Voter(element, false));
      }
    }

    if (result != null && result == "-1") {
      setState(() {
        isVoting = true;
        _selected = Allocation(
          id: -1,
          userId: "0",
          lastName: "Bỏ qua bình chọn",
        );
      });
    }
    listVoter.add(Voter(
        Allocation(
          id: -1,
          userId: "0",
          lastName: "Bỏ qua bình chọn",
        ),
        result != null && result == "-1"));
    setState(() {});
  }

  loadResultVote() async {
    var result = await _services.getVoteResult(widget.deal.id);
    if (result.isNotEmpty) {
      for (var element in result) {
        if (element["userId"] ==
            Provider.of<AppModel>(context, listen: false).user.userId) {
          if (element["votedUserId"] != null) {
            return element["votedUserId"];
          }
        }
        if (element["userId"] == "-1") {
          return element["votedUserId"];
        }
      }
    }
    return null;
  }

  snackBarWidget(title, error) {
    final snackBar = SnackBar(
      content: Container(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: kText14_Light,
        ),
      ),
      backgroundColor: !error ? yrColorSuccess : yrColorError,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    return BlocListener<DealDetailBloc, DealDetailState>(
      listener: (context, state) async {
        if (state.voteLeaderStatus is LoadingState) {
          AppLoading.show(context);
        } else if (state.voteLeaderStatus is SuccessState) {
          AppLoading.dismiss(context);

          AppBloc.dealDetailBloc.initial(widget.deal.id.toString());

          Navigator.pop(context);
          await Utils.showInfoSnackBar(
            context,
            message:
                "Bạn đã bình chọn cho ${_selected!.firstName} ${_selected!.lastName}",
          );
        } else if (state.voteLeaderStatus is ErrorState) {
          AppLoading.dismiss(context);
          await Utils.showInfoSnackBar(context,
              message: "Bạn đã bình chọn leader cho deal này !!!",
              isError: true);
        } else if (state.voteLeaderStatus is IdleState) {
          AppLoading.dismiss(context);
        }
      },
      listenWhen: (previous, current) =>
          previous.voteLeaderStatus != current.voteLeaderStatus,
      child: Container(
        height: 400.h,
        width: screenWidth,
        decoration: BoxDecoration(
            color: yrColorLight, borderRadius: BorderRadius.circular(8.r)),
        padding: EdgeInsets.all(4.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Bình chọn leader".toUpperCase(),
                      style: kText18_Primary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 30.h,
                    width: 40.h,
                    child: Container(
                      margin: EdgeInsets.only(right: 16.w),
                      width: 18.w,
                      child: const Icon(
                        Icons.clear,
                        color: yrColorHint,
                      ),
                    ),
                  ),
                )
              ],
            ),
            16.verSp,
            Text(
              "Leader sẽ được chọn dựa trên số phiếu cao nhất.",
              style: kText14Weight400_Secondary2,
            ),
            if (widget.deal.allocations != null)
              Expanded(
                child: ListView.builder(
                  itemCount: listVoter.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var user = listVoter[index];
                    return InkWell(
                      onTap: () async {
                        if (isVoting) {
                          await Utils.showInfoSnackBar(context,
                              message:
                                  "Bạn đã bình chọn leader cho deal này !!!",
                              isError: true);
                        } else {
                          if (listVoter[index].allocation.userId ==
                              appModel.user.userId) {
                            await Utils.showInfoSnackBar(context,
                                message:
                                    "Bạn không thể bình chọn cho chính mình !!!",
                                isError: true);
                          } else {
                            for (var element in listVoter) {
                              element.isChoose = false;
                            }
                            setState(() {
                              listVoter[index].isChoose = true;
                            });
                            _selected = listVoter[index].allocation;
                          }
                        }
                      },
                      child: SizedBox(
                        height: 44.h,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 35.h,
                              width: 35.h,
                              child: CustomCheckbox(
                                isChecked: listVoter[index].isChoose,
                                size: 20.w,
                                checkedFillColor: yrColorLight,
                                unCheckedBorderColor: yrColorPrimary,
                                shape: BoxShape.circle,
                                icon: Container(
                                  height: 15.h,
                                  width: 15.h,
                                  decoration: const BoxDecoration(
                                      color: yrColorPrimary,
                                      shape: BoxShape.circle),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: yrColorPrimary, width: 0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${user.allocation.firstName ?? ''} ${user.allocation.lastName}",
                                      style: kText14Weight400_Primary,
                                    ),

                                    //avatar user voted
                                    Container(
                                      width: 70.w,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            PrimaryButton(
              text: "Bình chọn",
              onTap: () async {
                if (isVoting) {
                  await Utils.showInfoSnackBar(context,
                      message: "Bạn đã bình chọn leader cho deal này !!!",
                      isError: true);
                } else {
                  if (_selected != null) {
                    if (_selected!.id != -1) {
                      AppBloc.dealDetailBloc.voteLeader(
                          widget.deal.id.toString(),
                          _selected!.userId.toString());
                    } else {
                      AppBloc.dealDetailBloc
                          .voteLeader(widget.deal.id.toString(), "-1");
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Voter {
  late bool isChoose;
  late Allocation allocation;

  Voter(this.allocation, this.isChoose);
}

class VoteLeaderCompleted extends StatefulWidget {
  final dealId;

  const VoteLeaderCompleted({
    Key? key,
    required this.dealId,
  }) : super(key: key);

  @override
  State<VoteLeaderCompleted> createState() => _VoteLeaderCompletedState();
}

class _VoteLeaderCompletedState extends State<VoteLeaderCompleted> {
  Allocation? _leader;
  final APIServices _services = APIServices();
  @override
  void initState() {
    super.initState();
  }

  loadLeader() async {
    _leader = await _services.getLeader(dealId: widget.dealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80.w,
        leading: const YrBackButton(),
        title: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            "Chi tiết deal",
            style: kText28_Light,
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: yrColorPrimary,
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80.h,
            ),
            Image.asset("assets/images/winer.png"),
            SizedBox(
              height: 40.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(text: "Chúc mừng ", style: kText14Weight400_Light),
                TextSpan(
                    text: "${_leader!.firstName} ${_leader!.lastName}",
                    style: kText14_Light),
                TextSpan(
                    text: " có số phiếu cao nhất.\n",
                    style: kText14Weight400_Light),
                TextSpan(
                    text: "${_leader!.firstName} ${_leader!.lastName}",
                    style: kText14_Light),
                TextSpan(
                    text: " sẽ trở thành Leader mới của dự án\n",
                    style: kText14Weight400_Light),
                TextSpan(text: "Deal #${widget.dealId}", style: kText14_Light)
              ]),
            ),
            SizedBox(
              height: 40.h,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50.h,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: yrColorLight,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Đóng",
                      style: kText18_Primary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
