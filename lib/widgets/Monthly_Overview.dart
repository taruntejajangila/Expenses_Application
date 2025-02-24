import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../widgets/new_expense.dart';

extension DateTimeExtensions on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

const double CIRCLE_SIZE = 160;
const double CIRCLE_BORDER_WIDTH = 8;
const double CURRENCY_ICON_SIZE = 20;

class MonthlyOverview extends StatefulWidget {
  final List<Expense> expenses;

  const MonthlyOverview({super.key, required this.expenses});

  @override
  State<MonthlyOverview> createState() => _MonthlyOverviewState();
}

class _MonthlyOverviewState extends State<MonthlyOverview> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder:
          (ctx) => WillPopScope(
            onWillPop: () async {
              // Return true to allow pop, false to prevent it
              return true;
            },
            child: NewExpense(
              onAddExpense: _addExpense,
              expenses: widget.expenses,
              customCategories: const [],
              onCustomCategoryAdded: (category) {},
            ),
          ),
    );
  }

  void _addExpense(Expense expense, {required bool closeForm}) {
    setState(() {
      widget.expenses.add(expense);
    });
    if (closeForm && Navigator.canPop(context)) {
      Navigator.pop(context); // Close the modal
    }
  }

  double _calculateCurrentMonthIncome() {
    final now = DateTime.now();
    final currentMonthIncome = widget.expenses.where((expense) {
      return expense.date.month == now.month &&
          expense.date.year == now.year &&
          expense.type == TransactionType.income;
    });
    return currentMonthIncome.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double _calculateCurrentMonthTotal() {
    final now = DateTime.now();
    final currentMonthExpenses = widget.expenses.where((expense) {
      return expense.date.month == now.month &&
          expense.date.year == now.year &&
          expense.type == TransactionType.expense;
    });
    return currentMonthExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
  }

  List<Expense> _getRecentTransactions() {
    final sortedExpenses = List<Expense>.from(widget.expenses)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sortedExpenses.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM').format(DateTime.now());
    final recentTransactions = _getRecentTransactions();

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Monthly Overview'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Spent in ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: currentMonth,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: CIRCLE_SIZE,
                      height: CIRCLE_SIZE,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: CIRCLE_BORDER_WIDTH,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                            angle: 45 * (3.14159 / 180),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.currency_rupee,
                                  size: CURRENCY_ICON_SIZE,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 0),
                                Text(
                                  _calculateCurrentMonthTotal()
                                      .toInt()
                                      .toString(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size.fromHeight(0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Income',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.currency_rupee,
                                size: 16,
                                color: Colors.black,
                              ),
                              Text(
                                _calculateCurrentMonthIncome().toStringAsFixed(
                                  0,
                                ),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(height: 20, width: 1, color: Colors.grey),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size.fromHeight(0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Budget',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.currency_rupee,
                                size: 16,
                                color: Colors.black,
                              ),
                              Text(
                                '0',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(height: 20, width: 1, color: Colors.grey),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size.fromHeight(0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Safe to Spend',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.currency_rupee,
                                size: 16,
                                color: Colors.black,
                              ),
                              Text(
                                '0',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.pie_chart, color: Colors.white),
                      label: const Text(
                        'Categories',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Set Up Budget',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Transactions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _openAddExpenseOverlay,
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                foregroundColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        for (final expense in recentTransactions)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    expense.category.icon,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    expense.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '₹${expense.amount.toInt()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          margin: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Transform.rotate(
                                            angle:
                                                expense.type ==
                                                        TransactionType.expense
                                                    ? 220 * (3.14159 / 180)
                                                    : 220 * (3.14159 / 180),
                                            child: Icon(
                                              expense.type ==
                                                      TransactionType.expense
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward,
                                              size: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      expense.date.isToday()
                                          ? 'Today, ${DateFormat('hh:mm a').format(expense.date)}'
                                          : expense.formattedDate,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                              size: 36,
                              weight: 700,
                            ),
                            onPressed: () {
                              // Handle navigation when clicked
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dues and Reminders',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.pushNamed(context, '/add-reminder');
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('No dues or reminders at the moment'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
