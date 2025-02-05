import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category_management_screen.dart';
import '../models/currency_settings.dart';
import '../utils/formatters.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _loadCurrentCurrency();
  }

  Future<void> _loadCurrentCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString(CurrencySettings.prefsKey) ?? 'USD';
    });
  }

  Future<void> _changeCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(CurrencySettings.prefsKey, currencyCode);
    await initializeFormatter(); // Reinitialize formatter with new currency
    setState(() {
      _selectedCurrency = currencyCode;
    });
  }

  void _showCurrencyPicker() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    'Select Currency',
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...CurrencySettings.availableCurrencies.entries.map(
              (entry) => ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.value.symbol,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(entry.value.name),
                subtitle: Text(entry.value.code),
                selected: _selectedCurrency == entry.key,
                onTap: () async {
                  await _changeCurrency(entry.key);
                  if (mounted) Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCurrency = CurrencySettings.availableCurrencies[_selectedCurrency]!;

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: const Text('Settings'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Theme settings
                  Text(
                    'Appearance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.palette_outlined),
                          title: const Text('Theme'),
                          subtitle: const Text('System default'),
                          onTap: () {
                            // TODO: Implement theme selection
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User settings
                  Text(
                    'Preferences',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              selectedCurrency.symbol,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          title: const Text('Currency'),
                          subtitle: Text(selectedCurrency.name),
                          onTap: _showCurrencyPicker,
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_balance_outlined),
                          title: const Text('Manage Accounts'),
                          subtitle: const Text('Add or edit your accounts'),
                          onTap: () {
                            // TODO: Implement account management
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.category_outlined),
                          title: const Text('Categories'),
                          subtitle: const Text('Manage expense categories'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CategoryManagementScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Data settings
                  Text(
                    'Data',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.backup_outlined),
                          title: const Text('Backup & Restore'),
                          subtitle: const Text('Manage your expense data'),
                          onTap: () {
                            // TODO: Implement backup & restore
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_outline),
                          title: const Text('Clear Data'),
                          subtitle: const Text('Delete all expenses'),
                          textColor: theme.colorScheme.error,
                          iconColor: theme.colorScheme.error,
                          onTap: () {
                            // TODO: Implement clear data
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
