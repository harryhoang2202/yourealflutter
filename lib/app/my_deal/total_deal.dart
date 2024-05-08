import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';

import 'package:youreal/widgets_common/yr_back_button.dart';

import '../../common/constants/general.dart';
import '../../common/tools.dart';
import '../../widgets_common/lazy_list_error.dart';

class TotalDeal extends StatefulWidget {
  final String title;
  static const id = "TotalDeal";
  final Future<List<Deal>> Function(
      int page, int size, int sessionId, int lastId) loadData;
  final Widget Function(Deal deal) itemBuilder;
  const TotalDeal({
    Key? key,
    required this.title,
    required this.loadData,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  _TotalDealState createState() => _TotalDealState();
}

class _TotalDealState extends State<TotalDeal> {
  int sessionId = Utils.newSessionId;
  final _pageSize = 10;
  final PagingController<TotalDealPageKey, Deal> _pagingController =
      PagingController(
          firstPageKey: const TotalDealPageKey(lastId: 0, page: 1));
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(TotalDealPageKey key) async {
    try {
      final newItems =
          await widget.loadData(key.page, _pageSize, sessionId, key.lastId);
      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey =
            key.copyWith(lastId: newItems.last.id, page: key.page + 1);
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error, trace) {
      printLog("[$runtimeType] $error \n$trace");
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leading: const YrBackButton(),
        title: FittedBox(
          child: Text(
            widget.title,
            style: kText28Weight500_Light,
          ),
        ),
      ),
      body: Scrollbar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: RefreshIndicator(
            onRefresh: () => Future.sync(() => _pagingController.refresh()),
            child: PagedListView.separated(
              pagingController: _pagingController,
              padding: EdgeInsets.only(top: 24.h, bottom: 64.h),
              builderDelegate: PagedChildBuilderDelegate<Deal>(
                itemBuilder: (context, item, index) => widget.itemBuilder(item),
                firstPageErrorIndicatorBuilder: (context) {
                  return LazyListError(
                    onTap: () {
                      sessionId = Utils.newSessionId;
                      _pagingController.refresh();
                    },
                  );
                },
                newPageErrorIndicatorBuilder: (context) {
                  return LazyListError(
                    onTap: () {
                      _pagingController.retryLastFailedRequest();
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
              separatorBuilder: (_, __) => 16.verSp,
            ),
          ),
        ),
      ),
    );
  }
}

class TotalDealArgs {
  final String title;
  final Future<List<Deal>> Function(
      int page, int size, int sessionId, int lastId) loadData;
  final Widget Function(Deal deal) itemBuilder;

  const TotalDealArgs({
    required this.title,
    required this.loadData,
    required this.itemBuilder,
  });
}

class TotalDealPageKey {
  final int lastId;
  final int page;

  const TotalDealPageKey({
    required this.lastId,
    required this.page,
  });

  TotalDealPageKey copyWith({
    int? lastId,
    int? page,
  }) {
    return TotalDealPageKey(
      lastId: lastId ?? this.lastId,
      page: page ?? this.page,
    );
  }
}
