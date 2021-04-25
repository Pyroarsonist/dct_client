import 'package:dct_client/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initPushNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

}

Future<void> scheduleNotification(
  String body,
) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'default_channel_id',
    'default_channel_name',
    'default_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const details = NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(0, appTitle, body, details);
}
