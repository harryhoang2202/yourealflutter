import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/admin/main/admin_main_screen.dart';
import 'package:youreal/app/appraiser/appraiser_screen.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/widget/confirm_dialog.dart';
import 'package:youreal/app/main_screen.dart';
import 'package:youreal/app/personally/personnally_screen.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/utils/blocs/lazy_load/lazy_load_bloc.dart';

import 'package:youreal/view_models/app_model.dart';

import 'draft_deal/draft_deal_screen.dart';
import 'list_request_role/list_request_role.dart';
import 'list_request_role/model/role_requiring.dart';
import 'role/role_request_appraiser.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _key = GlobalKey<ScaffoldState>();
  bool loadingLogout = false;

  Widget imageContainer(String link) {
    if (link.contains('http://') || link.contains('https://')) {
      return Image.network(
        link,
        fit: BoxFit.fill,
      );
    }
    return Image.asset(
      "assets/$link",
      fit: BoxFit.fill,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final appModel = context.read<AppModel>();
    return SafeArea(
      minimum: EdgeInsets.only(bottom: 20.h),
      child: Container(
        width: screenWidth / 3 * 2,
        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Drawer(
          child: Container(
            height: screenHeight - 100.h,
            decoration: BoxDecoration(
              color: yrColorLight,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.h),
                bottomRight: Radius.circular(16.h),
              ),
            ),
            child: Column(
              children: [
                ///Header
                DrawerHeader(appModel: appModel),

                ///Body

                DrawerBody(appModel: appModel),

                ///bottom
                const Spacer(),
                Material(
                  color: yrColorLight,
                  child: InkWell(
                    onTap: () async {
                      bool result = await showAnimatedDialog(
                            barrierDismissible: true,
                            context: this.context,
                            builder: (context) => const ConfirmDialog(
                              title: 'Bạn có chắc chắn muốn đăng xuất?',
                            ),
                            animationType: DialogTransitionType.slideFromTop,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          ) ??
                          false;
                      if (result) {
                        authBloc.add(const AuthEvent.onSignOut());
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/icons/ic_sign_out.svg"),
                          SizedBox(
                            width: 12.w,
                          ),
                          Text(
                            "ĐĂNG XUẤT",
                            style: kText18_Primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                30.verSp,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    Key? key,
    required AppModel appModel,
  })  : _appModel = appModel,
        super(key: key);

  final AppModel _appModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: yrColorLight,
      child: Column(
        children: [
          ///Thông tin cá nhân
          InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                PersonallyScreen.id,
                arguments: _appModel,
              );
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/ic_info_user.svg"),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(
                    "Thông tin cá nhân",
                    style: kText18_Primary,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),

          ///Lưu deal nháp

          InkWell(
            onTap: () async {
              await Navigator.of(context, rootNavigator: true).pushNamed(
                DraftDealScreen.id,
              );
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/ic_deal_draft.svg"),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(
                    "Lưu deal nháp",
                    style: kText18_Primary,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          if (checkRole(context, RolesType.Admin) ||
              checkRole(context, RolesType.SuperAdmin)) ...[
            InkWell(
              onTap: () async {
                await Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            BlocProvider<LazyLoadBloc<RoleRequiring>>(
                                create: (context) =>
                                    LazyLoadBloc<RoleRequiring>(
                                        (page, sessionId) => APIServices()
                                            .getAllRoleRequiringForAdmin()),
                                child: const ListRequestRole())));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/ic_role.svg"),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(
                      "DS đề nghị vai trò",
                      style: kText18_Primary,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
          ],

          ///Đề nghị vai trò
          if (!checkRole(context, RolesType.SuperAdmin) &&
              !checkRole(context, RolesType.Admin)) ...[
            const _RoleRequirement(),
            const Divider(),
          ],

          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    Key? key,
    required AppModel appModel,
  })  : _appModel = appModel,
        super(key: key);

  final AppModel _appModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            height: 112.h,
            margin: EdgeInsets.only(
              top: 16.h,
            ),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: yrColorLight))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      height: 65.h,
                      width: 65.h,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: getImage(
                          _appModel.user.picture ?? "avatar.png",
                          fit: BoxFit.cover,
                          useCached: false,
                          isAsset: _appModel.user.picture == null,
                        ),
                      ),
                    ),
                    Container(
                      height: 15.h,
                      width: 15.h,
                      margin: EdgeInsets.only(top: 2.h, right: 2.w),
                      decoration: const BoxDecoration(
                          color: yrColorSuccess, shape: BoxShape.circle),
                    )
                  ],
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                    child: _RoleOfUser(
                  appModel: _appModel,
                )),
              ],
            ),
          ),
          SizedBox(
            height: 27.h,
          ),
        ],
      ),
    );
  }
}

class _RoleOfUser extends StatefulWidget {
  final AppModel _appModel;

  const _RoleOfUser({
    Key? key,
    required AppModel appModel,
  })  : _appModel = appModel,
        super(key: key);

  @override
  __RoleOfUserState createState() => __RoleOfUserState();
}

class __RoleOfUserState extends State<_RoleOfUser> {
  bool onTapName = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              onTapName = !onTapName;
            });
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    "${widget._appModel.user.firstName!} ${widget._appModel.user.lastName!}",
                    style: kText18_Primary,
                  ),
                ),
                onTapName
                    ? const Icon(
                        Icons.arrow_drop_up,
                        color: yrColorPrimary,
                      )
                    : const Icon(
                        Icons.arrow_drop_down,
                        color: yrColorPrimary,
                      ),
              ],
            ),
          ),
        ),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: onTapName ? 80.h : 0,
            padding: EdgeInsets.only(left: 10.w),
            child: onTapName
                ? SingleChildScrollView(
                    child: Column(
                    children: [
                      if (checkRole(context, RolesType.SuperAdmin) ||
                          checkRole(context, RolesType.Admin)) ...[
                        GestureDetector(
                          onTap: () async {
                            await Navigator.of(context, rootNavigator: true)
                                .pushNamedAndRemoveUntil(
                                    AdminMainScreen.id, ((route) => false));
                          },
                          child: Container(
                            height: 30.h,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Admin",
                              style: kText14_Primary,
                            ),
                          ),
                        ),
                      ],
                      if (checkRole(context, RolesType.Appraiser)) ...[
                        GestureDetector(
                          onTap: () async {
                            await Navigator.of(context, rootNavigator: true)
                                .pushNamedAndRemoveUntil(
                                    AppraiserScreen.id, ((route) => false));
                          },
                          child: Container(
                            height: 30.h,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Người thẩm định",
                              style: kText14_Primary,
                            ),
                          ),
                        ),
                      ],
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context, rootNavigator: true)
                              .pushNamedAndRemoveUntil(
                                  MainScreen.id, ((route) => false));
                        },
                        child: Container(
                          height: 30.h,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Nhà đầu tư",
                            style: kText14_Primary,
                          ),
                        ),
                      ),
                    ],
                  ))
                : const SizedBox(),
          ),
        ),
      ],
    );
  }
}

class _RoleRequirement extends StatefulWidget {
  const _RoleRequirement({Key? key}) : super(key: key);

  @override
  _RoleRequirementState createState() => _RoleRequirementState();
}

class _RoleRequirementState extends State<_RoleRequirement> {
  bool onTapChooseRole = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              onTapChooseRole = !onTapChooseRole;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/ic_role.svg"),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  "Đề nghị vai trò",
                  style: kText18_Primary,
                ),
                SizedBox(
                  width: 12.w,
                ),
                onTapChooseRole
                    ? const Icon(
                        Icons.arrow_drop_up,
                        color: yrColorPrimary,
                      )
                    : const Icon(
                        Icons.arrow_drop_down,
                        color: yrColorPrimary,
                      ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: onTapChooseRole ? 40.h : 0,
          padding: EdgeInsets.only(left: 50.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    // Navigator.pop(context);

                    await Navigator.of(context, rootNavigator: true).pushNamed(
                        RoleRequestAppraiser.id,
                        arguments: const RoleRequestAppraiserArgs());
                  },
                  child: Container(
                    height: 30.h,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Người thẩm định",
                      style: kText14_Primary,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
