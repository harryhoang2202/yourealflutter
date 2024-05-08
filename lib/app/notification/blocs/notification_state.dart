part of 'notification_cubit.dart';

@freezed
class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState({
    required List<YrNotification> notifications,
    required ButtonStatus status,
  }) = _NotificationState;

  bool get hasNotification {
    final hasNotSeenNotification =
        notifications.any((element) => element.isSeen == false);
    return notifications.isNotEmpty && hasNotSeenNotification;
  }

  factory NotificationState.initial() =>
      const NotificationState(notifications: [], status: ButtonStatus.loading);
}
