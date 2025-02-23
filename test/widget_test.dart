import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expenses/main.dart';
import 'package:expenses/widgets/expenses.dart';

void main() {
  testWidgets('Expense tracker app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: Expenses()));
  });
}
