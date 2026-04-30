import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lkmobileapp/entity/contract.dart';
import 'package:lkmobileapp/entity/payment.dart';
import 'package:lkmobileapp/output/payment_client.dart';
import 'package:lkmobileapp/output/rest_client.dart';

part 'payments_list_event.dart';
part 'payments_list_state.dart';

class PaymentsListBloc extends Bloc<PaymentsListEvent, PaymentsListState> {
  final PaymentClient paymentClient;
  PaymentsListBloc({required this.paymentClient}) : super(PaymentsListInitial()) {
    on<PaymentsListEvent>((event, emit) async {});
    on<PaymentsListLoadListEvent>((event, emit) async {
      emit(PaymentsLoading());
      try {
        List<Payment> payments = await paymentClient.getPaymentList(event.contract, event.dateFrom, event.dateTo);
        emit(PaymentsLoaded(
            payments: payments));
      } on BGConnectException catch (e) {
        emit(PaymentsLoadingFailedState(message: e.message));
      } on HttpClientNotFoundException catch (e) {
        emit(PaymentsLoadingFailedState(message: e.message));
      }
    });

    on<PaymentsListReloadEvent>((event, emit) async {
      emit(PaymentsLoading());
      emit(PaymentsLoaded(payments: event.payments));
    });
  }
}
