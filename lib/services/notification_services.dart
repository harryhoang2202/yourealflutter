import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_cubit/chat_cubit.dart';
import 'package:youreal/app/chats/models/group_chat.dart';
import 'package:youreal/app/chats/views/chat_detail_screen.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';
import 'package:youreal/app/deal/deal_detail/detail_deal.dart';
import 'package:youreal/app/notification/models/yr_notification.dart';

import 'package:youreal/common/constants/enums.dart';

import 'package:youreal/common/constants/general.dart';

import 'services_api.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

class NotificationServices extends ChangeNotifier {
  static final NotificationServices _internal = NotificationServices._();

  NotificationServices._();

  factory NotificationServices() => _internal;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initialize() async {
    await _setupNotification();

    _setupBackgroundNotification();
    _setupForegroundNotification();
    await _handleBackgroundNotificationClick();
  }

  //#region Setup Local Notification
  Future _setupNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (res) {
      _handleForegroundNotificationClick(res.payload);
    });
  }
  //#endregion

  //region setup background notification handler

  Future _setupBackgroundNotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  //#endregion

  //#region Setup foreground notification
  late StreamSubscription onForegroundMessageSubscription;
  String deviceToken = "";

  Future _setupForegroundNotification() async {
    onForegroundMessageSubscription =
        FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    _getDeviceToken();
  }

  void _getDeviceToken() async {
    final String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    deviceToken = token ?? "";
  }

  void _firebaseMessagingForegroundHandler(RemoteMessage message) {
    printLog('[$runtimeType] Handling a foreground message ${message.data}');
    notifyListeners();
    _showNotification(message);
  }

//#endregion

  //#region iOS notification received (for old iOS version)
  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  //#endregion

  //#region on notification selected

  YrNotification? _selectedNotificationData;

  YrNotification? get notification {
    return _selectedNotificationData;
  }

  void _handleForegroundNotificationClick(String? payload) {
    if (payload == null) return;
    _selectedNotificationData = YrNotification.fromJson(jsonDecode(payload));
    printLog("[$runtimeType] foreground click $_selectedNotificationData");
    handleNotificationClick();
  }

  YrNotification? _notificationHandled() {
    if (_selectedNotificationData == null) return null;
    final temp = _selectedNotificationData;
    _selectedNotificationData = null;
    return temp;
  }

  Future _handleBackgroundNotificationClick() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    printLog(
        "[$runtimeType] Notification payload: ${notificationAppLaunchDetails?.notificationResponse?.payload}");

    if (notificationAppLaunchDetails == null ||
        notificationAppLaunchDetails.notificationResponse?.payload == null) {
      return;
    }
    if (notificationAppLaunchDetails.didNotificationLaunchApp) {
      _selectedNotificationData = YrNotification.fromJson(jsonDecode(
          notificationAppLaunchDetails.notificationResponse!.payload!));
    }
  }

  Future<bool> handleNotificationClick(
      [YrNotification? optionalNotification]) async {
    if (optionalNotification != null) {
      _selectedNotificationData = optionalNotification;
    }
    bool result = false;
    //if no notification clicked, do nothing
    if (_selectedNotificationData == null) return result;
    if (navigatorKey.currentContext == null ||
        navigatorKey.currentState == null) return result;
    final apiServices = APIServices();
    final context = navigatorKey.currentContext!;

    final notification = _selectedNotificationData!;
    switch (notification.notificationType) {
      case NotificationType.investorClosed:
      case NotificationType.dealAppraised:
      case NotificationType.representativeChosen:
      case NotificationType.totallyPaid:
      case NotificationType.changeOwner:
      case NotificationType.contractSigned:
        final deal = await apiServices.getDealById(
            dealId: _selectedNotificationData!.targetId);
        if (deal == null) return result;
        apiServices.markOneAsSeen(notification.id);
        _navigateToDealTracking(deal);
        break;
      case NotificationType.newDeal:
        final deal = await apiServices.getDealById(
            dealId: _selectedNotificationData!.targetId);
        if (deal == null) return result;
        apiServices.markOneAsSeen(notification.id);
        _navigateToDetailDealAsAdmin(deal, context);
        break;
      case NotificationType.newMessage:
        final deal = await apiServices.getDealById(
            dealId: _selectedNotificationData!.targetId);
        if (deal == null) return result;
        apiServices.markOneAsSeen(notification.id);
        _navigateToChatDetail(deal, context);
        break;
      case NotificationType.newAppraisalRequest:
        final deal = await apiServices.getDealById(
            dealId: _selectedNotificationData!.targetId);
        if (deal == null) {
          printLog(
              "[$runtimeType][handleNotificationClick] ${notification.notificationType} deal is null");
          return result;
        }
        apiServices.markOneAsSeen(notification.id);
        _navigateToDetailDealAsAppraiser(deal, context);
        break;

      case NotificationType.newNotification:
        break;
      case NotificationType.none:
        break;
      case NotificationType.none1:
        break;
    }
    _notificationHandled();
    result = true;
    return result;
  }

  void _navigateToDealTracking(Deal deal) {
    navigatorKey.currentState?.pushNamed(
      DealTracking.id,
      arguments: deal,
    );
  }

  void _navigateToChatDetail(Deal deal, BuildContext context) {
    final groupChat = GroupChat.formDeal(deal);
    navigatorKey.currentState?.pushNamed(
      ChatDetailScreen.id,
      arguments: ChatDetailArgs(
        groupChat: groupChat,
        authBloc: context.read<AuthBloc>(),
        chatCubit: context.read<ChatCubit>(),
      ),
    );
  }

  void _navigateToDetailDealAsAppraiser(Deal deal, BuildContext context) async {
    Navigator.pushNamed(
      context,
      DetailDeal.id,
      arguments: DetailDealArs(
        deal: deal,
      ),
    );
  }

  void _navigateToDetailDealAsAdmin(Deal deal, BuildContext context) async {
    Navigator.pushNamed(
      context,
      DetailDeal.id,
      arguments: DetailDealArs(deal: deal),
    );
  }

//#endregion
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  printLog(
      '[NotificationServices] Handling a background message ${message.data}');

  _showNotification(message);
}

void _showNotification(RemoteMessage message) {
  message.data
    ..putIfAbsent("notificationTypeId", () => "-1")
    ..putIfAbsent("createdTime", () => DateTime.now().toUtc().toString());
  message.data["targetId"] =
      int.tryParse(message.data["targetId"]?.toString() ?? "");
  message.data["notificationTargetTypeId"] =
      int.tryParse(message.data["notificationTargetTypeId"]?.toString() ?? "");
  YrNotification yrNoti = YrNotification.fromJson(message.data);
  printLog("[NotificationServices] Show notification: $yrNoti");
  final androidNotification = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    icon: "@mipmap/launcher_icon",
  );

  const iOSNotification = DarwinNotificationDetails();

  final notificationDetail = NotificationDetails(
    android: androidNotification,
    iOS: iOSNotification,
  );

  flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    "Bạn có thông báo mới",
    yrNoti.message,
    notificationDetail,
    payload: jsonEncode(yrNoti.toJson()),
  );
}
