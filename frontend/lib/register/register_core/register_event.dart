import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUsernameChanged extends RegisterEvent {
  final String username;

  const RegisterUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class RegisterSubmitted extends RegisterEvent {
  final String fullName;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [fullName, email, password];
}


