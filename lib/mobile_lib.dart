import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lkmobileapp/sbp.dart';
import 'data/c2bmembers_data.dart';
import 'lk_preferences.dart';
import 'models/c2bmembers_model.dart';



void init() {
    getInstalledBanks();
}

/// Получаем установленные банки
Future<void> getInstalledBanks() async {
  try {
    LkPreferences.installedBanks.addAll(await Sbp.getInstalledBanks(
      C2bmembersModel.fromJson(c2bmembersData),
      useAndroidLocalIcons: false,
      useAndroidLocalNames: false,
    ));
  } on Exception catch (e) {
    throw Exception(e);
  }
}

Widget webWidget(Uri _url) {
  return WebViewWidget(
    controller: WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(_url),
  );
}

// void _launchURL(Uri url) async {
//   if (await canLaunchUrl(url)) {
//     await launchUrl(
//       url,
//       mode: LaunchMode.externalApplication, // Откроет URL в новой вкладке
//     );
//     // } else {
//     //   debugPrint('Could not launch $_url');
//     //   //throw 'Could not launch $_url';
//     // }
//   }
// }

void _launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Откроет URL в новой вкладке
    );
  } else {
    debugPrint('Could not launch $url');
    throw 'Could not launch $url';
  }
}

void showWebNotification(BuildContext context,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message) {
  if (UniversalPlatform.isIOS) {
    foregroundMessage2();
  }
  if (UniversalPlatform.isAndroid) {
    initLocalNotifications(context, flutterLocalNotificationsPlugin, message);
    showNotification(flutterLocalNotificationsPlugin, message);
  }
}

Future<void> foregroundMessage2() async {
  if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

void initLocalNotifications(BuildContext context,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message) async {
  var androidInitSettings =
  const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInitSettings = const DarwinInitializationSettings();

  var initializationSettings = InitializationSettings(
      android: androidInitSettings, iOS: iosInitSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    },
  );
}

void handleMessage(BuildContext context, RemoteMessage message) {
  debugPrint("In handleMessage function");
  if (message.data['type'] == 'text') {
    // перенаправление на новую страницу
  }
}


Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message) async {
  AndroidNotificationChannel androidNotificationChannel =
  AndroidNotificationChannel(
    message.notification!.android!.channelId.toString(),
    message.notification!.android!.channelId.toString(),
    importance: Importance.max,
    showBadge: true,
    playSound: true,
  );
  AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(androidNotificationChannel.id.toString(),
      androidNotificationChannel.name.toString(),
      channelDescription: 'Flutter Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: androidNotificationChannel.sound);

  const DarwinNotificationDetails darwinNotificationDetails =
  DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );

  Future.delayed(Duration.zero, () {
    flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, notificationDetails);
  });
}
