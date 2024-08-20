import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_group_bloc/create_group_bloc.dart';
import 'create_group_bloc/create_group_event.dart';
import 'create_group_bloc/create_group_state.dart';
import 'create_group_repo.dart';

class CreateGroupPage extends StatelessWidget {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Match SignInPage background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create group'),
        backgroundColor: Color(0xFF708090), // Slate gray color to match SignInPage
        actions: [
          IconButton(
            icon: const Text('Done'),
            onPressed: () {
              final groupName = _groupNameController.text;
              final groupDescription = _groupDescriptionController.text;

              // Dispatch the event to CreateGroupBloc
              context.read<CreateGroupBloc>().add(
                CreateGroupSubmitted(groupName, groupDescription),
              );
            },
            color: Colors.white, // Match SignInPage button text color
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                labelText: 'Group name',
                labelStyle: TextStyle(color: Colors.white), // White text color
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white), // White text color
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _groupDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Group description',
                labelStyle: TextStyle(color: Colors.white), // White text color
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white), // White text color
            ),
            BlocConsumer<CreateGroupBloc, CreateGroupState>(
              listener: (context, state) {
                if (state is CreateGroupSuccess) {
                  Navigator.pop(context); // Navigate back to UserHomePage
                } else if (state is CreateGroupFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                if (state is CreateGroupLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
