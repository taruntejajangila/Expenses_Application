import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'custom_category.dart';

const uuid = Uuid();
final formatter = DateFormat('dd MMM');

enum TransactionType { income, expense }

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.isExpense,
    this.isCustom = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final bool isExpense;
  final bool isCustom;

  factory Category.fromCustomCategory(CustomCategory customCategory) {
    print('Converting CustomCategory to Category:');
    print('  - Name: ${customCategory.name}');
    print('  - IsExpense: ${customCategory.isExpense}');
    print('  - Icon: ${customCategory.icon}');
    print('  - ID: ${customCategory.id}');

    return Category(
      id: customCategory.id,
      name: customCategory.name,
      icon: customCategory.icon,
      isExpense: customCategory.isExpense,
      isCustom: true,
    );
  }

  @override
  String toString() {
    return 'Category(name: $name, isExpense: $isExpense, isCustom: $isCustom)';
  }
}

// Predefined categories
class Categories {
  static const grocery = Category(
    id: 'grocery',
    name: 'Grocery',
    icon: Icons.shopping_cart,
    isExpense: true,
  );
  static const food = Category(
    id: 'food',
    name: 'Food',
    icon: Icons.lunch_dining,
    isExpense: true,
  );
  static const fuel = Category(
    id: 'fuel',
    name: 'Fuel',
    icon: Icons.local_gas_station,
    isExpense: true,
  );
  static const shopping = Category(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_bag,
    isExpense: true,
  );
  static const bills = Category(
    id: 'bills',
    name: 'Bills',
    icon: Icons.receipt,
    isExpense: true,
  );
  static const leisure = Category(
    id: 'leisure',
    name: 'Leisure',
    icon: Icons.movie,
    isExpense: true,
  );
  static const education = Category(
    id: 'education',
    name: 'Education',
    icon: Icons.school,
    isExpense: true,
  );
  static const health = Category(
    id: 'health',
    name: 'Health',
    icon: Icons.health_and_safety,
    isExpense: true,
  );
  static const salary = Category(
    id: 'salary',
    name: 'Salary',
    icon: Icons.payments,
    isExpense: false,
  );
  static const business = Category(
    id: 'business',
    name: 'Business',
    icon: Icons.business,
    isExpense: false,
  );
  static const investment = Category(
    id: 'investment',
    name: 'Investment',
    icon: Icons.trending_up,
    isExpense: false,
  );
  static const freelance = Category(
    id: 'freelance',
    name: 'Freelance',
    icon: Icons.work,
    isExpense: false,
  );
  static const gifts = Category(
    id: 'gifts',
    name: 'Gifts',
    icon: Icons.card_giftcard,
    isExpense: false,
  );

  static List<Category> get expenseCategories => [
    grocery,
    food,
    fuel,
    shopping,
    bills,
    leisure,
    education,
    health,
  ];

  static List<Category> get incomeCategories => [
    salary,
    business,
    investment,
    freelance,
    gifts,
  ];
}

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final TransactionType type;

  String get formattedDate {
    return formatter.format(date);
  }
}
