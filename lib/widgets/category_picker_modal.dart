import 'package:flutter/material.dart';
import '../models/custom_category.dart';
import '../models/expense.dart';

class CategoryPickerModal extends StatefulWidget {
  const CategoryPickerModal({
    super.key,
    required this.isExpense,
    required this.onCategorySelected,
    required this.customCategories,
    required this.onCustomCategoryAdded,
  });

  final bool isExpense;
  final void Function(Category category) onCategorySelected;
  final List<CustomCategory> customCategories;
  final void Function(CustomCategory category) onCustomCategoryAdded;

  @override
  State<CategoryPickerModal> createState() => _CategoryPickerModalState();
}

class _CategoryPickerModalState extends State<CategoryPickerModal> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData _selectedIcon = Icons.category;
  List<Category> _currentCategories = [];
  String? _nameError;

  final List<IconData> _availableIcons = [
    Icons.category,
    Icons.shopping_basket,
    Icons.restaurant,
    Icons.sports_esports,
    Icons.pets,
    Icons.medical_services,
    Icons.home,
    Icons.car_rental,
    Icons.flight,
    Icons.sports,
    Icons.music_note,
    Icons.book,
    Icons.laptop,
    Icons.phone_android,
    Icons.camera_alt,
    Icons.attach_money,
    Icons.account_balance,
    Icons.real_estate_agent,
    Icons.handyman,
    Icons.emoji_events,
  ];

  @override
  void initState() {
    super.initState();
    _updateCategories();
  }

  bool _isDuplicateName(String name) {
    final normalizedName = name.toLowerCase().trim();

    // Check predefined categories
    final predefinedCategories =
        widget.isExpense
            ? Categories.expenseCategories
            : Categories.incomeCategories;
    if (predefinedCategories.any(
      (cat) => cat.name.toLowerCase() == normalizedName,
    )) {
      return true;
    }

    // Check custom categories
    return widget.customCategories.any(
      (cat) =>
          cat.name.toLowerCase() == normalizedName &&
          cat.isExpense == widget.isExpense,
    );
  }

  void _validateName(String value) {
    final normalizedValue = value.trim();
    setState(() {
      if (normalizedValue.isEmpty) {
        _nameError = 'Please enter a category name';
      } else if (_isDuplicateName(normalizedValue)) {
        _nameError = '${normalizedValue} already exists';
      } else {
        _nameError = null;
      }
    });
  }

  void _updateCategories() {
    print('\n=== Updating Categories in CategoryPickerModal ===');
    final predefinedCategories =
        widget.isExpense
            ? Categories.expenseCategories
            : Categories.incomeCategories;

    final customCategoriesForType =
        widget.customCategories
            .where((cat) => cat.isExpense == widget.isExpense)
            .map((cat) {
              print('Converting category: ${cat.name}');
              final converted = Category.fromCustomCategory(cat);
              print(
                'Converted to: ${converted.name} (isCustom: ${converted.isCustom})',
              );
              return converted;
            })
            .toList();

    setState(() {
      _currentCategories = [
        ...predefinedCategories,
        ...customCategoriesForType,
      ];
    });

    print('Updated categories:');
    print(
      '- Predefined (${predefinedCategories.length}): ${predefinedCategories.map((c) => c.name).toList()}',
    );
    print(
      '- Custom (${customCategoriesForType.length}): ${customCategoriesForType.map((c) => c.name).toList()}',
    );
    print('- Total: ${_currentCategories.length}');
  }

  void _showAddCategoryDialog() {
    IconData dialogSelectedIcon = _selectedIcon;
    _nameError = null;
    _nameController.clear();

    showDialog<void>(
      context: context,
      builder:
          (ctx) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: Text(
                    'Add Custom ${widget.isExpense ? 'Expense' : 'Income'} Category',
                    style: const TextStyle(fontSize: 18),
                  ),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _nameController,
                            maxLength: 15,
                            decoration: InputDecoration(
                              labelText: 'Category Name',
                              border: const OutlineInputBorder(),
                              counterText: '',
                              errorText: _nameError,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            onChanged: (value) {
                              setDialogState(() {
                                _validateName(value);
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Select Icon',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 200,
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                              itemCount: _availableIcons.length,
                              itemBuilder: (context, index) {
                                final icon = _availableIcons[index];
                                final isSelected = icon == dialogSelectedIcon;
                                return GestureDetector(
                                  onTap: () {
                                    print('Selected icon: $icon');
                                    setDialogState(() {
                                      dialogSelectedIcon = icon;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? Theme.of(context).primaryColor
                                              : null,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      icon,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _nameController.clear();
                        _nameError = null;
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final name = _nameController.text.trim();
                        _validateName(name);

                        if (name.isNotEmpty && _nameError == null) {
                          final newCategory = CustomCategory(
                            name: name,
                            icon: dialogSelectedIcon,
                            isExpense: widget.isExpense,
                          );

                          print('Creating new category: ${newCategory.name}');
                          widget.onCustomCategoryAdded(newCategory);
                          _nameController.clear();
                          _nameError = null;
                          setState(() {
                            _selectedIcon = Icons.category;
                          });
                          Navigator.pop(context);
                          _updateCategories();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.isExpense
                                ? const Color.fromARGB(255, 255, 82, 82)
                                : const Color.fromARGB(255, 76, 175, 80),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor =
        widget.isExpense
            ? const Color.fromARGB(255, 255, 82, 82)
            : const Color.fromARGB(255, 76, 175, 80);

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isExpense
                ? 'Select Expense Category'
                : 'Select Income Category',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: GridView.count(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children:
                  _currentCategories.map((category) {
                    final isCustom = category.isCustom;
                    return GestureDetector(
                      onTap: () {
                        widget.onCategorySelected(category);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              isCustom
                                  ? accentColor.withOpacity(0.1)
                                  : Colors.grey[200],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              isCustom
                                  ? Border.all(color: accentColor, width: 2)
                                  : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category.icon,
                              size: 32,
                              color: isCustom ? accentColor : Colors.black,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category.name.toUpperCase(),
                              style: TextStyle(
                                color: isCustom ? accentColor : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _showAddCategoryDialog,
            icon: const Icon(Icons.add),
            label: Text(
              'Add Custom ${widget.isExpense ? 'Expense' : 'Income'} Category',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
