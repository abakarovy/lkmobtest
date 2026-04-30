


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lkmobileapp/bloc/change_pwd_bloc.dart';
import 'package:lkmobileapp/bloc/main_bloc.dart';

class ChangePassword extends StatelessWidget {
  final int index;
  const ChangePassword({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = context.read<MainBloc>();
    final ChangePwdBloc changePwdBloc = context.read<ChangePwdBloc>();
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();

    return Center(child: BlocConsumer<ChangePwdBloc ,ChangePwdState>(
      listener: (context, state) {
        if (state is ChangePwdErrorState) {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Внимание!"),
              content: Text(state.error),
              actions: [
                TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("Ок"))
              ],
            );
          });
        } else if (state is ChangePwdWrongOldPwdState) {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Внимание!"),
              content: const Text("Старый пароль не верный"),
              actions: [
                TextButton(onPressed: () {Navigator.of(context).pop(); mainBloc.add(MainLoadRegisteredContractEvent(index: index)); changePwdBloc.add(ChangePwdRevertEvent());}, child: const Text("Ок"))
              ],
            );
          });
        } else if (state is ChangePwdDoneState) {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Успешно"),
              content: const Text("Смена пароля прошла успешно"),
              actions: [
                TextButton(onPressed: () {Navigator.of(context).pop(); mainBloc.add(MainLoadRegisteredContractEvent(index: index)); changePwdBloc.add(ChangePwdRevertEvent());}, child: const Text("Ок"))
              ],
            );
          });
        }
      },

      builder: (context, state) {
        if (state is ChangePwdErrorState) {
          return Column(
            children: [
              Text(state.msg),
              TextButton(onPressed: () {
                // Navigator.of(context).pushReplacement();
                mainBloc.add(MainLoadRegisteredContractEvent(index: index));
                changePwdBloc.add(ChangePwdRevertEvent());
              }, child: const Text("Ок")),
            ],
          );
        } else if (state is ChangePwdWrongOldPwdState) {
          return Column(
            children: [
              const Text("Старый пароль не верный"),
              TextButton(onPressed: () {
                // Navigator.of(context).pushReplacement();
                mainBloc.add(MainLoadRegisteredContractEvent(index: index));
                changePwdBloc.add(ChangePwdRevertEvent());
              }, child: const Text("Ок")),
            ],
          );
        } else if (state is ChangePwdLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is ChangePwdDoneState) {
          return Column(
            children: [
              const Text("Смена пароля прошла успешно"),
              TextButton(onPressed: () {
                // Navigator.of(context).pushReplacement();
                mainBloc.add(MainLoadRegisteredContractEvent(index: index));
                changePwdBloc.add(ChangePwdRevertEvent());
              }, child: const Text("Ок")),
            ],
          );
        } else if (state is ChangePwdInitialState) {
          return Scaffold(
            appBar: null,
            body: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(label: Text("Старый пароль")),
                  controller: oldPassword,
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("Новый пароль")),
                  controller: newPassword,
                ),
                TextButton(onPressed: () {
                  if (oldPassword.text.isNotEmpty && newPassword.text.isNotEmpty) {
                    // Response response = changePwdBloc.changePwd(state.contractDetailList[state.index].username, oldPwd, newPwd);
                    changePwdBloc.add(ChangePwdChangeEvent(index: index, oldPwd: oldPassword.text, newPwd: newPassword.text));
                  }
                }, child: const Text("Поменять пароль"))
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              child: TextButton(onPressed: () {
                // Navigator.of(context).pushReplacement();
                mainBloc.add(MainLoadRegisteredContractEvent(index: index));
              }, child: const Text("Отмена")),
            ),
          );
        } else {
          return const Text("Unknown state");
        }
      },
    ));
  }
}