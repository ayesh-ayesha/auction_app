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

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyATepoVH1frV0Uk7O_rmUJ9FaTmInDhVas',
    appId: '1:376924957138:ios:b6c4d3c391da3d6f0c800b',
    messagingSenderId: '376924957138',
    projectId: 'sem-proj-auction',
    storageBucket: 'sem-proj-auction.firebasestorage.app',
    iosBundleId: 'com.example.auctionApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCBs1DWeo8VSl855oKt4SIjicMxUdhuWSA',
    appId: '1:376924957138:web:8fc063a88a6fe1960c800b',
    messagingSenderId: '376924957138',
    projectId: 'sem-proj-auction',
    authDomain: 'sem-proj-auction.firebaseapp.com',
    storageBucket: 'sem-proj-auction.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCBs1DWeo8VSl855oKt4SIjicMxUdhuWSA',
    appId: '1:376924957138:web:2a4d4b1b936b37330c800b',
    messagingSenderId: '376924957138',
    projectId: 'sem-proj-auction',
    authDomain: 'sem-proj-auction.firebaseapp.com',
    storageBucket: 'sem-proj-auction.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyATepoVH1frV0Uk7O_rmUJ9FaTmInDhVas',
    appId: '1:376924957138:ios:b6c4d3c391da3d6f0c800b',
    messagingSenderId: '376924957138',
    projectId: 'sem-proj-auction',
    storageBucket: 'sem-proj-auction.firebasestorage.app',
    iosBundleId: 'com.example.auctionApp',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuc35R_HvGZuJH0QZSkr17SCVIxGwnzUA',
    appId: '1:376924957138:android:23716d7a42cf8d510c800b',
    messagingSenderId: '376924957138',
    projectId: 'sem-proj-auction',
    storageBucket: 'sem-proj-auction.firebasestorage.app',
  );

}