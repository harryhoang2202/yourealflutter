import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:youreal/app/notification/blocs/notification_cubit.dart';
import 'package:youreal/app/notification/models/yr_notification.dart';
import 'package:youreal/app/notification/widgets/notification_item.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/widgets_common/lazy_list_error.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static const id = "NotificationScreen";
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AppBar _buildAppbar(NotificationCubit cubit) => AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leading: const YrBackButton(),
        title: Text(
          "Thông báo",
          style: kText28_Light,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final res = await Utils.showConfirmDialog(context,
                  title: "Bạn có muốn đánh dấu tất cả đã đọc?");
              if (res) {
                cubit.markAllSeen();
              }
            },
            padding: EdgeInsets.zero,
            splashRadius: 24.w,
            icon: Icon(
              Icons.playlist_add_check_outlined,
              color: yrColorLight,
              size: 32.w,
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   padding: EdgeInsets.zero,
          //   splashRadius: 24.w,
          //   icon: Icon(
          //     Icons.delete,
          //     color: yrColorLight,
          //     size: 32.w,
          //   ),
          // ),
        ],
      );
  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationCubit>();
    cubit.onRefreshed();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationCubit>();
    return Scaffold(
      appBar: _buildAppbar(cubit),
      backgroundColor: yrColorPrimary,
      body: RefreshIndicator(
        onRefresh: () async => cubit.onRefreshed(),
        child: PagedListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          pagingController: cubit.pagingController,
          builderDelegate: PagedChildBuilderDelegate<YrNotification>(
            itemBuilder: (context, item, index) => NotificationItem(
              item: item,
              onSeen: cubit.markOneAsSeen,
              onTap: () => cubit.onNotificationClicked(item),
            ),
            firstPageErrorIndicatorBuilder: (context) {
              return LazyListError(
                onTap: () {
                  cubit.onRefreshed();
                },
              );
            },
            newPageErrorIndicatorBuilder: (context) {
              return LazyListError(
                onTap: () {
                  cubit.onRefreshed();
                },
              );
            },
            noItemsFoundIndicatorBuilder: (context) {
              return Center(
                child: Text(
                  "Không có dữ liệu",
                  style: kText14_Light,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          separatorBuilder: (_, __) => SizedBox(
            height: 8.h,
          ),
        ),
      ),
    );
  }
}
