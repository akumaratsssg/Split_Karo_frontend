import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:frontend/add_member/add_member_page.dart';
import 'package:frontend/viewGroupMember/viewGroupMembers_page.dart';
import 'package:frontend/viewGroupMember/viewGroupMemBloc/view_group_mem_bloc.dart';
import 'package:frontend/viewGroupMember/viewGroupMemBloc/view_group_mem_event.dart';
import 'package:frontend/viewGroupMember/viewGroupMemBloc/view_group_mem_state.dart';
import 'package:frontend/viewGroupMember/viewGroupMemRepo.dart';
import 'package:frontend/add_expense/add_expense_page.dart';
import 'package:frontend/getBalances/getBalance_page.dart'; // Import the BalancesPage
import 'package:frontend/getBalances/getBalances_bloc/get_balances_bloc.dart'; // Import the BalancesBloc
import 'package:frontend/getBalances/getBalance_repo.dart'; // Import the BalancesRepository
import 'package:frontend/getBalances/getBalances_bloc/get_balances_state.dart';
import 'package:frontend/getBalances/getBalances_bloc/get_balances_event.dart'; // Ensure this import

class GroupDetailsPage extends StatefulWidget {
  final String groupName;

  GroupDetailsPage({required this.groupName});

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  int selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final List<String> buttonLabels = [
      'Add people to group',
      'View group members',
      'Settle up',
      'Balances'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF708090), // Slate gray color to match UserHomePage
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.groupName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black, // Background color matching UserHomePage
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(buttonLabels.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan, // Fixed cyan color for all buttons
                      ),
                      onPressed: () {
                        setState(() {
                          selectedButtonIndex = index;
                        });
                        if (buttonLabels[index] == 'Add people to group') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMemberPage(groupName: widget.groupName),
                            ),
                          );
                        }
                        if (buttonLabels[index] == 'View group members') {
                          final viewGroupMembersRepo = ViewGroupMembersRepo(dio: dio);
                          final viewGroupMembersBloc = ViewGroupMembersBloc(viewGroupMembersRepo);

                          // Dispatch the event to fetch group members
                          viewGroupMembersBloc.add(FetchGroupMembers(widget.groupName));

                          // Listen for state changes and navigate to the ViewGroupMembersPage
                          viewGroupMembersBloc.stream.listen((state) {
                            if (state is ViewGroupMembersLoaded) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewGroupMembersPage(
                                    groupName: widget.groupName,
                                    groupMembers: state.groupMembers,
                                  ),
                                ),
                              );
                            } else if (state is ViewGroupMembersError) {
                              // Handle error (e.g., show a snackbar)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to load group members: ${state.message}')),
                              );
                            }
                          });
                        }
                        if (buttonLabels[index] == 'Balances') {
                          final balancesRepo = BalancesRepository();
                          final balancesBloc = BalancesBloc(balancesRepo);

                          // Dispatch the event to fetch balances
                          balancesBloc.add(LoadBalances(groupName: widget.groupName));

                          // Listen for state changes and navigate to the BalancesPage
                          balancesBloc.stream.listen((state) {
                            if (state is BalancesLoaded) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  BalancesPage(
                                    groupName: widget.groupName,
                                    balances: state.balances,
                                  ),
                                ),
                              );
                            } else if (state is BalancesError) {
                              // Handle error (e.g., show a snackbar)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to load balances: ${state.message}')),
                              );
                            }
                          });
                        }
                      },
                      child: Text(buttonLabels[index], style: TextStyle(color: Colors.white)),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black, // Background color matching UserHomePage
              child: const Center(
                child: Text(
                  "Group activities will be displayed here.",
                  style: TextStyle(
                    color: Colors.white, // Text color matching UserHomePage
                    fontSize: 16.0, // Font size to match UserHomePage text style
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to AddExpensePage when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpensePage(groupName: widget.groupName),
            ),
          );
        },
        backgroundColor: Colors.cyan, // Cyan background color
        label: Text('Add expense', style: TextStyle(color: Colors.white)), // White label color
        icon: Icon(Icons.add, color: Colors.white), // Add icon with white color
      ),
    );
  }
}
