import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/widget/confirm_dialog.dart';
import 'package:youreal/app/menu/menu.dart';
import 'package:youreal/app/setting/widgets/update_info_dialog.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/utils/custom_listile.dart';
import 'package:youreal/view_models/app_model.dart';
import 'package:youreal/widgets_common/notification_button.dart';

import 'package:youreal/widgets_common/popup_update_feature.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  static const id = "SettingScreen";

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _key = GlobalKey<ScaffoldState>();
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: yrColorLight,
            size: 38.w,
          ),
        ),
        title: Text(
          "Cài đặt",
          style: kText28_Light,
        ),
        actions: const [
          NotificationButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _UserAvatar(),
            SizedBox(
              height: 24.h,
            ),
            const SettingMenu(),
          ],
        ),
      ),
    );
  }
}

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final appModel = context.read<AppModel>();
    return Container(
      height: 200.h,
      width: screenWidth,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.w),
        ),
        color: yrColorLight,
        child: Column(
          children: [
            Expanded(
              child: CustomListTile(
                title: "Thay đổi thông tin cá nhân",
                icon: "edit",
                onTap: () {
                  showAnimatedDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) =>
                        UpdateInfoDialog.getInstance(appModel),
                    animationType: DialogTransitionType.slideFromTop,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                titleStyle: kText18Weight400_Primary,
                iconColor: yrColorPrimary,
              ),
            ),
            Expanded(
              child: CustomListTile(
                title: "Cài đặt thông báo",
                icon: "notification_outlined",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => const PopupUpdateFeature());
                  //
                  // showAnimatedDialog(
                  //   barrierDismissible: true,
                  //   context: context,
                  //   builder: (context) =>
                  //       NotificationSettingsDialog.getInstance(),
                  //   animationType: DialogTransitionType.slideFromTop,
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeOut,
                  // );
                },
                titleStyle: kText18Weight400_Primary,
                iconColor: yrColorPrimary,
              ),
            ),
            Expanded(
              child: CustomListTile(
                title: "Liên hệ",
                icon: "phone_call",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => const PopupUpdateFeature());
                },
                titleStyle: kText18Weight400_Primary,
                iconColor: yrColorPrimary,
              ),
            ),
            Expanded(
              child: CustomListTile(
                title: "Chính sách và điều khoản",
                icon: "document",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => const PopupUpdateFeature());
                },
                titleStyle: kText18Weight400_Primary,
                iconColor: yrColorPrimary,
              ),
            ),
            Expanded(
              child: CustomListTile(
                title: "Đăng xuất",
                icon: "sign_out",
                onTap: () async {
                  bool result = await showAnimatedDialog(
                        barrierDismissible: true,
                        context: context,
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
                titleStyle: kText18Weight400_Error,
                iconColor: yrColorError,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, provider, child) {
        return Container(
          margin: EdgeInsets.only(top: 16.h),
          alignment: Alignment.center,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipOval(
                    child: getImage(
                      provider.user.picture ?? "avatar.png",
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      useCached: false,
                      isAsset: provider.user.picture == null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        Tools().showPickerMultiImage(
                            context: context,
                            maxAssets: 1,
                            successGallery: (res) async {
                              if (res.isEmpty) return;
                              final user = provider.user;
                              var img = await Tools().resizeImage(res.first);
                              final apiResult = await APIServices()
                                  .changeAvatar(imagePath: img);
                              provider.user = user;
                            },
                            successCamera: (res) {});
                      },
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: yrColorWarning,
                        size: 20.w,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                provider.user.fullName,
                style: kText18_Light,
              ),
            ],
          ),
        );
      },
    );
  }
}
