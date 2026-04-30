import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lkmobileapp/data/c2bmembers_data.dart';
import 'package:lkmobileapp/lk_preferences.dart';
import 'package:lkmobileapp/models/c2bmembers_model.dart';
import 'package:lkmobileapp/sbp.dart';
import 'package:lkmobileapp/widget/sbp_modal_bottom_sheet_widget.dart';
import 'package:universal_platform/universal_platform.dart';
import '../bloc/payment/payment_bloc.dart';
import 'package:lkmobileapp/mobile_lib.dart' if (dart.library.html) 'package:lkmobileapp/web_lib.dart';

class Payments extends StatelessWidget {
  Payments({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentBloc payBloc = context.read<PaymentBloc>();
    final textController = TextEditingController();
    return Material(
      child: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child:
            BlocConsumer<PaymentBloc, PaymentState>(listener: (context, state) {
          if (state is PaymentLoadedUrlState) {
            if (UniversalPlatform.isWeb){
              webWidget(Uri.parse(state.url));
              payBloc.add(PaymentStartEvent(contract: state.contract));
            }else if (UniversalPlatform.isMobile) {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (ctx) =>
                      SbpModalBottomSheetWidget(LkPreferences.installedBanks, state.url));
            } else{
              //todo:
            }
          }
        }, builder: (context, state) {
          log(state.toString());
          if (state is PaymentContractDefinedState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Введите сумму платежа',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        try {
                          payBloc.add(PaymentLoadEvent(
                              contract: state.contract,
                              sum: int.parse(textController.text)));
                        } catch(e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: const Text('Перейти к оплате'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is PaymentLoadingUrlState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('Unknown state $state '));
          }
        }),
      ),
    );
  }

}

//payment
