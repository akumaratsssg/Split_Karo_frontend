import 'package:flutter/material.dart';
import 'package:frontend/models/user_balance.dart';

class BalancesPage extends StatelessWidget {
  final String groupName;
  final List<UserBalance> balances;

  BalancesPage({Key? key, required this.groupName, required this.balances}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF708090),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Balances', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.black, // Set the background color of the body to black
        child: balances.isEmpty
            ? Center(child: Text('No balances available', style: TextStyle(color: Colors.white)))
            : ListView.builder(
          itemCount: balances.length,
          itemBuilder: (context, index) {
            final balance = balances[index];
            String message;
            if (balance.balance > 0) {
              message = "${balance.userName} gets back ₹${balance.balance.abs()} in total";
            } else if (balance.balance < 0) {
              message = "${balance.userName} owes ₹${balance.balance.abs()} in total";
            } else {
              message = "${balance.userName} is settled up";
            }

            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.cyan, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
