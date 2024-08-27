import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_member_bloc/add_members_bloc.dart';
import 'add_member_bloc/add_members_event.dart';
import 'add_member_bloc/add_members_state.dart';
import 'add_member_repo.dart';
import 'package:frontend/models/user.dart';

class AddMemberPage extends StatelessWidget {
  final String groupName;

  AddMemberPage({required this.groupName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddMembersBloc(AddMembersRepo()), // Initialize Bloc with repository
      child: _AddMemberPageContent(groupName: groupName),
    );
  }
}

class _AddMemberPageContent extends StatelessWidget {
  final String groupName;

  _AddMemberPageContent({required this.groupName});

  final TextEditingController _searchController = TextEditingController();

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
        title: Text(
          'Add member to $groupName',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF708090), // Slate gray color to match SignInPage
        actions: [
          IconButton(
            icon: const Text('Done'),
            onPressed: () {
              final state = context.read<AddMembersBloc>().state;
              if (state is UserSearchLoaded && state.selectedUser != null) {
                final selectedUser = state.selectedUser!;
                context.read<AddMembersBloc>().add(
                  AddUserToGroupEvent(selectedUser.userEmail, groupName),
                );
                Navigator.pop(context); // Navigate back after adding user
              } else {
                // Handle case when no user is selected or state is not UserSearchLoaded
                // Show a message or provide feedback to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a user')),
                );
              }
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
              controller: _searchController,
              onChanged: (value) {
                if (value.length > 2) {
                  context.read<AddMembersBloc>().add(
                    SearchUserEvent(value),
                  );
                }
              },
              decoration: const InputDecoration(
                labelText: 'Search users',
                labelStyle: TextStyle(color: Colors.white), // White text color
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white), // White text color
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: BlocBuilder<AddMembersBloc, AddMembersState>(
                builder: (context, state) {
                  if (state is UserSearchLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is UserSearchLoaded) {
                    final users = state.users; // List<User>
                    final selectedUser = state.selectedUser;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final isSelected = selectedUser == user;
                        return ListTile(
                          title: Text(user.userName, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(user.userEmail, style: const TextStyle(color: Colors.white70)),
                          tileColor: isSelected ? Colors.cyan.withOpacity(0.2) : null,
                          onTap: () {
                            context.read<AddMembersBloc>().add(
                              SelectUserEvent(user),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is AddMembersError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  }
                  return Center(child: Text('No results', style: const TextStyle(color: Colors.white)));
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}
