part of 'change_pwd_bloc.dart';

@immutable 
abstract class ChangePwdEvent {}

class ChangePwdRevertEvent extends ChangePwdEvent {}

class ChangePwdChangeEvent extends ChangePwdEvent {
  final int index;
  final String oldPwd;
  final String newPwd;
  ChangePwdChangeEvent({required this.index, required this.oldPwd, required this.newPwd});
}

class ChangePwdFinishedEvent extends ChangePwdEvent {}