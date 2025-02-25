import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentMonthHeader extends StatelessWidget {
  final double currentMonthSpending; // Parameter for current month's spending

  CurrentMonthHeader({required this.currentMonthSpending});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM yyyy').format(now);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            currentMonth,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            'Current Month Spending: \$${currentMonthSpending.toStringAsFixed(2)}', // Displaying current month's spending
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
