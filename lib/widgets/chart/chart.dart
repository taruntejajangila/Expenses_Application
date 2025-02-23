import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<CategoryTotal> _getCategoryTotals() {
    final Map<String, CategoryTotal> categoryTotals = {};

    // Process expenses
    for (final expense in expenses) {
      final categoryId = expense.category.id;
      if (!categoryTotals.containsKey(categoryId)) {
        categoryTotals[categoryId] = CategoryTotal(
          category: expense.category,
          totalAmount: 0,
        );
      }
      categoryTotals[categoryId]!.totalAmount += expense.amount;
    }

    return categoryTotals.values.toList();
  }

  double get maxTotalAmount {
    final totals = _getCategoryTotals();
    return totals.isEmpty
        ? 0
        : totals.map((e) => e.totalAmount).reduce((a, b) => a > b ? a : b);
  }

  double get totalIncome {
    return expenses
        .where((expense) => expense.type == TransactionType.income)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double get totalExpense {
    return expenses
        .where((expense) => expense.type == TransactionType.expense)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final categoryTotals = _getCategoryTotals();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          // Summary Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryCard(
                  title: 'Income',
                  amount: totalIncome,
                  color: Colors.green,
                ),
                _SummaryCard(
                  title: 'Expense',
                  amount: totalExpense,
                  color: Colors.red,
                ),
                _SummaryCard(
                  title: 'Balance',
                  amount: totalIncome - totalExpense,
                  color:
                      (totalIncome - totalExpense) >= 0
                          ? Colors.green
                          : Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final categoryTotal in categoryTotals)
                  ChartBar(
                    fill:
                        maxTotalAmount == 0
                            ? 0
                            : categoryTotal.totalAmount / maxTotalAmount,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children:
                categoryTotals
                    .map(
                      (categoryTotal) => Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              categoryTotal.category.icon,
                              size: 14,
                              color:
                                  isDarkMode
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.7),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              categoryTotal.category.name,
                              style: TextStyle(
                                fontSize: 8,
                                color:
                                    isDarkMode
                                        ? Theme.of(
                                          context,
                                        ).colorScheme.secondary
                                        : Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class CategoryTotal {
  CategoryTotal({required this.category, required this.totalAmount});

  final Category category;
  double totalAmount;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toInt()}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
