import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tvt_tab_bar/tvt_tab_bar.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/routes/app_route.dart';
import 'package:youreal/services/notification_services.dart';
import 'package:youreal/view_models/app_model.dart';

import 'chats/views/chat_screen.dart';
import 'chats/widget/confirm_dialog.dart';
import 'common/news/index.dart';
import 'home/views/home_screen.dart';
import 'my_deal/deal_screen.dart';

import 'setting/views/setting_screen.dart';

class MainScreen extends StatefulWidget {
  static const id = "MainScreen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin, AfterLayoutMixin {
  late PersistentTabController _controller;
  final _key = GlobalKey<ScaffoldState>();
  String nameTab = "Trang chủ";
  final _notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    int initialIndex = 0;
    final notification = _notificationServices.notification;
    if (notification != null) {
      initialIndex = notification.jumpToNavBarIndex;
    }
    _controller = PersistentTabController(initialIndex: initialIndex);
    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _notificationServices.handleNotificationClick();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AppModel().loadProvinces();
  }

  List<PersistentBottomNavBarItem> _navBarsItems(User user) {
    return [
      PersistentBottomNavBarItem(
        icon: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: _controller.index == 0
              ? SvgPicture.asset(getIcon("ic_home1.svg"), color: yrColorLight)
              : SvgPicture.asset(getIcon("ic_home1.svg"),
                  color: yrColorSecondary),
        ),
        title: "Trang chủ",
        iconSize: 20,
        contentPadding: 10,
        activeColorSecondary: yrColorLight,
        textStyle: _controller.index == 0 ? kText14_Light : kText14_Secondary2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: HomeScreen.id,
          onGenerateRoute: AppRoute().onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: _controller.index == 1
              ? SvgPicture.asset(getIcon("bolt.svg"), color: yrColorLight)
              : SvgPicture.asset(getIcon("bolt.svg"), color: yrColorSecondary),
        ),
        title: "Deal",
        iconSize: 20,
        contentPadding: 10,
        activeColorSecondary: yrColorLight,
        textStyle: _controller.index == 1 ? kText14_Light : kText14_Secondary2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: DealScreen.id,
            onGenerateRoute: AppRoute().onGenerateRoute),
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: _controller.index == 2
              ? SvgPicture.asset(getIcon("ic_news.svg"), color: yrColorLight)
              : SvgPicture.asset(getIcon("ic_news.svg"),
                  color: yrColorSecondary),
        ),
        title: "Tin tức",
        iconSize: 20,
        contentPadding: 10,
        activeColorSecondary: yrColorLight,
        textStyle: _controller.index == 2 ? kText14_Light : kText14_Secondary2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: NewsScreen.id,
            onGenerateRoute: AppRoute().onGenerateRoute),
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: _controller.index == 3
              ? SvgPicture.asset(getIcon("ic_chat.svg"), color: yrColorLight)
              : SvgPicture.asset(getIcon("ic_chat.svg"),
                  color: yrColorSecondary),
        ),
        title: "Chat",
        activeColorPrimary: yrColorPrimary,
        iconSize: 20,
        contentPadding: 10,
        activeColorSecondary: yrColorLight,
        textStyle: _controller.index == 3 ? kText14_Light : kText14_Secondary2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: ChatScreen.id,
            onGenerateRoute: AppRoute().onGenerateRoute),
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: _controller.index == 4
              ? SvgPicture.asset(getIcon("ic_setting.svg"), color: yrColorLight)
              : SvgPicture.asset(getIcon("ic_setting.svg"),
                  color: yrColorSecondary),
        ),
        title: "Cài đặt",
        iconSize: 20,
        contentPadding: 10,
        activeColorSecondary: yrColorLight,
        textStyle: _controller.index == 4 ? kText14_Light : kText14_Secondary2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: SettingScreen.id,
            onGenerateRoute: AppRoute().onGenerateRoute),
      ),
    ];
  }

  List<Widget> _buildScreens(User user) {
    return [
      const HomeScreen(),
      const DealScreen(),
      BlocProvider(
        create: (context) => NewsCubit(),
        child: const NewsScreen(),
      ),
      const ChatScreen(),
      const SettingScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appModel = Provider.of<AppModel>(context);

    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(appModel.user),
        items: _navBarsItems(appModel.user),
        confineInSafeArea: true,
        onWillPop: (context) async {
          bool result = await showAnimatedDialog(
                barrierDismissible: true,
                context: this.context,
                builder: (context) => const ConfirmDialog(
                  title: 'Bạn có chắc chắn muốn thoát?',
                ),
                animationType: DialogTransitionType.slideFromTop,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ) ??
              false;
          return result;
        },
        popActionScreens: PopActionScreensType.all,
        backgroundColor: yrColorPrimary,
        hideNavigationBar: appModel.hideNavBar,
        decoration: const NavBarDecoration(
          //colorBehindNavBar: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        //  bottomScreenMargin: 64.h,
        //   navBarHeight: 64.h,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void afterFirstLayout(BuildContext context) {}
}
