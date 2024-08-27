import 'package:equatable/equatable.dart';
import 'package:frontend/models/user_balance.dart';

abstract class BalancesState extends Equatable {
  const BalancesState();

  @override
  List<Object> get props => [];
}

class BalancesInitial extends BalancesState {}

class BalancesLoading extends BalancesState {}

class BalancesLoaded extends BalancesState {
  final List<UserBalance> balances;

  BalancesLoaded({required this.balances});

  @override
  List<Object> get props => [balances];
}

class BalancesError extends BalancesState {
  final String message;

  BalancesError({required this.message});

  @override
  List<Object> get props => [message];
}
