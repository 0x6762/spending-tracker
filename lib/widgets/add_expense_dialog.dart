import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/account.dart';
import 'package:intl/intl.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _category;
  final _notes = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isFixed = false;
  String _selectedAccountId = DefaultAccounts.checking.id;
  final _dateFormat = DateFormat.yMMMd();

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectCategory() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Category'),
        children: ExpenseCategories.values
            .map((category) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, category.name),
                  child: Row(
                    children: [
                      Icon(category.icon),
                      const SizedBox(width: 8),
                      Text(category.name),
                    ],
                  ),
                ))
            .toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        _category = selected;
      });
    }
  }

  Future<void> _selectAccount() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Account'),
        children: DefaultAccounts.defaultAccounts
            .map((account) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, account.id),
                  child: Row(
                    children: [
                      Icon(
                        account.icon,
                        color: account.color,
                      ),
                      const SizedBox(width: 8),
                      Text(account.name),
                    ],
                  ),
                ))
            .toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedAccountId = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory =
        _category != null ? ExpenseCategories.findByName(_category!) : null;
    final selectedAccount = DefaultAccounts.defaultAccounts
        .firstWhere((account) => account.id == _selectedAccountId);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        title: const Text('Add Expense'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_dateFormat.format(_selectedDate)),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _selectAccount,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Account',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  selectedAccount.icon,
                                  color: selectedAccount.color,
                                ),
                                const SizedBox(width: 8),
                                Text(selectedAccount.name),
                              ],
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _selectCategory,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (selectedCategory != null) ...[
                                  Icon(selectedCategory.icon),
                                  const SizedBox(width: 8),
                                ],
                                Text(selectedCategory?.name ??
                                    'Select a category'),
                              ],
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notes,
                      decoration: const InputDecoration(
                        labelText: 'Notes (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Fixed Monthly Expense'),
                      subtitle: const Text('This expense occurs every month'),
                      value: _isFixed,
                      onChanged: (value) =>
                          setState(() => _isFixed = value ?? false),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text);
                  if (_titleController.text.isEmpty || amount == null) {
                    return;
                  }

                  final expense = Expense(
                    id: const Uuid().v4(),
                    title: _titleController.text,
                    amount: amount,
                    date: _selectedDate,
                    createdAt: DateTime.now(),
                    category: _category,
                    notes: _notes.text.isEmpty ? null : _notes.text,
                    isFixed: _isFixed,
                    accountId: _selectedAccountId,
                  );

                  Navigator.of(context).pop(expense);
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notes.dispose();
    super.dispose();
  }
}
