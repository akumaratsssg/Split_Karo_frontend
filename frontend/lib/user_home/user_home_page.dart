import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:frontend/user_home/user_home_bloc/user_home_bloc.dart';
import 'package:frontend/user_home/user_home_bloc/user_home_event.dart';
import 'package:frontend/user_home/user_home_bloc/user_home_state.dart';
import 'package:frontend/user_home/user_home_repository.dart';
import 'package:frontend/create_group/create_group_bloc/create_group_bloc.dart';
import 'package:frontend/create_group/create_group_repo.dart';
import 'package:frontend/create_group/create_group_page.dart';
import 'package:frontend/group_details/group_details_page.dart';
import 'package:frontend/logout/logout_bloc/logout_bloc.dart';
import 'package:frontend/logout/logout_bloc/logout_event.dart';
import 'package:frontend/logout/logout_bloc/logout_state.dart';
import 'package:frontend/logout/logout_repo.dart';

class UserHomePage extends StatelessWidget {
  final String userName;

  UserHomePage({required this.userName});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final userHomeRepository = UserHomeRepository(dio: dio);
    final createGroupRepository = CreateGroupRepository(dio: dio);
    final logoutRepository = LogoutRepository(dio: dio);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserHomeBloc(userHomeRepository: userHomeRepository)..add(FetchUserGroups()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(logoutRepository: logoutRepository),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Welcome $userName'),
          backgroundColor: Color(0xFF708090), // Slate gray color
          automaticallyImplyLeading: false, // Removes the back icon
          actions: [
            BlocConsumer<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  // Navigate to the sign-in page after successful logout
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged out successfully')),
                  );
                  Navigator.pop(context);
                } else if (state is LogoutFailure) {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Logout') {
                      BlocProvider.of<LogoutBloc>(context).add(PerformLogout());
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Logout'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice)

                      );
                    }).toList();
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<UserHomeBloc, UserHomeState>(
          builder: (context, state) {
            if (state is UserHomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserHomeLoaded) {
              if (state.groups.isEmpty) {
                return Center(
                  child: Text('No groups found.', style: TextStyle(color: Colors.white)),
                );
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
                              Text('Group created by ${group.adminName}',
                                  style: TextStyle(color: Colors.white70)),
                              Text('You owe amount in rupees',
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupDetailsPage(groupName: group.name),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            } else if (state is UserHomeError) {
              return Center(
                child: Text(state.message, style: TextStyle(color: Colors.red)),
              );
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
                  create: (context) => CreateGroupBloc(createGroupRepository: createGroupRepository),
                  child: CreateGroupPage(),
                ),
              ),
            );
          },
          backgroundColor: Colors.cyan,
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('Create group', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
