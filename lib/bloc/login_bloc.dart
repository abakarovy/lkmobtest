
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lkmobileapp/entity/contract_details.dart';
import 'package:lkmobileapp/output/authorization_client.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'dart:developer' as dev;

part 'login_event.dart';
part 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Authorization authorization;
  final LkPreferences lkPreferences;
  LoginBloc({required this.authorization,
  required this.lkPreferences}) : super(LoginInitialState()) {
    on<LoginEvent>((event, emit) {});


    on<LoginSaveEvent>((event, emit) async {
      emit(LoginSavingState());
      //var myPrefs = await LkPreferences.getInstance();
      List<ContractDetails> titles = lkPreferences.getContractDetails();
      titles.removeWhere((element) => event.title == element.username);
      try {

        debugPrint("вызов логина в LoginBloc при добавлении нового аккаунта");
        ContractDetails contractDetail = await authorization.login(event.title, event.password);
        if (contractDetail.contract.title == "") {
          //проверка на не правильные данные(возвращает пустой контракт)
          emit(LoginWrongDataState(message: 'contractDetail.contract.id == "" || contractDetail.contract.title == ""'));
        } else {
          emit(LoginDoneState(index: lkPreferences.addContract(contractDetail)));
        }
      } on Exception catch (e){
        dev.log(e.toString());
        //todo: Вывод ошибки авторизации
        emit(LoginWrongDataState(message: e.toString()));
      }
    });

    on<LoginFinishedEvent>((event, emit) async {
      debugPrint("Setup LoginInitialState");
      emit(LoginInitialState());
    });
  }
}
