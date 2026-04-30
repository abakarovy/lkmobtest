import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lkmobileapp/entity/contract_details.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/notification_service.dart';
import 'package:lkmobileapp/output/authorization_client.dart';
import 'package:lkmobileapp/output/firebase_token_client.dart';
import 'package:universal_platform/universal_platform.dart';


part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final Authorization authorization;
  final LkPreferences lkPreferences;
  final FirebaseTokenClient firebaseTokenClient;
  final NotificationService notificationService;

  MainBloc({
    required this.authorization,
    required this.lkPreferences,
    required this.firebaseTokenClient,
    required this.notificationService,
  }) : super(MainInitial()) {
    on<MainEvent>((event, emit) {
    });

    on<MainLoadRegisteredContractEvent>((event, emit) async {
      log("MainLoadRegisteredContractEvent");
      var list = lkPreferences.getContractDetails();
      for (int i=0;i<list.length;i++){
        // Вызов логина очень важе
        try {
          debugPrint("вызов логина в MainBloc");
          //ContractDetails contractDetail = await authorization.login(
          //    list[i].username, list[i].password);
          //lkPreferences.updateContract(contractDetail, i);
        } on Exception catch (e){
          log(e.toString());
          // error auth processing
          //lkPreferences.removeContract(i);
          //String token = await notificationService.getDeviceToken();
          //await firebaseTokenClient.removeToken(list[i], token);
        }
      }

      if (list.isEmpty) {
        emit(MainNoRegisteredContractState());
      } else {
        if(event.index < 0){
          log("Contract is null");
          emit(MainLoadedContractListState(contractDetailsList: list, index: 0));
        }else{
          log("Contract index is  ${event.index}");
          emit(MainLoadedContractListState(contractDetailsList: list, index: event.index));
        }
      }
    });

    on<MainAddContractEvent>((event, emit) async {
        log("MainAddContractEvent");
        emit(MainAddContractState(index: event.index));
    });

    on<MainResetPreferencesEvent>((event, emit) async {
      if (UniversalPlatform.isIOS && UniversalPlatform.isAndroid && UniversalPlatform.isIOS){
        String firebaseToken = await notificationService.getDeviceToken();
        lkPreferences.getContractDetails().forEach((contractDetail)  => firebaseTokenClient.removeToken(contractDetail, firebaseToken) );
      }
      log("MainResetPreferencesEvent");
      lkPreferences.resetPrefs();
      emit(MainNoRegisteredContractState());
    });

    on<MainChangePasswordEvent>((event, emit) async {
      log("MainChangePasswordEvent");
      emit(MainChangePasswordState(index: event.index));
    });
  }
}
