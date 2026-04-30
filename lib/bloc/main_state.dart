part of 'main_bloc.dart';

@immutable
abstract class MainState {
}

class MainInitial extends MainState {}

class MainLoadingContractState extends MainState {}

class MainLoadingContractPaymentState extends MainEvent {}

class MainLoadedContractState extends MainState {
  final ContractDetails contractDetails;
  MainLoadedContractState({required this.contractDetails});
}

class MainLoadedContractPayment extends MainState {}

class MainNoRegisteredContractState extends MainState {
  MainNoRegisteredContractState();
}
class  MainAddContractState extends MainState{
  final int index;
  MainAddContractState({required this.index});
}

class MainLoadedContractListState extends MainState {
  final List<ContractDetails> contractDetailsList;
  final int index;
  MainLoadedContractListState({required this.contractDetailsList, required this.index});
}

class MainChangePasswordState extends MainState {
  final int index;
  MainChangePasswordState({required this.index});
}


