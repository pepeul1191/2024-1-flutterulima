import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:async';

class WebSocketController {
  final WebSocketChannel channel;
  final StreamController<String> _streamController =
      StreamController.broadcast();

  WebSocketController(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url)) {
    channel.stream.listen((message) {
      _streamController.add(message);
      _showNotification(message);
      _showToast(message);
    });
  }

  Stream<String> get stream => _streamController.stream;

  void send(String message) {
    if (message.isNotEmpty) {
      channel.sink.add(message);
    }
  }

  void dispose() {
    channel.sink.close(status.goingAway);
    _streamController.close();
  }

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      playSound: true,
      enableLights: true,
      enableVibration: true,
      ledColor: const Color(0xFF00FF00),
      ledOnMs: 1000,
      ledOffMs: 500,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New WebSocket Message',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  static void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
