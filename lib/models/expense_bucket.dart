import 'expense.dart';

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, Category category)
    : category = category,
      expenses =
          allExpenses
              .where((expense) => expense.category.id == category.id)
              .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      if (expense.type == TransactionType.expense) {
        sum += expense.amount;
      } else {
        sum -= expense.amount;
      }
    }

    return sum;
  }
}
