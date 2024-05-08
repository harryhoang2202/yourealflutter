import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tuple/tuple.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/deal/deal_detail/widget/popup_question_with_text_box.dart';
import 'package:youreal/app/deal/deal_detail/widget/row_button.dart';
import 'package:youreal/app/form_appraisal/appraisal_1/widgets/secondary_button.dart';
import 'package:youreal/app/menu/list_request_role/blocs/req_appraisal_role_bloc/req_appraisal_role_bloc.dart';
import 'package:youreal/app/menu/list_request_role/model/role_requiring.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/domain/auth/models/user.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import 'widgets/popup_waiting_review.dart';
import 'widgets/role_req_bottom.dart';
import 'widgets/role_req_general_info.dart';
import 'widgets/role_req_pick_image.dart';

class RoleRequestAppraiserArgs {
  final RoleRequiring? request;
  final bool isAdmin;

  const RoleRequestAppraiserArgs({this.request, this.isAdmin = false});
}

class RoleRequestAppraiser extends StatefulWidget {
  final RoleRequiring? request;
  final bool isAdmin;
  const RoleRequestAppraiser({Key? key, this.request, this.isAdmin = false})
      : super(key: key);
  static const id = "RoleRequestAppraiser";

  @override
  _RoleRequestAppraiserState createState() => _RoleRequestAppraiserState();
}

class _RoleRequestAppraiserState extends State<RoleRequestAppraiser> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late AuthBloc authBloc;
  late ReqAppraisalRoleBloc _reqBloc;

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteRejectController = TextEditingController();
  final noteAccessController = TextEditingController();

  bool isReject = false;

  initInfo() {
    final User user;
    if (widget.isAdmin) {
      user = widget.request!.requester!;
    } else {
      user = (authBloc as AuthStateAuthenticated).user;
    }
    nameController.text = "${user.lastName!} ${user.firstName!}";
    phoneController.text = user.phoneNumber?.replaceFirst("+84", "0") ?? "";
    if (user.dateOfBirth != null) {
      ageController.text =
          (DateTime.now().year - DateTime.parse(user.dateOfBirth!).year)
              .toString();
    }
  }

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();
    _reqBloc = context.read<ReqAppraisalRoleBloc>();
    initInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReqAppraisalRoleBloc, ReqAppraisalRoleState>(
      listener: (context, state) async {
        if (state.showDialogType == ShowDialogType.Confirm) {
          final result = await Utils.showConfirmDialog(context,
              title: "Bạn muốn gửi đề nghị này không?");
          if (result) {
            _reqBloc.add(const ReqAppraisalRoleSubmitted());
          }
        } else if (state.showDialogType == ShowDialogType.Waiting) {
          await showAnimatedDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => PopupWaitingReview(
                title: widget.isAdmin
                    ? isReject
                        ? "Bạn đã hủy đề nghị #${widget.request!.roleId}"
                        : "Bạn đã duyệt đề nghị #${widget.request!.roleId}"
                    : null),
            animationType: DialogTransitionType.slideFromTop,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          Navigator.pop(context);
        }
        if (state.error != "") {
          Utils.showErrorDialog(context, message: state.error);
        }
      },
      child: Scaffold(
        key: _key,
        backgroundColor: yrColorPrimary,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: yrColorPrimary,
          centerTitle: true,
          leading: const YrBackButton(),
          elevation: 0,
          title: Text(
            "Vai trò người thẩm định",
            style: kText28_Light,
          ),
        ),
        body: GestureDetector(
          //Unfocus textfield on tap outside
          onTap: () => Utils.hideKeyboard(context),
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              24.verSp,
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: yrColorLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        16.verSp,

                        RoleReqGeneralInfo(
                          phoneController: phoneController,
                          emailController: emailController,
                          nameController: nameController,
                          ageController: ageController,
                          addressController: addressController,
                        ),

                        /// Hình chân dung
                        BlocSelector<ReqAppraisalRoleBloc,
                            ReqAppraisalRoleState, List<String>>(
                          selector: (state) => state.portraits,
                          builder: (context, portraits) {
                            return RoleReqPickImage(
                              title: "Hình chân dung",
                              subtitle: "(tối thiểu 2 tấm hình)",
                              readOnly: widget.isAdmin,
                              onPicked: (List<String> value) {
                                _reqBloc.add(
                                  ReqAppraisalRolePortraitImgChanged(
                                    value,
                                  ),
                                );
                              },
                              imagePaths: portraits,
                            );
                          },
                        ),
                        16.verSp,

                        /// Hình CMND/CCCD/PASSPORT
                        /// Hình chân dung
                        BlocSelector<ReqAppraisalRoleBloc,
                            ReqAppraisalRoleState, List<String>>(
                          selector: (state) => state.ids,
                          builder: (context, ids) {
                            return RoleReqPickImage(
                              title: "Hình CMND/ CCCD/ Passport",
                              subtitle: "(tối thiểu 2 tấm hình)",
                              readOnly: widget.isAdmin,
                              onPicked: (List<String> value) {
                                _reqBloc
                                    .add(ReqAppraisalRoleIdImgChanged(value));
                              },
                              imagePaths: ids,
                            );
                          },
                        ),
                        16.verSp,

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Kinh nghiệm thẩm định",
                                style: kText14_Dark,
                              ),
                            ),
                            8.verSp,
                            SecondaryButton(
                              backgroundColor: yrColorPrimary,
                              textColor: yrColorLight,
                              onTap: () async {
                                const snackBar = SnackBar(
                                  content: Text("Chức năng đang cập nhật!"),
                                  duration: Duration(seconds: 3),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                            ),
                          ],
                        ),
                        16.verSp,
                      ],
                    ),
                  ),
                ),
              ),
              if (!widget.isAdmin)
                BlocSelector<ReqAppraisalRoleBloc, ReqAppraisalRoleState,
                    Tuple2<bool, ButtonStatus>>(
                  selector: (state) => Tuple2(state.agreeRule, state.status),
                  builder: (context, state) {
                    return RoleReqBottom(
                      onAgreeTap: () {
                        _reqBloc.add(
                            ReqAppraisalRoleAgreeRuleChanged(!state.item1));
                      },
                      onSubmit: () {
                        _reqBloc.add(const ReqAppraisalDataValidated());
                      },
                      agreed: state.item1,
                    );
                  },
                ),
              if (widget.isAdmin && widget.request!.statusId == 1)
                Column(
                  children: [
                    24.verSp,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: RowButton(
                        onLeftTap: () async {
                          final result = await showDialog(
                                context: context,
                                builder: (context) => PopupQuesionWithTextBox(
                                  title:
                                      "Bạn muốn từ chối duyệt yêu cầu #${widget.request!.id}?",
                                  controller: noteRejectController,
                                  onApprove: () async {
                                    _reqBloc.add(ReqAppraisalNotApprovedRequest(
                                        noteRejectController.text));
                                    setState(() {
                                      isReject = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ) ??
                              false;
                          if (!result) return;
                        },
                        onRightTap: () async {
                          final result = await showDialog(
                                context: context,
                                builder: (context) => PopupQuesionWithTextBox(
                                  title:
                                      "Bạn chắc chắn duyệt yêu cầu #${widget.request!.id}?",
                                  controller: noteAccessController,
                                  isRejected: false,
                                  titleInput: "Ghi chú",
                                  onApprove: () {
                                    _reqBloc.add(ReqAppraisalApprovedRequest(
                                        noteAccessController.text));
                                    setState(() {
                                      isReject = false;
                                    });
                                  },
                                ),
                              ) ??
                              false;
                          if (!result) return;
                        },
                        leftText: "Hủy yêu cầu",
                        rightText: "Duyệt yêu cầu",
                      ),
                    ),
                    32.verSp,
                  ],
                )
              else if (widget.isAdmin)
                SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }
}
