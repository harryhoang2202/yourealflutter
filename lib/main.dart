import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youreal/di/dependency_injection.dart';

import 'package:youreal/services/hive_service.dart';
import 'package:youreal/services/notification_services.dart';
import 'package:youreal/view_models/app_bloc_observer.dart';

import 'app.dart';
import 'common/constants/general.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveService.initialize();
  NotificationServices().initialize();
  configureDependencies();

  Provider.debugCheckInvalidValueType = null;
  printLog('[main] ============== main.dart START ==============');
  AppBlocObserver();

  /// enable network traffic logging
  cameras = await availableCameras();
  HttpClient.enableTimelineLogging = false;
  runZoned(() {
    runApp(const App());
  });
}
