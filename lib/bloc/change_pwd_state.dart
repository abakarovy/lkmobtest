part of 'change_pwd_bloc.dart';

@immutable
abstract class ChangePwdState {}

class ChangePwdInitialState extends ChangePwdState {
}

class ChangePwdLoadingState extends ChangePwdState {}

class ChangePwdDoneState extends ChangePwdState {
  final int index;
  ChangePwdDoneState({required this.index});
}

class ChangePwdErrorState extends ChangePwdState {
  final String error;
  final String msg;
  ChangePwdErrorState({required this.error, required this.msg});
}

class ChangePwdWrongOldPwdState extends ChangePwdState {}