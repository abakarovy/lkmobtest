import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lkmobileapp/bloc/home_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:lkmobileapp/entity/contract_details.dart';
import 'package:lkmobileapp/entity/tariff_plan.dart';
import 'package:lkmobileapp/widget/payments_list.dart';

class HomeWidget extends StatelessWidget {
  final PageController pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  /*void closeDrawer() {
    Navigator.of(context).pop(); // Close the drawer
  }*/

  final TextStyle textStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  final SizedBox betweenButton = const SizedBox(
    height: 10,
  );

  final ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      shape: const StadiumBorder());

  final double borderRadius = 15;

  HomeWidget({super.key, required this.pageController});

  //static const String _title = 'Главная';

  //String? selectedValue;
  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = context.read<HomeBloc>();

    //final PaymentBloc paymentBloc = context.read<PaymentBloc>();
    return Stack(
      children: [
        Positioned(
          left: 20,
          right: 20,
          top: 43,
          //bottom: 250,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: const Color.fromARGB(255, 112, 128, 144),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: const Color.fromARGB(255, 112, 128, 144),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      log(state.toString());
                      if (state is HomeInitial) {
                        //homeBloc.add(HomeLoadContractEvent(
                        //   contractDetail: null, contractDetailList: null));
                        // отправились выполнять асинхронный запрос в преференс
                        return const CircularProgressIndicator();
                      } else if (state is HomeLoadingContractState ||
                          state is HomeFirstLoadingContractState) {
                        // в процессе ожидания загрузки данных
                        return const CircularProgressIndicator();
                      } else if (
                          //state is HomeChangeContractState ||
                          state is HomeLoadedState) {
                        log(state.contractDetailList[state.index].fullName);
                        return Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 40,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                state.contractDetailList[state.index].fullName,
                                style: textStyle,
                              ),
                            ),
                            betweenButton,
                            // только здесь нужен row потому что только
                            // здесь в одну строку две кнопки расположено
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    //todo: здесь надо выыводить баланс а не входящее сальдо
                                    '${state.contractDetailList[state.index].contractBalance.getMoney().toStringAsFixed(2).replaceAll('.', ',')} ₽',
                                    textScaler: const TextScaler.linear(1.6),
                                    style: textStyle,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  heightFactor: 1,
                                  child: Container(
                                    //width: 170,
                                    height: 40,
                                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: IconButton(
                                      onPressed: () {
                                        pageController.jumpToPage(1);
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            betweenButton,
                            Row(children: [
                              Expanded(
                                child: TextButton.icon(
                                  icon: (state.contractState)
                                      ? const Icon(Icons.pause_circle_outline,
                                          size: 18)
                                      : const Icon(Icons.play_circle_outline,
                                          size: 18),
                                  onPressed: () => {
                                    homeBloc.add(HomeSuspendContractEvent(
                                        index: state.index,
                                        contractDetailList:
                                            state.contractDetailList))
                                  },
                                  label: (state.contractState)
                                      ? const Text("Приостановить")
                                      : const Text(" Продолжить  "),
                                  style: buttonStyle,
                                ),
                              ),
                            ]),
                            betweenButton,
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    icon: const Icon(
                                      Icons.history,
                                      size: 18,
                                    ),
                                    onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PaymentsList(
                                                  contract: state
                                                      .contractDetailList[
                                                          state.index]
                                                      .contract,
                                                )),
                                      )
                                    },
                                    label: const Text("История платежей"),
                                    style: buttonStyle,
                                  ),
                                ),
                              ],
                            ),
                            betweenButton,
                            getTariffWidgets(state
                                .contractDetailList[state.index].tariffPlans),
                          ],
                        );
                      } else {
                        return Text("Unknown home card state $state");
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 112, 128, 144),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) {
                log('Предыдущее: $previous');
                log('Текущее $current');
                return true;
              }, builder: (context, state) {
                log("Called");

                if (state is HomeFirstLoadingContractState) {
                  return const CircularProgressIndicator();
                } else if (state is HomeLoadedState) {
                  return getComboBox(
                      state.contractDetailList, state.index, homeBloc);
                } else if (state is HomeLoadingContractState) {
                  return getComboBox(
                      state.contractDetailList, state.index, homeBloc);
                } else if (state is HomeInitial) {
                  return const CircularProgressIndicator();
                } else {
                  return Text("Unknown home state $state");
                }
              }),
            )
          ],
        ),
      ],
    );
  }

  Widget getComboBox(
      List<ContractDetails> contractDetailList, int index, HomeBloc homeBloc) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<ContractDetails>(
        alignment: Alignment.center,
        items: contractDetailList
            .map((item) => DropdownMenuItem<ContractDetails>(
                  value: item,
                  child: Text(
                    textAlign: TextAlign.center,
                    item.contract.title,
                    style: textStyle,
                  ),
                ))
            .toList(),
        value: contractDetailList[index],
        onChanged: (value) {
          {
            log("Contract change: ${(value as ContractDetails).contract.id}");
            log('Contract changed value = ${value.contract.title}');
            homeBloc.add(HomeLoadContractEvent(
                index: contractDetailList.indexOf(value),
                contractDetailList: contractDetailList));
          }
        },

        //todo: после обновления эти 3 параметра кнопки пропали. Почему?
        //buttonHeight: 40,
        //buttonWidth: 140,
        //itemHeight: 40,
      ),
    );
  }

  Widget getTariffWidgets(List<TariffPlan> tariffs) {
    return Column(
        children: List.generate(tariffs.length, (index) {
      //return Container(color: Colors.deepOrangeAccent, height: 40,);
      return Row(children: [
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.account_tree, size: 18),
            onPressed: () => {},
            label: Text(tariffs[index].titleWeb),
            style: buttonStyle,
          ),
        ),
      ]);
    }));
  }
}
