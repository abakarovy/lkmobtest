import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lkmobileapp/bloc/change_pwd_bloc.dart';
import 'package:lkmobileapp/bloc/home_bloc.dart';
import 'package:lkmobileapp/bloc/login_bloc.dart';
import 'package:lkmobileapp/bloc/main_bloc.dart';
import 'package:lkmobileapp/bloc/payment/payment_bloc.dart';
import 'package:lkmobileapp/bloc/payment/payments_list_bloc.dart';
import 'package:lkmobileapp/data/c2bmembers_data.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/notification_service.dart';
import 'package:lkmobileapp/output/authorization_client.dart';
import 'package:lkmobileapp/output/payment_client.dart';
import 'package:lkmobileapp/sbp.dart';
import 'package:lkmobileapp/widget/app.dart';
import 'package:flutter/rendering.dart';
import 'package:lkmobileapp/output/contract_status_client.dart';
import 'package:lkmobileapp/output/firebase_token_client.dart';
import 'package:universal_platform/universal_platform.dart';
import 'firebase_options.dart';
import 'package:lkmobileapp/mobile_lib.dart' if (dart.library.html) 'package:lkmobileapp/web_lib.dart';

import 'models/c2bmembers_model.dart';


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  LkPreferences lkPreferences = LkPreferences();
  lkPreferences.init();

  if(UniversalPlatform.isIOS || UniversalPlatform.isAndroid || UniversalPlatform.isWeb){
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  FirebaseTokenClient firebaseTokenClient = FirebaseTokenClient();
  NotificationService notificationService = NotificationService(
      firebaseTokenClient: firebaseTokenClient,
      lkPreferences: lkPreferences);

  Authorization authorization = Authorization(
      notificationService: notificationService,
      firebaseTokenClient: firebaseTokenClient);
  var contractStatusClient = ContractStatusClient();
  var mainBloc = MainBloc(
    authorization: authorization,
    lkPreferences: lkPreferences,
    firebaseTokenClient: firebaseTokenClient,
    notificationService: notificationService,
  );
  HomeBloc homeBloc = HomeBloc(
      authorization: authorization,
      contractStatusClient: contractStatusClient,
      lkPreferences: lkPreferences);
  LoginBloc loginBloc = LoginBloc(
    authorization: authorization,
    lkPreferences: lkPreferences);
  PaymentClient paymentClient = PaymentClient();
  ChangePwdBloc changePwdBloc = ChangePwdBloc(authorization: authorization, lkPreferences: lkPreferences);
  init();
  runApp(LkApp(
    firebaseTokenClient: firebaseTokenClient,
    lkPreferences: lkPreferences,
    homeBloc: homeBloc,
    mainBloc: mainBloc,
    paymentBloc: PaymentBloc(paymentClient: paymentClient),
    paymentsListBloc: PaymentsListBloc(paymentClient: paymentClient),
    loginBloc: loginBloc,
    notificationService: notificationService,
    changePwdBloc: changePwdBloc
  ));

}


