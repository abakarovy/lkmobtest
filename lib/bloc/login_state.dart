part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {

}

class LoginSavingState extends LoginState {
  LoginSavingState();
}

class LoginDoneState extends LoginState {
  final int index;
  LoginDoneState({required this.index});
}

class LoginWrongDataState extends LoginState {
  final String message;
  LoginWrongDataState({required this.message});
}



