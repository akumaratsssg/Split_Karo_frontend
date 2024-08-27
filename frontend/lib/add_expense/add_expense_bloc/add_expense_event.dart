import 'package:equatable/equatable.dart';
import 'package:frontend/models/user.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadGroupMembers extends AddExpenseEvent {
  final String groupName;

  const LoadGroupMembers({required this.groupName});

  @override
  List<Object> get props => [groupName];
}

class SubmitExpense extends AddExpenseEvent {
  final String groupName;
  final double expAmount;
  final String expDesc;
  final String expCategory;
  final List<String> participants;

  const SubmitExpense({
    required this.groupName,
    required this.expAmount,
    required this.expDesc,
    required this.expCategory,
    required this.participants,
  });

  @override
  List<Object> get props => [groupName, expAmount, expDesc, expCategory, participants];
}

class CreateDebts extends AddExpenseEvent {
  final int expID;
  final List<String> participants;
  final double expAmount;

  const CreateDebts({
    required this.expID,
    required this.participants,
    required this.expAmount,
  });

  @override
  List<Object> get props => [expID, participants, expAmount];
}
