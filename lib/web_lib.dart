import 'dart:html' as html;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';


void init(){
}


void _launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Откроет URL в новой вкладке
    );
  } else {
    throw 'Could not launch $url';
  }
}

Widget webWidget(Uri url) {
    _launchURL(url);
    return Center(
      child: GestureDetector(
        onTap: () {
          _launchURL(url);
        }, // Открывает URL при нажатии
        child: const Text(
          'Открыть SpeedTest.ru',
          style: TextStyle(
            color: Colors.blue, // Синий цвет текста для имитации ссылки
            decoration: TextDecoration.underline, // Подчёр кивание текста
          ),
        ),
      ),
    );
}

void redirectToPaymentUrl(){

}

void showWebNotification(BuildContext context,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message) {
  if (html.Notification.permission == 'granted') {
    if (message.notification != null) {
      html.Notification(message.notification!.title!,
          body: message.notification!.body!);
    }
  } else {
    // Запрашиваем разрешение
    html.Notification.requestPermission().then((permission) {
      if (permission == 'granted') {
        if (message.notification != null) {
          html.Notification(message.notification!.title!,
              body: message.notification!.body!);
        }
      } else {
        debugPrint('Notification permission denied');
      }
    });
  }
}

Future<void> foregroundMessage2() async {

}