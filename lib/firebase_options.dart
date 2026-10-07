// File generated / configured for Firebase initialization.
// TODO: Replace this placeholder file with your actual Firebase config options
// by placing google-services.json (Android) and GoogleService-Info.plist (iOS)
// in their respective app directories, or by running `flutterfire configure`.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: Insert your Firebase Web options here if compiling for web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'eventon-app',
    authDomain: 'eventon-app.firebaseapp.com',
    storageBucket: 'eventon-app.appspot.com',
  );

  // TODO: Insert your Firebase Android options here (or rely on google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'eventon-app',
    storageBucket: 'eventon-app.appspot.com',
  );

  // TODO: Insert your Firebase iOS options here (or rely on GoogleService-Info.plist)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'eventon-app',
    storageBucket: 'eventon-app.appspot.com',
    iosBundleId: 'com.eventongo',
  );
}
