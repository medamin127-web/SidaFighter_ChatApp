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
        return macos;
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
    apiKey: 'AIzaSyBHrpC8SbBblgQ5LltOlLMvGPjZdqAzeaU',
    appId: '1:119880726897:web:c8ea9581d571e7c0519ed0',
    messagingSenderId: '119880726897',
    projectId: 'sidaapp-57f86',
    authDomain: 'sidaapp-57f86.firebaseapp.com',
    storageBucket: 'sidaapp-57f86.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUf0AeWZo9HJhByN0tpkCZqkePFd_WGnY',
    appId: '1:119880726897:android:2012b93462b11d4e519ed0',
    messagingSenderId: '119880726897',
    projectId: 'sidaapp-57f86',
    storageBucket: 'sidaapp-57f86.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBk4lE9bmKxoxoiMz2s-5Km2tT2XQ9yDQY',
    appId: '1:119880726897:ios:1228ad495e1f1119519ed0',
    messagingSenderId: '119880726897',
    projectId: 'sidaapp-57f86',
    storageBucket: 'sidaapp-57f86.appspot.com',
    iosClientId: '119880726897-p3ac6bsu6l7pe1jte0dcgq3mals0dooi.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBk4lE9bmKxoxoiMz2s-5Km2tT2XQ9yDQY',
    appId: '1:119880726897:ios:1228ad495e1f1119519ed0',
    messagingSenderId: '119880726897',
    projectId: 'sidaapp-57f86',
    storageBucket: 'sidaapp-57f86.appspot.com',
    iosClientId: '119880726897-p3ac6bsu6l7pe1jte0dcgq3mals0dooi.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );
}