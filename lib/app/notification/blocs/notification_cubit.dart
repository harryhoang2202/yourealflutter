import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/app/notification/models/yr_notification.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/services/notification_services.dart';

import 'package:youreal/services/services_api.dart';

part 'notification_cubit.freezed.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final pagingController =
      PagingController<int, YrNotification>(firstPageKey: 1);
  final _services = APIServices();
  final _pageSize = 20;
  final _notificationServices = NotificationServices();

  NotificationCubit() : super(NotificationState.initial()) {
    _notificationServices.addListener(onForegroundNotificationReceived);
    _fetchPage(1);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Future<void> close() async {
    _notificationServices.removeListener(onForegroundNotificationReceived);
    super.close();
  }

  void onForegroundNotificationReceived() {
    onRefreshed();
  }

  Future<bool> markOneAsSeen(String notificationId) async {
    try {
      await _services.markOneAsSeen(notificationId);
      return true;
    } on DioError catch (e) {
      printLog(
          "[$runtimeType] markOneAsSeen error:$notificationId  ${e.response?.data} ${e.message}");
      return false;
    }
  }

  void markAllSeen() async {
    try {
      await _services.markAllSeen();
      onRefreshed();
    } on DioError catch (e) {
      printLog(
          "[$runtimeType] markAllSeen error: ${e.response?.data} ${e.message}");
    }
  }

  void onRefreshed() {
    emit(NotificationState.initial());
    pagingController.refresh();
  }

  Future<void> _fetchPage(int lastId) async {
    try {
      final notifications =
          await _services.getNotifications(lastId: lastId, pageSize: _pageSize);
      final isLastPage = notifications.length < _pageSize;
      emit(
        state.copyWith(
          notifications: [
            ...state.notifications,
            ...notifications,
          ],
        ),
      );
      if (isLastPage) {
        pagingController.value = PagingState(
          itemList: state.notifications,
        );
      } else {
        final nextPageKey = notifications.last.id;
        pagingController.value = PagingState(
          nextPageKey: int.parse(nextPageKey),
          itemList: state.notifications,
        );
      }
    } on DioError catch (error) {
      pagingController.value = PagingState(
        nextPageKey: lastId,
        error: error,
      );
      printLog(
          "[$runtimeType] fetch page error lastId:$lastId ${error.response?.data} ${error.message}");
    }
  }

  Future<bool> onNotificationClicked(YrNotification item) async {
    final result = await _notificationServices.handleNotificationClick(item);
    if (result) {
      return true;
    }
    return false;
  }
}
