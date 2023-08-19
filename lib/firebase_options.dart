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
    apiKey: 'AIzaSyA4qO7QJ_YaweDvtA-ztni8aFSjQ5w3LA8',
    appId: '1:623100855509:web:e5a37134204fdef9604e5c',
    messagingSenderId: '623100855509',
    projectId: 'homerun-3e122',
    authDomain: 'homerun-3e122.firebaseapp.com',
    storageBucket: 'homerun-3e122.appspot.com',
    measurementId: 'G-J6Z1VBWPSR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbbBKFfP65LoBLXfQR5YOhjmUar7gf4UY',
    appId: '1:623100855509:android:44a56f2d8b96e41a604e5c',
    messagingSenderId: '623100855509',
    projectId: 'homerun-3e122',
    storageBucket: 'homerun-3e122.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkEoeuPR-wm25NwVJyWr5EEi-47OOnM5s',
    appId: '1:623100855509:ios:4e8bf06abf9726f9604e5c',
    messagingSenderId: '623100855509',
    projectId: 'homerun-3e122',
    storageBucket: 'homerun-3e122.appspot.com',
    iosClientId: '623100855509-mj9smjc03og0fmg7hdrc7v8bh6bjf8al.apps.googleusercontent.com',
    iosBundleId: 'com.homerun.app.homerun',
  );
}
