import 'package:flutter/material.dart';
import 'package:lkmobileapp/bloc/change_pwd_bloc.dart';
import 'package:lkmobileapp/bloc/home_bloc.dart';
import 'package:lkmobileapp/bloc/login_bloc.dart';
import 'package:lkmobileapp/bloc/main_bloc.dart';
import 'package:lkmobileapp/bloc/payment/payment_bloc.dart';
import 'package:lkmobileapp/bloc/payment/payments_list_bloc.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/notification_service.dart';
import 'package:lkmobileapp/output/firebase_token_client.dart';
import 'package:lkmobileapp/widget/main_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LkApp extends StatelessWidget {
  final FirebaseTokenClient firebaseTokenClient;
  final LkPreferences lkPreferences;
  final HomeBloc homeBloc;
  final MainBloc mainBloc;
  final LoginBloc loginBloc;
  final PaymentsListBloc paymentsListBloc;
  final PaymentBloc paymentBloc;
  final NotificationService notificationService;
  final ChangePwdBloc changePwdBloc;

   const LkApp({
    super.key,
    required this.firebaseTokenClient,
    required this.lkPreferences,
    required this.homeBloc,
    required this.mainBloc,
    required this.loginBloc,
    required this.paymentsListBloc,
    required this.paymentBloc,
    required this.notificationService,
    required this.changePwdBloc
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          BlocProvider(create: (context) => homeBloc),
          BlocProvider(create: (context) => mainBloc),
          BlocProvider(create: (context) => loginBloc),
          BlocProvider(create: (context) => paymentsListBloc),
          BlocProvider(create: (context) => paymentBloc),
          BlocProvider(create: (context) => changePwdBloc) 
        ],
        child: MaterialApp(
          title: 'LkApp',
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => MainWindow(
                  firebaseTokenClient: firebaseTokenClient,
                  lkPreferences: lkPreferences,
                  notificationService: notificationService,
                ),
          },
          // onGenerateRoute: (settings) {
          //   return MaterialPageRoute(
          //       builder: (BuildContext context) => LoginDemo());
          // },
          // onUnknownRoute: (settings) {
          //   return MaterialPageRoute(
          //       builder: (BuildContext context) => LoginDemo());
          // },
        ),
      ),
    );
  }
}
