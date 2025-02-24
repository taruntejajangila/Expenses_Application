import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/custom_category.dart';
import 'category_picker_modal.dart';
import 'Monthly_Overview.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({
    super.key,
    required this.onAddExpense,
    required this.customCategories,
    required this.onCustomCategoryAdded,
    required this.expenses,
  });

  final List<Expense> expenses;
  final void Function(Expense expense, {required bool closeForm}) onAddExpense;
  final List<CustomCategory> customCategories;
  final void Function(CustomCategory category) onCustomCategoryAdded;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _titleFocusNode = FocusNode();
  DateTime _selectedDate = DateTime.now();
  late Category _selectedCategory;
  TransactionType _selectedType = TransactionType.expense;
  List<CustomCategory> _localCustomCategories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = Categories.expenseCategories.first;
    _localCustomCategories = List.from(widget.customCategories);
    print(
      'NewExpense initialized with ${_localCustomCategories.length} custom categories',
    );
  }

  @override
  void didUpdateWidget(NewExpense oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.customCategories != widget.customCategories) {
      setState(() {
        _localCustomCategories = List.from(widget.customCategories);
      });
    }
  }

  String? _titleError;
  String? _amountError;

  Color get _transactionColor =>
      _selectedType == TransactionType.expense
          ? const Color.fromARGB(255, 255, 82, 82)
          : const Color.fromARGB(255, 76, 175, 80);

  void _validateInputs() {
    setState(() {
      if (_titleController.text.trim().isEmpty) {
        _titleError = 'Please enter a title';
      } else {
        _titleError = null;
      }

      final enteredAmount = double.tryParse(_amountController.text);
      if (_amountController.text.isEmpty) {
        _amountError = 'Please enter an amount';
      } else if (enteredAmount == null || enteredAmount <= 0) {
        _amountError = 'Please enter a valid amount';
      } else {
        _amountError = null;
      }
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
      locale: const Locale('en', 'GB'),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _presentCategoryPicker() {
    print('\n=== Opening Category Picker ===');
    print(
      'Current type: ${_selectedType == TransactionType.expense ? "Expense" : "Income"}',
    );
    print(
      'Available custom categories: ${_localCustomCategories.map((c) => "${c.name}(${c.isExpense ? "expense" : "income"})").toList()}',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: CategoryPickerModal(
              isExpense: _selectedType == TransactionType.expense,
              onCategorySelected: (category) {
                print(
                  'Category selected: ${category.name} (isCustom: ${category.isCustom})',
                );
                setState(() {
                  _selectedCategory = category;
                });
                Navigator.pop(context);
              },
              customCategories: _localCustomCategories,
              onCustomCategoryAdded: (category) {
                print('Adding new custom category: ${category.name}');
                widget.onCustomCategoryAdded(category);
                setState(() {
                  _localCustomCategories.add(category);
                });
              },
            ),
          ),
    );
  }

  void _submitExpenseData({bool addAnother = false}) {
    _validateInputs();

    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty || amountIsInvalid) {
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate,
        category: _selectedCategory,
        type: _selectedType,
      ),
      closeForm: !addAnother,
    );

    if (!addAnother) {
      if (Navigator.canPop(context)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MonthlyOverview(expenses: widget.expenses),
          ),
        );
      }
    } else {
      final currentType = _selectedType;
      final currentCategory = _selectedCategory;

      _titleController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _titleError = null;
        _amountError = null;
        _selectedType = currentType;
        _selectedCategory = currentCategory;
      });
      _titleFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedType == TransactionType.expense &&
        !_selectedCategory.isExpense) {
      _selectedCategory = Categories.expenseCategories.first;
    } else if (_selectedType == TransactionType.income &&
        _selectedCategory.isExpense) {
      _selectedCategory = Categories.incomeCategories.first;
    }

    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final transactionTypeText =
        _selectedType == TransactionType.expense ? 'Expense' : 'Income';

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = TransactionType.expense;
                          _selectedCategory =
                              Categories.expenseCategories.first;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                          border: Border.all(
                            color:
                                _selectedType == TransactionType.expense
                                    ? const Color.fromARGB(255, 255, 82, 82)
                                    : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: 220 * 3.14159 / 180,
                              child: Icon(
                                Icons.arrow_downward,
                                color:
                                    _selectedType == TransactionType.expense
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Expense',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    _selectedType == TransactionType.expense
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = TransactionType.income;
                          _selectedCategory = Categories.incomeCategories.first;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                          border: Border.all(
                            color:
                                _selectedType == TransactionType.income
                                    ? const Color.fromARGB(255, 76, 175, 80)
                                    : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: 220 * 3.14159 / 180,
                              child: Icon(
                                Icons.arrow_upward,
                                color:
                                    _selectedType == TransactionType.income
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Income',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    _selectedType == TransactionType.income
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                decoration: InputDecoration(
                  labelText: 'Title',
                  errorText: _titleError,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (_titleError != null) {
                    setState(() {
                      _titleError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  errorText: _amountError,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (_amountError != null) {
                    setState(() {
                      _amountError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _presentCategoryPicker,
                child: TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  controller: TextEditingController(
                    text: _selectedCategory.name.toUpperCase(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: formatter.format(_selectedDate),
                ),
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _presentDatePicker,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onTap: _presentDatePicker,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextButton(
                      onPressed: () => _submitExpenseData(addAnother: true),
                      style: TextButton.styleFrom(
                        foregroundColor: _transactionColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Save $transactionTypeText & Add Another',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () => _submitExpenseData(addAnother: false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _transactionColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Save $transactionTypeText',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
