import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/firebase_token_client.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:lkmobileapp/mobile_lib.dart' if (dart.library.html) 'package:lkmobileapp/web_lib.dart';


class NotificationService {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final FirebaseTokenClient firebaseTokenClient;
  final LkPreferences lkPreferences;

  NotificationService(
      {required this.firebaseTokenClient, required this.lkPreferences}) {
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isWeb) {
      _flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
    }
  }

  Future<String> getDeviceToken() async {
    String? token;
    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    } else if (UniversalPlatform.isWeb) {
      token = await FirebaseMessaging.instance.getToken(
          vapidKey:
              'BLlhB-cYu8YxCD_LJ9v2tD_tX0e51vVlCBQUAabZ7T0Eir0Cau_-nguwQoSjVpaH0KXEwiioPE4M6AOsQLE0f10');
    } else {
      token = await FirebaseMessaging.instance.getToken();
    }
    debugPrint(token!);
    // save in the server
    return token;
  }

  void isRefsreshToken() async {
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isWeb) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        firebaseTokenClient.setTokenForContracts(
            lkPreferences.getContractDetails(), token);
        debugPrint('token refreshed $token');
      });
    }
  }

  void requestNotificationPermissions() async {
    if (UniversalPlatform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: true,
          provisional: true,
          sound: true,
          criticalAlert: true);
    }
    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      NotificationSettings notificationSettings =
          await FirebaseMessaging.instance.requestPermission(
              alert: true,
              announcement: true,
              badge: true,
              carPlay: true,
              provisional: true,
              sound: true,
              criticalAlert: true);

      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        debugPrint('пользователь разрешил все права необходимые');
      } else if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('пользователь уже ранее разрешил все необход');
      } else {
        debugPrint('Пользователь запретил выдачу прав');
      }
    }
  }

  void firebaseInit(BuildContext context) {
    // FirebaseMessaging.onMessageOpenedApp.listen(
    //     (message){
    //       print("onMessageOpenedAppHandler");
    //     }
    // );
    // FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
    debugPrint("firebase init started");

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("listen started");
      RemoteNotification? notification = message.notification;
      //AndroidNotification? androidNotification = message.notification?.android;
      debugPrint("Notification title: ${notification!.title}");
      debugPrint("Notification body: ${notification.body}");
      debugPrint("Data: ${message.data.toString()}");

      showWebNotification(context, _flutterLocalNotificationsPlugin, message);
    });
  }

  void foregroundMessage() {
    foregroundMessage2();
  }


}
