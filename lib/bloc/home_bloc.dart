
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lkmobileapp/entity/contract_details.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/output/authorization_client.dart';
import 'package:lkmobileapp/output/contract_status_client.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Authorization authorization;
  final ContractStatusClient contractStatusClient;
  final LkPreferences lkPreferences;

  HomeBloc({
    required this.authorization,
    required this.contractStatusClient,
    required this.lkPreferences,
  }) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
    });

    on<HomeInitEvent>((event, emit) async {
      emit(HomeInitial());
    },);

    // Событие срабатывает когда стартует приложение и происходит первая загрузка списка
    // сохраненных контрактов.
    on<HomeLoadContractEvent>(ttt);

    //Обработчик события изменения контракта
    on<HomeChangeContractEvent>(ttt);

    // Обработчик события приостановки контракта
    on<HomeSuspendContractEvent>((event, emit) async {
      /*if (ContractStatus().canChangeStatus()) {
        Fluttertoast.showToast(
            msg:
                "Вы не можете так часто менять статус контракта!\n попробуйте завтра",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }*/
      //emit(HomeLoadingContractState());
      int currentContractState =
          event.contractDetailList[event.index].contract.status;
      debugPrint("current status before $currentContractState");
      var contractStatusEntity = await contractStatusClient.suspendContract(
          event.contractDetailList[event.index].contract,
          currentContractState == 0 ? 4 : 0);
      if (contractStatusEntity.status < 0){
        debugPrint(contractStatusEntity.message);
        // todo: Тут надо как то сообщить об ошибке
      }else{
        event.contractDetailList[event.index].contract.status = contractStatusEntity.status;
        bool state = contractStatusEntity.status == 0;
        emit(HomeLoadedState(
            contractState: state,
            index: event.index,
            contractDetailList: event.contractDetailList));
      }
    });
  }

  ttt(event, emit) async {
    debugPrint("Bloc change contractList list: $event");
    var contractDetailsList = lkPreferences.getContractDetails();
    if (event.index < 0) {
      // сообщаем виджету что это первая загрузка
      emit(HomeFirstLoadingContractState());
      contractDetailsList = lkPreferences.getContractDetails();
      for (var i = 0; i < contractDetailsList.length; i++) {
        // подгружаем дополнительные данные с сервера
        debugPrint("вызов логина в ttt");
        contractDetailsList[i] = await authorization.login(contractDetailsList[i].username,
            contractDetailsList[i].password);
        lkPreferences.updateContract(contractDetailsList[i], i);
      }
    } else {
      // сообщаем виджеты что это вторая и последующая загрузка данных
      emit(HomeLoadingContractState(
          contractDetailList: event.contractDetailList, index: event.index));
      var c = await authorization.login(
          event.contractDetailList[event.index].username,
          event.contractDetailList[event.index].password);
      lkPreferences.updateContract(c, event.index);
    }
    bool state = (event.contractDetailList[event.index].contract.status == 0);
    emit(HomeLoadedState(
        contractState: state,
        index: event.index,
        contractDetailList: contractDetailsList));
  }
}
