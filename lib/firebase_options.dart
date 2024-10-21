// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAJ2230ddYS7aGMSCzLWvGJsE6xv1tg-Bo',
    appId: '1:875293755489:web:99c25854cf0937af31c220',
    messagingSenderId: '875293755489',
    projectId: 'worknest-96613',
    authDomain: 'worknest-96613.firebaseapp.com',
    storageBucket: 'worknest-96613.appspot.com',
    measurementId: 'G-QW3VWV0G4W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDb71pFwphjuYqdOfo6JN-zK_VB0Eu7pFs',
    appId: '1:875293755489:android:636022fcfd9778c431c220',
    messagingSenderId: '875293755489',
    projectId: 'worknest-96613',
    storageBucket: 'worknest-96613.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyApbol-ygooMOq3HNRHF8BzoBYJqt3b2gQ',
    appId: '1:875293755489:ios:2c4aed85dd67b4fc31c220',
    messagingSenderId: '875293755489',
    projectId: 'worknest-96613',
    storageBucket: 'worknest-96613.appspot.com',
    iosBundleId: 'com.example.worknest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyApbol-ygooMOq3HNRHF8BzoBYJqt3b2gQ',
    appId: '1:875293755489:ios:2c4aed85dd67b4fc31c220',
    messagingSenderId: '875293755489',
    projectId: 'worknest-96613',
    storageBucket: 'worknest-96613.appspot.com',
    iosBundleId: 'com.example.worknest',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJ2230ddYS7aGMSCzLWvGJsE6xv1tg-Bo',
    appId: '1:875293755489:web:d6ba58b5225bd0d031c220',
    messagingSenderId: '875293755489',
    projectId: 'worknest-96613',
    authDomain: 'worknest-96613.firebaseapp.com',
    storageBucket: 'worknest-96613.appspot.com',
    measurementId: 'G-LB9HFSBR41',
  );
}