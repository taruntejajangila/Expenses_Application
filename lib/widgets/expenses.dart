import 'package:flutter/material.dart';
import 'Monthly_Overview.dart'; // Importing the new page

import '../models/expense.dart';
import '../models/custom_category.dart';
import '../widgets/new_expense.dart';
import '../widgets/expenses_list/expense_item.dart';
import '../widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  final List<CustomCategory> _customCategories = [];

  void _openAddExpenseOverlay() {
    print('Opening add expense overlay');
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder:
          (ctx) => NewExpense(
            onAddExpense: _addExpense,
            customCategories: _customCategories,
            onCustomCategoryAdded: _addCustomCategory,
            expenses: _registeredExpenses,
          ),
    );
  }

  void _addExpense(Expense expense, {bool closeForm = true}) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _addCustomCategory(CustomCategory category) {
    setState(() {
      _customCategories.add(category);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Transaction deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No transactions found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: _registeredExpenses.length,
        itemBuilder:
            (ctx, index) => Dismissible(
              key: ValueKey(_registeredExpenses[index].id),
              background: Container(
                color: Theme.of(context).colorScheme.error.withOpacity(0.75),
                margin: EdgeInsets.symmetric(
                  horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                ),
              ),
              onDismissed: (direction) {
                _removeExpense(_registeredExpenses[index]);
              },
              child: ExpenseItem(_registeredExpenses[index]),
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          MonthlyOverview(expenses: _registeredExpenses),
                ),
              );
            },
            icon: const Icon(Icons.navigate_next), // Icon for navigation
          ),
        ],
      ),
      body:
          width < 600
              ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(child: mainContent),
                ],
              )
              : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(child: mainContent),
                ],
              ),
    );
  }
}
