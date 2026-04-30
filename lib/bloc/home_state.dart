part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}


// Виджет находится в состоянии загрузки данных с сервера или с преференса
class HomeLoadingContractState extends HomeState {
  // Класс состояния "идет процесс загрузки контракта"
  final int index;
  final List<ContractDetails> contractDetailList;
  HomeLoadingContractState({ required this.index, required this.contractDetailList});
}

class HomeFirstLoadingContractState extends HomeState {
  // Класс состояния "идет процесс загрузки контракта"

}

// class HomeLoadedContractState extends HomeState {
//   // Класс состояния "Процесс загрузки контракта завершен"
//   final List<Contract> contractList;
//   final Contract currentContract;
//
//   HomeLoadedContractState({
//     required this.contractList,
//     required this.currentContract,
//   });
// }

class HomeContractListEmptyState extends HomeState {
  // Состояние виджета когда контракт лист пустой. Это ошибочное состояние в него никогда не должны попадать.
}
//class HomeLoadingState extends HomeState {}

// Состояние когда все данные загрузились
class HomeLoadedState extends HomeState {
  final int index;
  final List<ContractDetails> contractDetailList;
  final bool contractState;
  HomeLoadedState(
      {
        required this.contractState,
        required this.index,
        required this.contractDetailList});
}

// Состояние когда контракт изменился
/*class HomeChangeContractState extends HomeState {
  int index;
  HomeChangeContractState(
      {required this.index});
}*/