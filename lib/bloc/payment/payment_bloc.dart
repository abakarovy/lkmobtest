import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lkmobileapp/entity/contract.dart';
import 'package:lkmobileapp/output/payment_client.dart';

part 'payment_event.dart';

part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentClient paymentClient;
  PaymentBloc({required this.paymentClient}) : super(PaymentInitial()) {
    on<PaymentEvent>((event, emit) async {});
    on<PaymentLoadEvent>((event, emit) async {
      emit(PaymentLoadingUrlState());
      String url =
          await paymentClient.getPaymentUrl(event.contract, event.sum );
      emit(PaymentLoadedUrlState(url: url, contract: event.contract));
    });

    on<PaymentStartEvent>((event, emit) async {
      debugPrint("PaymentStartEvent ");
      emit(PaymentContractDefinedState(contract: event.contract));
    });
  }
}
