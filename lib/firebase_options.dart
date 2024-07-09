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
    apiKey: 'AIzaSyCXYwXZm2MCA3Ri_M9HqV9TjLCcFJjM6s4',
    appId: '1:371174484660:web:bb492634866995863645e1',
    messagingSenderId: '371174484660',
    projectId: 'imtihon3-oy',
    authDomain: 'imtihon3-oy.firebaseapp.com',
    databaseURL: 'https://imtihon3-oy-default-rtdb.firebaseio.com',
    storageBucket: 'imtihon3-oy.appspot.com',
    measurementId: 'G-CQ377MBSK0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBBWKL-q_UGnEGQkp8zVysFL7ijUCCsaw',
    appId: '1:371174484660:android:d5f45b9c685b415c3645e1',
    messagingSenderId: '371174484660',
    projectId: 'imtihon3-oy',
    databaseURL: 'https://imtihon3-oy-default-rtdb.firebaseio.com',
    storageBucket: 'imtihon3-oy.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbXqrwoIZTvkk69WrJp7lmcSLUkho5V7U',
    appId: '1:371174484660:ios:b06d7dfccc15ba673645e1',
    messagingSenderId: '371174484660',
    projectId: 'imtihon3-oy',
    databaseURL: 'https://imtihon3-oy-default-rtdb.firebaseio.com',
    storageBucket: 'imtihon3-oy.appspot.com',
    iosBundleId: 'com.example.dars12',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbXqrwoIZTvkk69WrJp7lmcSLUkho5V7U',
    appId: '1:371174484660:ios:b06d7dfccc15ba673645e1',
    messagingSenderId: '371174484660',
    projectId: 'imtihon3-oy',
    databaseURL: 'https://imtihon3-oy-default-rtdb.firebaseio.com',
    storageBucket: 'imtihon3-oy.appspot.com',
    iosBundleId: 'com.example.dars12',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCXYwXZm2MCA3Ri_M9HqV9TjLCcFJjM6s4',
    appId: '1:371174484660:web:97b19121e32ba5a53645e1',
    messagingSenderId: '371174484660',
    projectId: 'imtihon3-oy',
    authDomain: 'imtihon3-oy.firebaseapp.com',
    databaseURL: 'https://imtihon3-oy-default-rtdb.firebaseio.com',
    storageBucket: 'imtihon3-oy.appspot.com',
    measurementId: 'G-TGXZRZSJ5P',
  );
}
