import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lkmobileapp/bloc/payment/payments_list_bloc.dart';
import 'package:lkmobileapp/entity/contract.dart';
import 'package:lkmobileapp/entity/payment.dart';


class PaymentsList extends StatefulWidget {
  final Contract contract;

  const PaymentsList({super.key, required this.contract});


  @override
  State<StatefulWidget> createState() => PaymentWidgetState(contract: contract);
}

class PaymentWidgetState extends State<StatefulWidget> {
  final Contract contract;
  int selectedValue = 2;
  DateTime dateFrom = DateTime.now().subtract(const Duration(days: 30));
  DateTime dateTo = DateTime.now();


  PaymentWidgetState({required this.contract});


  @override
  Widget build(BuildContext context) {
    dateFrom = DateTime.now().subtract(const Duration(days: 30));
    dateTo = DateTime.now();
    final PaymentsListBloc paymentsListBloc = context.read<PaymentsListBloc>();
    paymentsListBloc.add(PaymentsListLoadListEvent(
        contract: contract, dateFrom: dateFrom, dateTo: dateTo));
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PaymentsListBloc, PaymentsListState>(
        builder: (context, state) {
          if (state is PaymentsListInitial) {
            paymentsListBloc.add(PaymentsListLoadListEvent(
                contract: contract, dateFrom: dateFrom, dateTo: dateTo));
            return const CircularProgressIndicator();
          } else if (state is PaymentsLoading) {
            return const CircularProgressIndicator();
          } else if (state is PaymentsLoaded) {
            var paymentsList = state.payments;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: DropdownButton(
                    value: selectedValue,
                    items: dropdownItems,
                    onChanged: (int? newValue) {
                      selectedValue = newValue!;
                      switch (selectedValue){
                        case 0:
                          dateFrom = DateTime.now().subtract(const Duration(days: 3650));
                          dateTo = DateTime.now();
                          break;
                        case 1:
                          dateFrom = DateTime.now().subtract(const Duration(days: 365));
                          dateTo = DateTime.now();
                          break;
                        case 2:
                          dateFrom = DateTime.now().subtract(const Duration(days: 30));
                          dateTo = DateTime.now();
                          break;
                        default: {

                        }
                      }
                      paymentsListBloc.add(PaymentsListLoadListEvent(contract: contract, dateFrom: dateFrom, dateTo: dateTo));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextButton(
                    onPressed: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now())
                              .then((value) {
                                setState(() {
                                  if (value != null) {
                                    dateFrom = value;
                                  }
                                });
                              });
                          },
                    child: Text('Начало периода: $dateFrom') ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextButton(
                    onPressed: () {
                      showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now())
                          .then((value) {
                        setState(() {
                          if (value != null) {
                            dateTo = value;
                          }
                        });
                      });
                    },
                    child: Text('Конец периода: $dateTo') ,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                      itemCount: paymentsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                              leading: CircleAvatar(
                                  child: getImageAssetByPaymentType(
                                      paymentsList[index].typeId)
                              ),
                              title: Text(paymentsList[index].sum.toString()),
                              subtitle: Text(
                                DateFormat('yyyy-MM-dd').format(paymentsList[index].date),
                                selectionColor: Colors.white,
                              ),
                              textColor: Colors.black),
                        );
                      },
                    ))
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
        listener: (BuildContext context, PaymentsListState state) {
          if (state is PaymentsLoadingFailedState){
            //todo: реализовать вывод ошибки.
            // через 3 секунды повтор.
          }
        },
      ),
    );
  }

  List<Payment> listFilter(List<Payment> srcPaymentList, int mode) {
    return srcPaymentList;
    /*List<Payment> dstPaymentList = List.empty(growable: true);
    for (int i = 0; i < srcPaymentList.length; i++) {
      var translatedDate = translateDateFormat(srcPaymentList[i].date);

      if (mode == 1
          ? (translatedDate.month == DateTime.now().month &&
              translatedDate.year == DateTime.now().year)
          : (translatedDate.year == DateTime.now().year)) {
        dstPaymentList
            .add(srcPaymentList[i]);
      } else if (mode == 0) {
        dstPaymentList = srcPaymentList;
      }
    }
    return dstPaymentList;*/
  }

  Image getImageAssetByPaymentType(int paymentTypeId) {
    switch (paymentTypeId) {
      case 0 :
        return Image.asset("assets/images/sberbank.png");
      case 5 :
        return Image.asset("assets/images/sberbank.png");
      default :
        return Image.asset("assets/images/sberbank.png");
    }
  }

  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      const DropdownMenuItem(value: 0, child: Text("За все время")),
      const DropdownMenuItem(value: 1, child: Text("За год")),
      const DropdownMenuItem(value: 2, child: Text("За месяц")),
    ];
    return menuItems;
  }

}

DateTime translateDateFormat(String date) {
  date = date.replaceAll(".", "");
  List<String> dates = date.split("");
  String day = dates[0] + dates[1];
  String mouth = dates[2] + dates[3];
  String year = dates[4] + dates[5] + dates[6] + dates[7];
  return DateTime(int.parse(year), int.parse(mouth), int.parse(day), 0);
}
