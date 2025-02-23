import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class CustomCategory {
  CustomCategory({
    required this.name,
    required this.icon,
    required this.isExpense,
  }) : id = uuid.v4();

  final String id;
  final String name;
  final IconData icon;
  final bool isExpense;
}
