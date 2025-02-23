import 'package:flutter/material.dart';
import '../models/custom_category.dart';
import '../models/expense.dart';

class CategoryManager extends StatefulWidget {
  const CategoryManager({
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
  State<CategoryManager> createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<CategoryManager> {
  final _nameController = TextEditingController();
  IconData _selectedIcon = Icons.category;

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

  void _showAddCategoryDialog() {
    showDialog<void>(
      context: context,
      builder:
          (ctx) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  title: Text(
                    'Add Custom ${widget.isExpense ? 'Expense' : 'Income'} Category',
                    style: const TextStyle(fontSize: 18),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nameController,
                          maxLength: 15,
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
                            border: OutlineInputBorder(),
                            counterText: '', // Hides the default counter
                          ),
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
                              final isSelected = icon == _selectedIcon;
                              return GestureDetector(
                                onTap: () {
                                  setStateDialog(() {
                                    _selectedIcon = icon;
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
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    icon,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.trim().isNotEmpty) {
                          final newCategory = CustomCategory(
                            name: _nameController.text.trim(),
                            icon: _selectedIcon,
                            isExpense: widget.isExpense,
                          );
                          widget.onCustomCategoryAdded(newCategory);
                          Navigator.pop(context);
                          _nameController.clear();
                          setState(() {
                            _selectedIcon = Icons.category;
                          });
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
    final predefinedCategories =
        widget.isExpense
            ? Categories.expenseCategories
            : Categories.incomeCategories;

    final customCategoriesForType =
        widget.customCategories
            .where((cat) => cat.isExpense == widget.isExpense)
            .map((cat) => Category.fromCustomCategory(cat))
            .toList();

    return Column(
      children: [
        Text(
          widget.isExpense
              ? 'Select Expense Category'
              : 'Select Income Category',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          child: GridView.count(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              ...predefinedCategories.map((category) {
                return _buildCategoryTile(category);
              }),
              ...customCategoriesForType.map((category) {
                return _buildCategoryTile(category);
              }),
            ],
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
    );
  }

  Widget _buildCategoryTile(Category category) {
    return GestureDetector(
      onTap: () {
        widget.onCategorySelected(category);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 32, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              category.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
