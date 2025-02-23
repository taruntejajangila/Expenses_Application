import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  TransactionType _selectedType = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
        actions: [
          TextButton(
            onPressed: () {
              // Save action
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                _selectedType == TransactionType.expense
                                    ? const Color.fromARGB(255, 255, 82, 82)
                                    : Colors.grey,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedType = TransactionType.expense;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient:
                                    _selectedType == TransactionType.expense
                                        ? const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 255, 82, 82),
                                            Color.fromARGB(255, 255, 123, 123),
                                          ],
                                        )
                                        : null,
                                color:
                                    _selectedType == TransactionType.expense
                                        ? null
                                        : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.rotate(
                                    angle: 220 * 3.14159 / 180,
                                    child: Icon(
                                      Icons.arrow_downward,
                                      color:
                                          _selectedType ==
                                                  TransactionType.expense
                                              ? Colors.white
                                              : Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Expense',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          _selectedType ==
                                                  TransactionType.expense
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 35, color: Colors.grey[300]),
                    SizedBox(
                      width: 130,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                _selectedType == TransactionType.income
                                    ? const Color.fromARGB(255, 76, 175, 80)
                                    : Colors.grey,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedType = TransactionType.income;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient:
                                    _selectedType == TransactionType.income
                                        ? const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 76, 175, 80),
                                            Color.fromARGB(255, 129, 199, 132),
                                          ],
                                        )
                                        : null,
                                color:
                                    _selectedType == TransactionType.income
                                        ? null
                                        : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.rotate(
                                    angle: 220 * 3.14159 / 180,
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color:
                                          _selectedType ==
                                                  TransactionType.income
                                              ? Colors.white
                                              : Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Income',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          _selectedType ==
                                                  TransactionType.income
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
