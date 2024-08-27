import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/add_expense/add_expense_bloc/add_expense_bloc.dart';
import 'package:frontend/add_expense/add_expense_bloc/add_expense_event.dart';
import 'package:frontend/add_expense/add_expense_bloc/add_expense_state.dart';
import 'add_expense_repo.dart';
import 'package:frontend/models/user.dart';

class AddExpensePage extends StatelessWidget {
  final String groupName;

  const AddExpensePage({required this.groupName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddExpenseBloc(
        repository: AddExpenseRepository(),
      )..add(LoadGroupMembers(groupName: groupName)),
      child: AddExpenseView(groupName: groupName),
    );
  }
}

class AddExpenseView extends StatefulWidget {
  final String groupName;

  const AddExpenseView({required this.groupName});

  @override
  _AddExpenseViewState createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Food';
  List<User> _selectedParticipants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF708090),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Enter expense details", style: TextStyle(color: Colors.black)),
        actions: [
          BlocBuilder<AddExpenseBloc, AddExpenseState>(
            builder: (context, state) {
              if (state is AddExpenseLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return IconButton(
                icon: const Icon(Icons.done),
                onPressed: () async {
                  final expAmount = double.tryParse(_amountController.text);
                  if (expAmount != null) {
                    context.read<AddExpenseBloc>().add(SubmitExpense(
                      groupName: widget.groupName,
                      expAmount: expAmount,
                      expDesc: _descriptionController.text,
                      expCategory: _selectedCategory,
                      participants: _selectedParticipants.map((user) => user.userName).toList(),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid amount')),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocListener<AddExpenseBloc, AddExpenseState>(
        listener: (context, state) async {
          if (state is AddExpenseSuccess) {
            final expID = state.expId;

            // Create debts for the added expense
            context.read<AddExpenseBloc>().add(CreateDebts(
              expID: expID,
              participants: _selectedParticipants.map((user) => user.userName).toList(),
              expAmount: double.parse(_amountController.text),
            ));

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Expense added successfully!')),
            );
          } else if (state is AddExpenseFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add expense: ${state.error}')),
            );
          } else if (state is CreateDebtsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create debts: ${state.error}')),
            );
          }
        },
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Expense Amount',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Expense Description',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Food', 'Rent', 'Bill', 'Fare', 'Others']
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: const TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                onPressed: () async {
                  final result = await showDialog<List<User>>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return ParticipantsDialog(
                        groupName: widget.groupName,
                        bloc: BlocProvider.of<AddExpenseBloc>(context),
                      );
                    },
                  );
                  if (result != null) {
                    setState(() {
                      _selectedParticipants = result;
                    });
                  }
                },
                child: const Text('Add Participants to Expense', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParticipantsDialog extends StatefulWidget {
  final String groupName;
  final AddExpenseBloc bloc;

  const ParticipantsDialog({
    required this.groupName,
    required this.bloc,
  });

  @override
  _ParticipantsDialogState createState() => _ParticipantsDialogState();
}

class _ParticipantsDialogState extends State<ParticipantsDialog> {
  List<User> _selectedParticipants = [];

  @override
  Widget build(BuildContext context) {
    // final bloc = BlocProvider.of<AddExpenseBloc>(widget.contextWithBloc);

    return BlocProvider.value(
      value: widget.bloc,
      child: SimpleDialog(
        title: const Text('Select Participants', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        children: [
          BlocBuilder<AddExpenseBloc, AddExpenseState>(
            builder: (context, state) {
              if (state is AddExpenseLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AddExpenseLoaded) {
                return Column(
                  children: state.groupMembers.map((user) {
                    return CheckboxListTile(
                      title: Text(user.userName, style: const TextStyle(color: Colors.white)),
                      value: _selectedParticipants.contains(user),
                      onChanged: (selected) {
                        setState(() {
                          if (selected!) {
                            _selectedParticipants.add(user);
                          } else {
                            _selectedParticipants.remove(user);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              } else {
                return const Text('Failed to load participants', style: TextStyle(color: Colors.white));
              }
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
            onPressed: () {
              Navigator.pop(context, _selectedParticipants);
            },
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
