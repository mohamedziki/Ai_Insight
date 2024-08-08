
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
    apiKey: 'AIzaSyDyDtdAsMty4foE8za33MOtBIsDGEmCeLQ',
    appId: '1:392904614421:web:1006c0bd3106f769cc241c',
    messagingSenderId: '392904614421',
    projectId: 'climatechangenews-fa2c6',
    authDomain: 'climatechangenews-fa2c6.firebaseapp.com',
    storageBucket: 'climatechangenews-fa2c6.appspot.com',
    measurementId: 'G-W8L1DEGS07',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlGev9e9tzvDRXcg7N4d6xuzrtDngbKI4',
    appId: '1:392904614421:android:767a7a2b43b8c16ecc241c',
    messagingSenderId: '392904614421',
    projectId: 'climatechangenews-fa2c6',
    storageBucket: 'climatechangenews-fa2c6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKNL488Quki8mrXWTfJjrbslU5imMfX2Y',
    appId: '1:392904614421:ios:3c35d1dd12d14804cc241c',
    messagingSenderId: '392904614421',
    projectId: 'climatechangenews-fa2c6',
    storageBucket: 'climatechangenews-fa2c6.appspot.com',
    iosBundleId: 'com.climate.insight.ai.climateInsightAi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKNL488Quki8mrXWTfJjrbslU5imMfX2Y',
    appId: '1:392904614421:ios:3c35d1dd12d14804cc241c',
    messagingSenderId: '392904614421',
    projectId: 'climatechangenews-fa2c6',
    storageBucket: 'climatechangenews-fa2c6.appspot.com',
    iosBundleId: 'com.climate.insight.ai.climateInsightAi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDyDtdAsMty4foE8za33MOtBIsDGEmCeLQ',
    appId: '1:392904614421:web:901fc744953fe1ddcc241c',
    messagingSenderId: '392904614421',
    projectId: 'climatechangenews-fa2c6',
    authDomain: 'climatechangenews-fa2c6.firebaseapp.com',
    storageBucket: 'climatechangenews-fa2c6.appspot.com',
    measurementId: 'G-0WWDMS2DET',
  );
}
