import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Catch framework-level errors
    FlutterError.onError = (FlutterErrorDetails details) {
      final errStr = details.exception.toString();
      if (errStr.contains('WebSocketConnectionClosed') ||
          errStr.contains('Connection Closed') ||
          errStr.contains('SocketException')) {
        debugPrint('[Network] Handled Flutter socket error: ${details.exception}');
        return;
      }
      FlutterError.presentError(details);
    };

    // Catch isolate/platform-level asynchronous errors
    PlatformDispatcher.instance.onError = (error, stack) {
      final errStr = error.toString();
      if (errStr.contains('WebSocketConnectionClosed') ||
          errStr.contains('Connection Closed') ||
          errStr.contains('SocketException')) {
        debugPrint('[Network] Handled platform socket error: $error');
        return true;
      }
      return false;
    };

    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint('DotEnv initialization warning: $e');
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      // Log exception if Firebase config files are not yet fully supplied
      debugPrint('Firebase initialization warning: $e');
    }

    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) {
    final errStr = error.toString();
    if (errStr.contains('WebSocketConnectionClosed') ||
        errStr.contains('Connection Closed') ||
        errStr.contains('SocketException')) {
      debugPrint('[Network] Handled zoned socket error: $error');
      return;
    }
    debugPrint('[Network] Uncaught zone error: $error\n$stack');
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'EventOnGo',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
