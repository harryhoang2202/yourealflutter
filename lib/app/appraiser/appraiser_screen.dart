import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:youreal/app/admin/search/admin_search_deal_screen.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/menu/menu.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/widget/sliver_header.dart';

import 'package:youreal/widgets_common/lazy_list_error.dart';
import 'package:youreal/widgets_common/notification_button.dart';
import 'package:youreal/widgets_common/search_bar.dart';

import 'blocs/appraiser_bloc.dart';
import 'widgets/appraiser_deal_item.dart';

class AppraiserScreen extends StatelessWidget {
  AppraiserScreen({Key? key}) : super(key: key);
  static const id = "AppraiserScreen";
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final appraiserBloc = context.read<AppraiserBloc>();

    return Scaffold(
      key: _key,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      backgroundColor: yrColorPrimary,
      appBar: _buildAppbar(),
      body: RefreshIndicator(
        onRefresh: () =>
            Future.sync(() => appraiserBloc.add(const AppraiserRefreshed())),
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverPinnedHeader(child: SizedBox(height: 24.h)),
              SliverPersistentHeader(
                floating: true,
                delegate: SliverPersistentHeaderCustomDelegate(
                  child: Hero(
                    tag: AdminSearchDealScreen.searchBarHeroTag,
                    child: SearchBar(
                      // hintText: "Nhập mã Deal...",
                      readOnly: true,
                      onTap: () {
                        Navigator.pushNamed(context, AdminSearchDealScreen.id);
                      },
                    ),
                  ),
                  maxHeight: 40.w,
                  minHeight: 0,
                ),
              ),
              SizedBox(height: 24.h).toSliver(),
              Container(
                  padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                  child: Text(
                    "DS deal chờ thẩm định",
                    style: kText18_Light,
                  )).toSliver(),
              const _PendingAppraiserDeals(),
              SizedBox(height: 50.h).toSliver(),
              Container(
                  padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                  child: Text(
                    "DS deal đã thẩm định",
                    style: kText18_Light,
                  )).toSliver(),
              const _AppraiserDeals(),
              SizedBox(height: 50.h).toSliver(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
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
        "Danh sách thẩm định",
        style: kText24_Light,
      ),
      actions: const [
        NotificationButton(),
      ],
    );
  }
}

class _PendingAppraiserDeals extends StatelessWidget {
  const _PendingAppraiserDeals({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appraiserBloc = context.read<AppraiserBloc>();
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: PagedSliverList.separated(
        pagingController: appraiserBloc.dealController,
        builderDelegate: PagedChildBuilderDelegate<Deal>(
          itemBuilder: (BuildContext context, item, int index) {
            return AppraiserDealItem(
              deal: item,
            );
          },
          newPageErrorIndicatorBuilder: (context) {
            return LazyListError(
              onTap: () {
                appraiserBloc.dealController.retryLastFailedRequest();
              },
            );
          },
          firstPageErrorIndicatorBuilder: (context) {
            return LazyListError(
              onTap: () {
                appraiserBloc.dealController.retryLastFailedRequest();
              },
            );
          },
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(
              "Bạn chưa có Deal được giao thẩm định.",
              style: kText14_Light,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        separatorBuilder: (_, __) => SizedBox(
          height: 8.h,
        ),
      ),
    );
  }
}

class _AppraiserDeals extends StatelessWidget {
  const _AppraiserDeals({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appraiserBloc = context.read<AppraiserBloc>();
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: PagedSliverList.separated(
        pagingController: appraiserBloc.dealController1,
        builderDelegate: PagedChildBuilderDelegate<Deal>(
          itemBuilder: (BuildContext context, item, int index) {
            return AppraiserDealItem(
              deal: item,
            );
          },
          newPageErrorIndicatorBuilder: (context) {
            return LazyListError(
              onTap: () {
                appraiserBloc.dealController1.retryLastFailedRequest();
              },
            );
          },
          firstPageErrorIndicatorBuilder: (context) {
            return LazyListError(
              onTap: () {
                appraiserBloc.dealController1.retryLastFailedRequest();
              },
            );
          },
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(
              "Bạn chưa thẩm định Deal nào !!!",
              style: kText14_Light,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        separatorBuilder: (_, __) => SizedBox(
          height: 8.h,
        ),
      ),
    );
  }
}
