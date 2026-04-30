import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lkmobileapp/entity/change_password.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/authorization_client.dart';

part 'change_pwd_state.dart';

part 'change_pwd_event.dart';

class ChangePwdBloc extends Bloc<ChangePwdEvent, ChangePwdState> {
  final Authorization authorization;
  final LkPreferences lkPreferences;

  ChangePwdBloc({required this.authorization, required this.lkPreferences})
      : super(ChangePwdInitialState()) {
    on<ChangePwdEvent>((event, emit) {});

    on<ChangePwdRevertEvent>((event, emit) async {
      emit(ChangePwdInitialState());
    });

    on<ChangePwdChangeEvent>((event, emit) async {
      emit(ChangePwdLoadingState());
      try {
        var response = await authorization.changePassword(
        ChangePasswordRequest(
            login: lkPreferences
                .getContractDetails()[event.index]
                .contract
                .title,
            oldPwd: event.oldPwd,
            newPwd: event.newPwd));
        // if (response.statusCode == 200) {
        //   lkPreferences.changeContractPassword(event.index, event.newPwd);
        //   debugPrint(lkPreferences.getContractDetails()[event.index].password);
        // } else if (response.statusCode == 400) {
        //   emit(ChangePwdWrongOldPwdState());
        // } else if (response.statusCode == 500) {
        //   emit(ChangePwdErrorState(
        //       msg: "Что-то пошло не так, повторите запрос позже"));
        // } else {
        //   emit(ChangePwdErrorState(msg: "Неизвестное состояние"));
        // }
        // inspect(response);
        if (!response.containsKey("error")) {
          lkPreferences.changeContractPassword(event.index, event.newPwd);
          emit(ChangePwdDoneState(index: event.index));
        } else {
          debugPrint("tru");
          emit(ChangePwdErrorState(error: response["error"], msg: ""));
        }
      } on Exception catch (e) {
        emit(ChangePwdErrorState(error: "Неизвестная ошибка", msg: e.toString()));
      }
    });
  }
}
