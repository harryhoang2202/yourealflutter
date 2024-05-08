import 'package:tvt_tab_bar/tvt_tab_bar.dart';
import 'package:youreal/common/config/color_config.dart';

class AppNavBarItem extends PersistentBottomNavBarItem {
  AppNavBarItem({
    required super.icon,
    super.title,
    super.iconSize = 20,
    super.contentPadding = 10,
    super.textStyle,
    super.activeColorSecondary = yrColorLight,
    super.routeAndNavigatorSettings,
  });
}
