
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lkmobileapp/bloc/login_bloc.dart';
import 'package:lkmobileapp/bloc/main_bloc.dart';
import 'package:lkmobileapp/bloc/payment/payment_bloc.dart';
import 'package:lkmobileapp/entity/contract_details.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/notification_service.dart';
import 'package:lkmobileapp/output/firebase_token_client.dart';
import 'package:lkmobileapp/widget/change_password.dart';
import 'package:lkmobileapp/widget/login.dart';
import 'package:lkmobileapp/widget/payments.dart';
import 'package:lkmobileapp/widget/speed_test_widget.dart';
import 'package:lkmobileapp/widget/home.dart';

import '../bloc/home_bloc.dart';

class MainWindow extends StatefulWidget {
  final FirebaseTokenClient firebaseTokenClient;
  final LkPreferences lkPreferences;
  final NotificationService notificationService;

  const MainWindow({super.key,
    required this.firebaseTokenClient,
    required this.lkPreferences,
    required this.notificationService,
  });

  @override
  State<StatefulWidget> createState() {
    return MainWidgetState(
        lkPreferences: lkPreferences,
        notificationService: notificationService);
  }
}

class MainWidgetState extends State<MainWindow> {
  static const String _title = 'Fly-Tech';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LkPreferences lkPreferences;
  final NotificationService notificationService;

  MainWidgetState({
    required this.lkPreferences,
    required this.notificationService
  });

  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermissions();
    notificationService.foregroundMessage();
    notificationService.firebaseInit(context);
    notificationService.isRefsreshToken();
    // todo: я это закомментировал возможно из за этого будут проблемы с получение уведомлений
    // но у меня это вызывается при авторизации
    //notificationService.getDeviceToken().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = context.read<MainBloc>();
    final LoginBloc loginBloc = context.read<LoginBloc>();
    final HomeBloc homeBloc = context.read<HomeBloc>();
    final PaymentBloc paymentBloc = context.read<PaymentBloc>();
    return MaterialApp(
      theme: ThemeData.light(),
      title: _title,
      home: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          debugPrint(state.toString());
          if (state is MainInitial) {
            // Загружаем зарегистрированные контракты
            mainBloc.add(MainLoadRegisteredContractEvent(index: -1));
            return const CircularProgressIndicator();
          } else if (state is MainNoRegisteredContractState) {
            // Если нет зарегистрированных контрактов отправляем на форму ВХОДА
            return Scaffold(
              appBar: AppBar(
                  title: (const Text(_title)),
                  backgroundColor: ThemeData.light().colorScheme.surface),
              body: const LoginDemo(
                index: -1,
              ),
            );
          } else if (state is MainAddContractState) {
            return Scaffold(
              appBar: AppBar(
                  title: (const Text(_title)),
                  backgroundColor: ThemeData.light().colorScheme.surface),
              body: LoginDemo(index: state.index),
            );
          } else if (state is MainLoadedContractListState) {
            homeBloc.add(HomeLoadContractEvent(
                index: state.index, contractDetailList: state.contractDetailsList));
            paymentBloc.add(PaymentStartEvent(contract: state.contractDetailsList[state.index].contract));
            int selectIndex = 0;
            PageController pageController = PageController();
            return Scaffold(
              drawer: getHomeDrawer(mainBloc, loginBloc, homeBloc, state.index,
                  state.contractDetailsList, pageController),
              appBar: AppBar(
                  title: SizedBox(
                    width: 100,
                    height: 50,
                    child: Image.asset("assets/images/Fly-tech Logo_V.png"),
                  ),
                  //(const Text(_title)),
                  backgroundColor: const Color.fromARGB(255, 135, 135, 169)),
              body: PageView(
                controller: pageController,
                children: [
                  HomeWidget(pageController: pageController),
                  //Payments().build(context),
                  Payments(),
                  SpeedTest(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Главная"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.wallet), label: "Оплата"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.speed), label: "скорость"),
                ],
                currentIndex: selectIndex,
                selectedItemColor: const Color.fromARGB(255, 135, 135, 169),
                onTap: ((pageIndex) {
                  selectIndex = pageIndex;
                  pageController.jumpToPage(pageIndex);
                }),
              ),
            );
          } else if (state is MainChangePasswordState) {
            return Scaffold(
              appBar: AppBar(),
              body: ChangePassword(index: state.index),
            );
          } else {
            return Text('Unknown main state $state');
          }
        },
      ),
    );
  }

  Widget getHomeDrawer(
      MainBloc mainBloc,
      LoginBloc loginBloc,
      HomeBloc homeBloc,
      int index,
      List<ContractDetails> contractDetailList,
      PageController pageController) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
              accountName: Text("Номер договора№ "),
              accountEmail: Text("Тариф")),
          TextButton.icon(
            label: const Text("Главная"),
            icon: const Icon(Icons.home),
            onPressed: () {
              //toggleDrawer();
              pageController.jumpToPage(0);
            },
          ),
          const Divider(),
          TextButton.icon(
            label: const Text("Оплата"),
            icon: const Icon(Icons.wallet),
            onPressed: () {
              pageController.jumpToPage(1);
            },
          ),
          const Divider(),
          TextButton.icon(
            label: const Text("Проверка Скорости"),
            icon: const Icon(Icons.speed),
            onPressed: () {
              pageController.jumpToPage(2);
            },
          ),
          const Divider(),
          TextButton.icon(
            label: const Text("Добавить Договор"),
            icon: const Icon(Icons.add),
            onPressed: () {
              if (index < 0) {
                mainBloc.add(MainAddContractEvent(index: 0));
              } else {
                mainBloc.add(MainAddContractEvent(index: index));
              }
            },
          ),
          const Divider(),
          TextButton.icon(
            label: const Text("Поддержка"),
            icon: const Icon(Icons.support),
            onPressed: () {},
          ),
          const Divider(),
          TextButton.icon(
            label: const Text("Выход"),
            icon: const Icon(Icons.support),
            onPressed: () async {              
              homeBloc.add(HomeInitEvent());
              mainBloc.add(MainResetPreferencesEvent());
              loginBloc.add(LoginFinishedEvent());
            },
          ),
          const Divider(),
          TextButton.icon(
            label: const Text("Поменять пароль"),
            icon:  const Icon(Icons.support),
            onPressed: () async {
              mainBloc.add(MainChangePasswordEvent(index: index));
            },
          )
        ],
      ),
    );
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState != null && _scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    Navigator.of(context).pop(); // Close the drawer
  }

}