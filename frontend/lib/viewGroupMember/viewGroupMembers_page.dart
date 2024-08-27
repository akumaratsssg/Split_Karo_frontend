import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for BLoC
import 'package:frontend/models/group_member.dart';
import 'package:dio/dio.dart';
import 'package:frontend/remove_member/remove_member_bloc/remove_member_bloc.dart'; // Import BLoC
import 'package:frontend/remove_member/remove_member_bloc/remove_member_event.dart'; // Import Events
import 'package:frontend/remove_member/remove_member_bloc/remove_member_state.dart'; // Import States
import 'package:frontend/remove_member/remove_member_repo.dart';


class ViewGroupMembersPage extends StatelessWidget {
  final String groupName;
  final List<GroupMember> groupMembers;
  final dio = Dio();



  ViewGroupMembersPage({
    required this.groupName,
    required this.groupMembers,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemoveMemberBloc(RemoveMemberRepo(dio: dio)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF708090), // Slate gray color
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            groupName,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: Colors.black, // Background color matching the app theme
          padding: EdgeInsets.all(8.0),
          child: BlocConsumer<RemoveMemberBloc, RemoveMemberState>(
            listener: (context, state) {
              if (state is RemoveMemberSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Member removed successfully')),
                );
                // Update UI or perform other actions
              } else if (state is RemoveMemberFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to remove member: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              return ListView.builder(
                itemCount: groupMembers.length,
                itemBuilder: (context, index) {
                  final member = groupMembers[index];
                  return Card(
                    color: Colors.grey[850], // Slightly lighter shade of black for contrast
                    child: ListTile(
                      title: Text(
                        member.userName ?? 'Unknown',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        member.userEmail ?? 'Unknown',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red color for the Remove button
                        ),
                        onPressed: () {
                          // Dispatch the remove member event
                          context.read<RemoveMemberBloc>().add(
                            RemoveMemberRequested(
                              userEmail: member.userEmail,
                              groupName: groupName,
                            ),
                          );
                        },
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
