import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/add_expense/add_expense_bloc/add_expense_event.dart';
import 'package:frontend/add_expense/add_expense_bloc/add_expense_state.dart';
import 'package:frontend/add_expense/add_expense_repo.dart';


class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final AddExpenseRepository repository;

  AddExpenseBloc({required this.repository}) : super(AddExpenseInitial()) {
    on<LoadGroupMembers>((event, emit) async {
      emit(AddExpenseLoading());
      try {
        final groupMembers = await repository.getGroupMembers(event.groupName);
        emit(AddExpenseLoaded(groupMembers: groupMembers));
      } catch (error) {
        emit(AddExpenseFailure(error: error.toString()));
      }
    });

    on<SubmitExpense>((event, emit) async {
      emit(AddExpenseLoading());
      try {
        final expId = await repository.addExpense(
          amount: event.expAmount,
          description: event.expDesc,
          category: event.expCategory,
          groupName: event.groupName,
        );
        emit(AddExpenseSuccess(expId: expId));
      } catch (error) {
        emit(AddExpenseFailure(error: error.toString()));
      }
    });

    on<CreateDebts>((event, emit) async {
      try {
        await repository.createDebts(
          expId: event.expID,
          participants: event.participants,
          expAmount: event.expAmount,
        );
        emit(CreateDebtsSuccess());
      } catch (error) {
        emit(CreateDebtsFailure(error: error.toString()));
      }
    });
  }
}

