import 'package:flutter/material.dart';
import 'Monthly_Overview.dart';

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

  @override
  void initState() {
    super.initState();
    print('Expenses widget initialized');
    print('Initial custom categories: ${_customCategories.length}');
  }

  void _openAddExpenseOverlay() {
    print('\n=== Opening Add Expense Overlay ===');
    print(
      'Custom categories before opening: ${_customCategories.map((c) => "${c.name}(${c.isExpense ? "expense" : "income"})").toList()}',
    );

    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder:
          (ctx) => NewExpense(
            onAddExpense: _addExpense,
            customCategories: _customCategories,
            onCustomCategoryAdded: _handleNewCategory,
            expenses: _registeredExpenses,
          ),
    );
  }

  void _handleNewCategory(CustomCategory category) {
    print('\n=== Adding New Category ===');
    print('Name: ${category.name}');
    print('IsExpense: ${category.isExpense}');
    print('ID: ${category.id}');

    // Check if category already exists
    final exists = _customCategories.any(
      (c) =>
          c.name.toLowerCase() == category.name.toLowerCase() &&
          c.isExpense == category.isExpense,
    );

    if (!exists) {
      setState(() {
        _customCategories.add(category);
      });

      print('Category added successfully');
      print(
        'Updated categories: ${_customCategories.map((c) => "${c.name}(${c.isExpense ? "expense" : "income"})").toList()}',
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${category.name} category'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      print('Category already exists');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${category.name} already exists'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _addExpense(Expense expense, {required bool closeForm}) {
    setState(() {
      _registeredExpenses.add(expense);
    });

    if (closeForm && Navigator.canPop(context)) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MonthlyOverview(expenses: _registeredExpenses),
        ),
      );
    }
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
            icon: const Icon(Icons.navigate_next),
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
