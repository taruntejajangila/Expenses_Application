import 'package:flutter/material.dart';
import '../../models/expense.dart';
import '../../models/expense_bucket.dart' as bucket;
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenseBuckets,
    required this.onRemoveExpense,
  });

  final List<bucket.ExpenseBucket> expenseBuckets;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // Flatten all expenses from all buckets into a single list
    final allExpenses =
        expenseBuckets.expand((bucket) => bucket.expenses).toList();

    return ListView.builder(
      itemCount: allExpenses.length,
      itemBuilder:
          (ctx, index) => Dismissible(
            key: ValueKey(allExpenses[index].id), // Use the expense's unique ID
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: EdgeInsets.symmetric(
                horizontal:
                    Theme.of(context).cardTheme.margin?.horizontal ?? 16,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 20),
                ],
              ),
            ),
            onDismissed: (direction) {
              onRemoveExpense(allExpenses[index]);
            },
            child: ExpenseItem(allExpenses[index]),
          ),
    );
  }
}
