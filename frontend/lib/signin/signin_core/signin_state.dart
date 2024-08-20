import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String userName;

  SignInSuccess({required this.userName});
}

class SignInFailure extends SignInState {
  final String error;

  const SignInFailure({required this.error});

  @override
  List<Object> get props => [error];
}


