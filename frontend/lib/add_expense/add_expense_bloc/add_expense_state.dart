import 'package:equatable/equatable.dart';
import 'package:frontend/models/user.dart';

abstract class AddExpenseState extends Equatable {
  const AddExpenseState();

  @override
  List<Object> get props => [];
}

class AddExpenseInitial extends AddExpenseState {}

class AddExpenseLoading extends AddExpenseState {}

class AddExpenseLoaded extends AddExpenseState {
  final List<User> groupMembers;

  const AddExpenseLoaded({required this.groupMembers});

  @override
  List<Object> get props => [groupMembers];
}

class AddExpenseSuccess extends AddExpenseState {
  final int expId;

  const AddExpenseSuccess({required this.expId});

  @override
  List<Object> get props => [expId];
}

class AddExpenseFailure extends AddExpenseState {
  final String error;

  const AddExpenseFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class CreateDebtsSuccess extends AddExpenseState {}

class CreateDebtsFailure extends AddExpenseState {
  final String error;

  const CreateDebtsFailure({required this.error});

  @override
  List<Object> get props => [error];
}

