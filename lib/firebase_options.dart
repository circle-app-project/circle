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
    apiKey: 'AIzaSyCFR5ojcWvT6L14rD7bblKp0Xmtejz3mV0',
    appId: '1:497391679746:android:a319dbe660bcd9fc9d2a1b',
    messagingSenderId: '497391679746',
    projectId: 'circle-60af7',
    storageBucket: 'circle-60af7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxUMMIq1C6muG8Wa5LT6lq63FGmC2_0-Y',
    appId: '1:497391679746:ios:ce9d435c188cbe499d2a1b',
    messagingSenderId: '497391679746',
    projectId: 'circle-60af7',
    storageBucket: 'circle-60af7.appspot.com',
    androidClientId: '497391679746-d3patbdn3smkrcfu4sfkh56ruh07tbm3.apps.googleusercontent.com',
    iosClientId: '497391679746-mmog40ou9n89bod6psq5g7vreug4lm6g.apps.googleusercontent.com',
    iosBundleId: 'com.circle.app',
  );

}