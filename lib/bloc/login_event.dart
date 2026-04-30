part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginSaveEvent extends LoginEvent {
  final String title;
  final String password;
  LoginSaveEvent({required this.title, required this.password});
}

class LoginFinishedEvent extends LoginEvent {

}