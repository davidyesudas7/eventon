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

  // Android options extracted from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmFM8V-wEHASj1JxfXeV3raFyfBEIENy0',
    appId: '1:220479295788:android:5a1a2259d043ceaa15dc89',
    messagingSenderId: '220479295788',
    projectId: 'event-on-e975f',
    storageBucket: 'event-on-e975f.firebasestorage.app',
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
