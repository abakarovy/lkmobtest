import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lkmobileapp/bloc/main_bloc.dart';
import 'package:lkmobileapp/bloc/login_bloc.dart';


class LoginDemo extends StatelessWidget {
  final int index;
  const LoginDemo({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = context.read<LoginBloc>();
    final MainBloc mainBloc = context.read<MainBloc>();
    TextEditingController titleController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginWrongDataState){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Внимание!'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Закрываем диалог при нажатии на кнопку "ОК".
                        Navigator.of(context).pop();
                      },
                      child: const Text('ОК'),
                    ),
                  ],
                );
              });
        }
      },
      builder: (context, state) {
        debugPrint(state.toString());
        if (state is LoginWrongDataState) {
          //todo: "Данные введены не верно, либо вы уже авторизованы под этим пользователем!"
        } else if (state is LoginDoneState) {
          // даем команду в видже загрузить информацию по контракту
          mainBloc.add(MainLoadRegisteredContractEvent(
              index: state.index));
          // сообщаем что завершили авторизацию.
          loginBloc.add(LoginFinishedEvent());
        }
        return Scaffold(
          appBar: null,
          backgroundColor: ThemeData.light().scaffoldBackgroundColor,
          body: Column(
            //scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset("assets/images/Fly-tech Logo_V.png"),
                    //Image.asset('asset/images/flutter-logo.png'),
                  ),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Договор',
                      hintText: 'Введите номер договора'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Пароль',
                      hintText: 'Введите ваш пароль'),
                ),
              ),
              getButton(index, mainBloc),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    if (titleController.text == "" ||
                        passwordController.text == "") {
                      /*Fluttertoast.showToast(
                          msg: "Все поля должны быть заполнены",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);*/
                    } else {
                      //Посылаем сигнал пройти авторизацию
                      loginBloc.add(LoginSaveEvent(
                          title: titleController.text.trim(),
                          password: passwordController.text));
                    }
                  },
                  child: state is LoginSavingState
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Войти',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                ),
              ),
              const SizedBox(
                height: 130,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getButton(int index, MainBloc mainBloc) {
    if (index < 0){
      return TextButton(
        onPressed: () {
          //mainBloc.add(MainLoadRegisteredContractEvent( contract: state.contract));
        },
        child: const Text(
          'Стать нашим клиентом',
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      );
    }else {
      return TextButton(
        onPressed: () {
          mainBloc.add(MainLoadRegisteredContractEvent( index : index));
        },
        child: const Text(
          'Отмена',
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      );
    }
  }
}
