part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

// Событие загрузки контракта. Срабатывает когда пользователь меняет контракт
class HomeLoadContractEvent extends HomeEvent {
  final int index;
  final List<ContractDetails>? contractDetailList;
  HomeLoadContractEvent({required this.index, required this.contractDetailList});
}

class HomeChangeContractEvent extends HomeEvent {
  // Событие смены текущего контракта в Личном Кабинете
  final int index;
  final List<ContractDetails> contractDetailList;
  HomeChangeContractEvent({required this.index, required this.contractDetailList});
}

class HomeSuspendContractEvent extends HomeEvent {
  final int index;
  final List<ContractDetails> contractDetailList;
  HomeSuspendContractEvent(
      {required this.index, required this.contractDetailList});
}

class HomeInitEvent extends HomeEvent{

}
