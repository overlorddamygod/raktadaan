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
    apiKey: 'AIzaSyAMIGLoE0KPZLOX1_ircyoxEIR6A9MoklM',
    appId: '1:782233835233:web:aa1947e0a4ab5c44b589a0',
    messagingSenderId: '782233835233',
    projectId: 'raktadaan-36cfe',
    authDomain: 'raktadaan-36cfe.firebaseapp.com',
    storageBucket: 'raktadaan-36cfe.appspot.com',
    measurementId: 'G-DGP3R767CW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDs2VgToRySPmUN0QFmVeEkc3oTePl9Ag',
    appId: '1:782233835233:android:f2720a6e7f8a2e08b589a0',
    messagingSenderId: '782233835233',
    projectId: 'raktadaan-36cfe',
    storageBucket: 'raktadaan-36cfe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtNMCHELhA7BXnWVFmTBL6eHwAt9KZX-E',
    appId: '1:782233835233:ios:5d5d50a819c5fa4cb589a0',
    messagingSenderId: '782233835233',
    projectId: 'raktadaan-36cfe',
    storageBucket: 'raktadaan-36cfe.appspot.com',
    iosBundleId: 'com.example.raktadaan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtNMCHELhA7BXnWVFmTBL6eHwAt9KZX-E',
    appId: '1:782233835233:ios:41b46a703597c27cb589a0',
    messagingSenderId: '782233835233',
    projectId: 'raktadaan-36cfe',
    storageBucket: 'raktadaan-36cfe.appspot.com',
    iosBundleId: 'com.example.raktadaan.RunnerTests',
  );
}
