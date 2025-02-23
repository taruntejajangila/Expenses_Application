import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Current Month Overview')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Placeholder for current month's spending
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Current Month Spending: \$0.00', // Placeholder value
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Placeholder for recent transactions
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Placeholder for dues & reminders
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Dues & Reminders',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Placeholder for accounts
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Accounts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
