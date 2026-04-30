part of 'payments_list_bloc.dart';

abstract class PaymentsListEvent {}

class PaymentsListLoadListEvent extends PaymentsListEvent {
  final Contract contract;
  final DateTime dateFrom;
  final DateTime dateTo;
  PaymentsListLoadListEvent({required this.contract, required this.dateFrom, required this.dateTo});
}

class PaymentsListReloadEvent extends PaymentsListEvent {
  final List<Payment> payments;
  PaymentsListReloadEvent({required this.payments});
}
