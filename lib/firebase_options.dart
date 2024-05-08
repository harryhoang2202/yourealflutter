// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANTayq8I_ltnGh-h47YBxEPcuW5ZJMmX0',
    appId: '1:574539476225:android:42d4d15ca7c385fcd53f00',
    messagingSenderId: '574539476225',
    projectId: 'youreal-dev',
    storageBucket: 'youreal-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjeJPL8zp7TDZR9FenMmX8ijCwHz5dbpw',
    appId: '1:574539476225:ios:ae0f8e3d8880885ad53f00',
    messagingSenderId: '574539476225',
    projectId: 'youreal-dev',
    storageBucket: 'youreal-dev.appspot.com',
    androidClientId: '574539476225-31t02e6pvj446ktr5loc6vfc2cmo8a04.apps.googleusercontent.com',
    iosClientId: '574539476225-8pkuepd42vc0ii9ndqkhkevola4euqtq.apps.googleusercontent.com',
    iosBundleId: 'vn.youreal.youreal',
  );
}
