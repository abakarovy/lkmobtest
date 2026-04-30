part of 'payment_bloc.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {

}

class PaymentContractDefinedState extends PaymentState {
  final Contract contract;
  PaymentContractDefinedState({required  this.contract});
}

// Состояние процесс загрузки URL заказа идет
class PaymentLoadingUrlState extends PaymentState {}


// Состояние процесс загрузки URL заказа завершен
class PaymentLoadedUrlState extends PaymentContractDefinedState {
  final String url;
  final Contract contract;
  PaymentLoadedUrlState({required this.url, required this.contract}) : super(contract: contract);
}
