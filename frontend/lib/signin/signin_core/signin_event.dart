import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInEmailChanged extends SignInEvent {
  final String email;

  const SignInEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SignInPasswordChanged extends SignInEvent {
  final String password;

  const SignInPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;

  const SignInSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}


