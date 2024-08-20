import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart'; // For the Dio HTTP client
import 'package:frontend/user_home/user_home_bloc/user_home_bloc.dart'; // Path to your BLoC file
import 'package:frontend/user_home/user_home_bloc/user_home_event.dart'; // Path to your events file
import 'package:frontend/user_home/user_home_bloc/user_home_state.dart'; // Path to your states file
import 'package:frontend/user_home/user_home_repository.dart'; // Path to your repository file
import 'package:frontend/models/group.dart'; // Path to your Group model
import 'package:frontend/create_group/create_group_bloc/create_group_bloc.dart'; // Path to CreateGroupBloc
import 'package:frontend/create_group/create_group_repo.dart'; // Path to CreateGroupRepo
import 'package:frontend/create_group/create_group_page.dart'; // Path to CreateGroupPage

class UserHomePage extends StatelessWidget {
  final String userName;

  UserHomePage({required this.userName});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final userHomeRepository = UserHomeRepository(dio: dio);
    final createGroupRepository =  CreateGroupRepository(dio: dio);

    return BlocProvider(
      create: (context) => UserHomeBloc(userHomeRepository: userHomeRepository)
        ..add(FetchUserGroups()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Welcome $userName'),
          backgroundColor: Color(0xFF708090), // Slate gray color
          automaticallyImplyLeading: false, // Removes the back icon
        ),
        body: BlocBuilder<UserHomeBloc, UserHomeState>(
          builder: (context, state) {
            if (state is UserHomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserHomeLoaded) {
              if (state.groups.isEmpty) {
                return Center(child: Text('No groups found.', style: TextStyle(color: Colors.white)));
              } else {
                return ListView.builder(
                  itemCount: state.groups.length,
                  itemBuilder: (context, index) {
                    final group = state.groups[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyan, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(group.name, style: TextStyle(color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(group.description, style: TextStyle(color: Colors.white70)),
                              Text('Group created by ${group.adminName}', style: TextStyle(color: Colors.white70)),
                              // Adjusted text for placeholder
                              Text('You owe amount in rupees', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                          onTap: () {
                            // Add navigation logic here if needed
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            } else if (state is UserHomeError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CreateGroupBloc(createGroupRepository: CreateGroupRepository(dio: dio)),
                  child: CreateGroupPage(),
                ),
              ),
            );
          },
          icon: Icon(Icons.add),
          label: Text('Create group'),
        ),
      ),
    );
  }
}
