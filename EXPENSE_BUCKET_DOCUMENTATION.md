# Documentation for lib/models/expense_bucket.dart

## Overview
This class represents a bucket of expenses categorized by a specific category. It provides functionality to manage expenses and calculate the total expenses for the given category.

## ExpenseBucket Class
### Constructor
- `ExpenseBucket({required this.category, required this.expenses})`: Creates an instance of `ExpenseBucket` with the specified category and expenses.
- `ExpenseBucket.forCategory(List<Expense> allExpenses, Category category)`: Creates an instance of `ExpenseBucket` for a specific category from a list of all expenses.

### Properties
- `final Category category`: The category of expenses.
- `final List<Expense> expenses`: The list of expenses in this bucket.

### Methods
- `double get totalExpenses`: Calculates the total expenses in this bucket. Returns a positive value for total expenses and a negative value for income.
