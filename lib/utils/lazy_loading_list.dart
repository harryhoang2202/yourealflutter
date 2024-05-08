import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youreal/common/model/status_state.dart';

import 'blocs/lazy_load/lazy_load_bloc.dart';

class LazyLoadingList<T> extends StatefulWidget {
  const LazyLoadingList({
    Key? key,
    this.scrollOffset = 100,
    required this.builder,
  }) : super(key: key);
  // final Future<List<T>?> Function(int page, String sessionId) fetchData;
  final double scrollOffset;
  final Widget Function(BuildContext, List<T>) builder;

  @override
  State<LazyLoadingList<T>> createState() => _LazyLoadingListState<T>();
}

class _LazyLoadingListState<T> extends State<LazyLoadingList<T>> {
  // List<T> initData = [];
  late LazyLoadBloc<T> bloc;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = BlocProvider.of<LazyLoadBloc<T>>(context);
    loadData();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    bloc.add(LazyLoadEvent.initial());
    // var a = await widget.fetchData(1, "1");
    setState(() {
      isLoading = false;
      // initData = a ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return handleNotification(notification, context);
        },
        child: BlocSelector<LazyLoadBloc<T>, LazyLoadState<T>, List<T>>(
          selector: (state) {
            return state.items;
          },
          builder: (context, items) {
            return widget.builder(context, items);
          },
        ),
      );
    });
  }

  bool handleNotification(
    ScrollNotification notification,
    BuildContext context,
  ) {
    // final bloc = context.read<LazyLoadBloc<T>>();
    //Nếu đang load data thì không load thêm data mới nữa
    if (bloc.state.statusLoadMore is LoadingState ||
        bloc.state.statusRefresh is LoadingState) return false;

    if (notification.metrics.axis == Axis.vertical) {
      //notification là ScrollUpdateNotification khi có sự thay đổi vị trí scroll của listview
      if (notification is ScrollUpdateNotification) {
        /// notification.metrics.extentAfter: khoảng cách từ đáy màn hình đến vị trí scroll hiện tại
        /// scrollOffset: khi extentAfter < scrollOffset sẽ bắt đầu load thêm data, scrollOffset có thể tùy chỉnh
        if (notification.metrics.extentAfter <= widget.scrollOffset) {
          bloc.add(LazyLoadRefreshed());
        }
        return true;
      } else if (notification is OverscrollNotification) {
        ///notification.metrics.maxScrollExtent: khoảng cách scroll tối đa ở thời điểm hiện tại của listview
        ///notification là OverscrollNotification khi người dùng scroll đến maxScrollExtent
        ///notification.overscroll: số pixels bị overscroll
        if (notification.overscroll > 0) {
          bloc.add(LazyLoadLoadMore());
        }
        return true;
      }
    }
    return false;
  }
}
