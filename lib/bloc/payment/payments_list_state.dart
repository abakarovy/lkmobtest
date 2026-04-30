part of 'payments_list_bloc.dart';

@immutable
abstract class PaymentsListState {}

class PaymentsListInitial extends PaymentsListState {}

class PaymentsLoading extends PaymentsListState {}

class PaymentsLoaded extends PaymentsListState {
  final List<Payment> payments;
  PaymentsLoaded({required this.payments});
}

class PaymentsReloaded extends PaymentsListState {}

class PaymentsLoadingFailedState extends PaymentsListState {
  final String message;
  PaymentsLoadingFailedState({required this.message});
}
