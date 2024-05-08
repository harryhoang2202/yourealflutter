import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:youreal/app/common/news/index.dart';

import 'package:youreal/common/constants/general.dart';
import 'package:youreal/services/services_api.dart';

part 'news_cubit.freezed.dart';
part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsState.initial()) {
    onNewLoaded();

    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }
  static const TAG = "NewsCubit";

  final pagingController = PagingController<int, News>(firstPageKey: 1);
  final _services = APIServices();
  final _pageSize = 6;

  void onNewLoaded() async {
    _toggleLoading(true);
    try {
      final news = await _services.getHotNews();
      emit(state.copyWith(hotNews: news, isLoading: false));
    } on DioError catch (e) {
      printLog("[$TAG] Load hot new error $e");
      _toggleLoading(false);
    }
  }

  void onRefresh() {
    emit(state.copyWith(otherNews: []));
    pagingController.refresh();
    onNewLoaded();
  }

  Future<void> _fetchPage(int page) async {
    try {
      final newItems =
          await _services.getOtherNews(page: page, pageSize: _pageSize);
      final isLastPage = newItems.length < _pageSize;
      emit(state.copyWith(otherNews: [
        ...state.otherNews,
        if (page == 1) ...newItems.sublist(3) else ...newItems
      ]));
      if (isLastPage) {
        //pagingController.appendLastPage(newItems);
        pagingController.value = PagingState(
          itemList: state.otherNews,
        );
      } else {
        final nextPageKey = page + 1;
        pagingController.value = PagingState(
          nextPageKey: nextPageKey,
          itemList: state.otherNews,
        );
        // if (page == 1) {
        //   pagingController.appendPage(newItems.sublist(3), nextPageKey);
        // } else {
        //   pagingController.appendPage(newItems, nextPageKey);
        // }
      }
    } on DioError catch (error) {
      pagingController.value = PagingState(
        nextPageKey: page,
        itemList: state.otherNews,
        error: error.response?.data.toString() ?? "Đã có lỗi xảy ra!",
      );
      printLog("[$TAG] fetch page error page:$page $error");

      rethrow;
    }
  }

  //
  // void onNewLoaded(int page) async {
  //   _toggleLoading(true);
  //   final news = await _services.getOtherNews(page: page);
  //   emit(state.copyWith(news: news, isLoading: false));
  // }
  //
  // void onScrollEnded() async {
  //   _toggleLoading(true);
  //   final news = await _services.getOtherNews(page: state.currentPage + 1);
  //   emit(state.copyWith(
  //       news: [...state.news, ...news],
  //       currentPage: state.currentPage + 1,
  //       isLoading: false));
  // }

  void _toggleLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }
}
