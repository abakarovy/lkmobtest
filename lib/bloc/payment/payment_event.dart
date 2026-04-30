part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class PaymentStartEvent extends PaymentEvent {
  final Contract contract;
  PaymentStartEvent({required this.contract});
}

class PaymentLoadEvent extends PaymentEvent {
  final Contract contract;
  final int sum;
  PaymentLoadEvent({required this.contract, required this.sum});
}
