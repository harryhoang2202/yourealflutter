import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/menu/menu.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/widget/sliver_header.dart';

import 'package:youreal/services/services_api.dart';
import 'package:youreal/utils/custom_listile.dart';
import 'package:youreal/widgets_common/lazy_list_error.dart';

import 'package:youreal/widgets_common/notification_button.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

import 'index.dart';

export 'blocs/news_cubit.dart';
export 'models/news.dart';
part 'views/news_screen.dart';
part 'views/news_detail_screen.dart';
part 'widgets/hot_news_widget.dart';
part 'widgets/news_item.dart';
part 'widgets/news_popup.dart';
part 'widgets/other_news_widget.dart';
