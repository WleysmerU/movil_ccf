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
    apiKey: 'AIzaSyCr4EvN3Apzh8-hj6MVhvXshF77Lo6mstE',
    appId: '1:348144963413:web:8a1e651f4a8f44f438e9dc',
    messagingSenderId: '348144963413',
    projectId: 'agroapp2',
    authDomain: 'agroapp2.firebaseapp.com',
    storageBucket: 'agroapp2.firebasestorage.app',
    measurementId: 'G-NFQ7RSX9MC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDN-fYm7W3HgBvrZKbI15RQORcExTLlvuQ',
    appId: '1:348144963413:android:baeabd5c6a0d29f438e9dc',
    messagingSenderId: '348144963413',
    projectId: 'agroapp2',
    storageBucket: 'agroapp2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpRAfJ1X09R-kvxKBl06CY8W2tR7269rI',
    appId: '1:348144963413:ios:cee2b137e845ae8438e9dc',
    messagingSenderId: '348144963413',
    projectId: 'agroapp2',
    storageBucket: 'agroapp2.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication9',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCpRAfJ1X09R-kvxKBl06CY8W2tR7269rI',
    appId: '1:348144963413:ios:cee2b137e845ae8438e9dc',
    messagingSenderId: '348144963413',
    projectId: 'agroapp2',
    storageBucket: 'agroapp2.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication9',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCr4EvN3Apzh8-hj6MVhvXshF77Lo6mstE',
    appId: '1:348144963413:web:3204c082e7a78c6238e9dc',
    messagingSenderId: '348144963413',
    projectId: 'agroapp2',
    authDomain: 'agroapp2.firebaseapp.com',
    storageBucket: 'agroapp2.firebasestorage.app',
    measurementId: 'G-BCGHS9X0S0',
  );
}