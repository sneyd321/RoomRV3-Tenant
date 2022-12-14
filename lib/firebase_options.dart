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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBxpgJlnz2e5NV03gFfDQQjd0NVv8RvD0w',
    appId: '1:959426188245:web:abb42fee97361a4b50a35c',
    messagingSenderId: '959426188245',
    projectId: 'roomr-222721',
    authDomain: 'roomr-222721.firebaseapp.com',
    databaseURL: 'https://roomr-222721.firebaseio.com',
    storageBucket: 'roomr-222721.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZNz6yrGRa698IjwKwtOIEk9Bb4F7fC_Q',
    appId: '1:959426188245:android:20ed12f7f44e0b7450a35c',
    messagingSenderId: '959426188245',
    projectId: 'roomr-222721',
    databaseURL: 'https://roomr-222721.firebaseio.com',
    storageBucket: 'roomr-222721.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArAvmyQMbn5hg5Fk6NKzki2Wk5IrIofF8',
    appId: '1:959426188245:ios:c651c5b48ec9b13650a35c',
    messagingSenderId: '959426188245',
    projectId: 'roomr-222721',
    databaseURL: 'https://roomr-222721.firebaseio.com',
    storageBucket: 'roomr-222721.appspot.com',
    androidClientId: '959426188245-fhl4i2dm48k1k1r95btrhto88dlq4l22.apps.googleusercontent.com',
    iosClientId: '959426188245-epmq8jo2jr996v7llfk3ev1r1mh9lsqo.apps.googleusercontent.com',
    iosBundleId: 'com.example.cameraExample',
  );
}
