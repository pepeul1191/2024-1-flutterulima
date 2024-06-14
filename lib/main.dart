import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // socket
  if (Platform.isAndroid) {
    // Solicitar permiso para ignorar las optimizaciones de batería
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "WebSocket Service",
      notificationText: "WebSocket is running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon:
          AndroidResource(name: 'background_icon', defType: 'drawable'),
    );

    bool hasPermissions =
        await FlutterBackground.initialize(androidConfig: androidConfig);

    if (hasPermissions) {
      await FlutterBackground.enableBackgroundExecution();
    } else {
      await requestIgnoreBatteryOptimizationsPermission();
    }
  }
  await initializeNotifications();
  runApp(const MyApp());
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> requestIgnoreBatteryOptimizationsPermission() async {
  const platform =
      MethodChannel('com.example.ulimagym/ignoreBatteryOptimizations');

  try {
    await platform.invokeMethod('requestIgnoreBatteryOptimizations');
  } on PlatformException catch (e) {
    print("Failed to request ignore battery optimizations: '${e.message}'.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: 'Login', home: LoginPage());
  }
}
