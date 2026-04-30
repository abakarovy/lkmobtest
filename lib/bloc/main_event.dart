part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class MainBlockInitEvent extends MainEvent {}

class MainLoadRegisteredContractEvent extends MainEvent {
  final int index;
  MainLoadRegisteredContractEvent({required this.index});
}

class MainAddContractEvent extends MainEvent {
  final int index;
  MainAddContractEvent({required this.index});
}

class MainResetPreferencesEvent extends MainEvent {

}

class MainChangePasswordEvent extends MainEvent {
  final int index;
  MainChangePasswordEvent({required this.index});
}
